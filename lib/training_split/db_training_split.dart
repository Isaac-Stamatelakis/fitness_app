import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/database.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:logger/logger.dart';


class TrainingSplitFactory {
  static Future<TrainingSplit> fromDocument(DocumentSnapshot snapshot) async {
    var data = snapshot.data() as Map<String, dynamic>;
    List<ISession> unsortedSessions = await TrainingSplitSessionQuery(dbID: snapshot.id).retrieve();
    return TrainingSplit(
      name: data['name'], 
      trainingSessions: unsortedSessions, 
      dbID: snapshot.id
    );
  }
}
class TrainingSplitRetriever extends DatabaseHelper<TrainingSplit> {
  final String dbID;
  TrainingSplitRetriever({required this.dbID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) async {
    return await TrainingSplitFactory.fromDocument(snapshot);
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("TrainingSplits").doc(dbID);
  }
}


class TrainingSplitSessionQuery {
  final String dbID;

  TrainingSplitSessionQuery({required this.dbID});
  Future<List<TrainingSession>> retrieve() async {
    try {
      QuerySnapshot querySnapshot = await getQuerySnapshot();
      List<TrainingSession?> items = List.filled(querySnapshot.docs.length,null);
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        int index = (documentSnapshot.data() as Map<String, dynamic>)['order'];
        items[index] = (await fromDocument(documentSnapshot));
      }
      List<TrainingSession> nonNullItems = [];
      for (TrainingSession? trainingSession in items) {
        if (trainingSession != null) {
          nonNullItems.add(trainingSession);
        }
      }
      return nonNullItems;
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return [];
    }
  }
  Future<TrainingSession> fromDocument(DocumentSnapshot<Object?> snapshot) async {
    return await TrainingSessionFactory.fromDocument(snapshot);
  }
  
  Future<QuerySnapshot<Object?>> getQuerySnapshot() {
    return FirebaseFirestore.instance.collection("StaticSessions").where('training_split_id', isEqualTo: dbID).get();
  }
}

class SessionUploader {
  static void uploadSession(ISession session, String splitID, int index) async {
    if (session is TrainingSession) {
      List<Map<String,dynamic>> exercise_blocks = [];
      for (IBlock block in session.exerciseBlocks) {
        String exercise_id = "";
        String variation_id = "";
        if (block.exercise != null) {
          exercise_id = block.exercise!.dbID;
          if (block.variation != null) {
            variation_id = block.variation!.dbID;
          }
        }
        Map<String,dynamic> blockJson = {
          'exercise_id' : exercise_id,
          'variation_id' : variation_id,
          'movement_pattern': MovementPatternFactory.patternToString(block.movementPattern)
        };

        if (block is CardioBlock) {
          blockJson['sets'] = [
            {
              'type':'Cardio',
              'duration': block.set!.duration
            }
          ];
          exercise_blocks.add(blockJson);
        } else if (block is ExerciseBlock) {
          List<Map<String, dynamic>> sets = [];
          for (ISet? set in block.sets!) {
            if (set is LiftingSet) {
              LiftingSetFactory.cleanUpStaticSetData(set);
              set.data['type'] = SetFactory.liftingSetTypeToString(set.type);
              sets.add(set.data);
            }
          }
          blockJson['sets'] = sets;
          exercise_blocks.add(blockJson);
        }
      }
      Map<String,dynamic> sessionUpload = {
        'exercise_blocks': exercise_blocks,
        'name' : session.name,
        'order' : index,
        'training_split_id' : splitID
      };
    DocumentReference sessionRef = await FirebaseFirestore.instance.collection("StaticSessions").add(sessionUpload);
    Logger().i("Session Uploaded: ${sessionRef.id}");
    }
  }
}