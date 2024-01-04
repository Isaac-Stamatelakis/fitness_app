import 'dart:isolate';

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
  static Future<void> uploadSession(ISession session, String? splitID, int index) async {
    Map<String, dynamic>? sessionUpload = TrainingSessionFactory.sessionToJson(session, index, splitID);
    DocumentReference sessionRef = await FirebaseFirestore.instance.collection("StaticSessions").add(sessionUpload!);
    session.dbID = sessionRef.id;
    Logger().i("Session Uploaded: ${sessionRef.id}");
  }

  static Future<void> updateSession(ISession? session, param1, param2) async {
    Map<String, dynamic>? sessionUpload = TrainingSessionFactory.sessionToJson(session, null, null);
    await FirebaseFirestore.instance.collection("StaticSessions").doc(session!.dbID).update(sessionUpload!);
  }

  static Future<void> deleteSession(ISession? session) async {
    await FirebaseFirestore.instance.collection("StaticSessions").doc(session!.dbID).delete();
    Logger().i("Deleted Static Session : ${session.dbID}");
  }
}