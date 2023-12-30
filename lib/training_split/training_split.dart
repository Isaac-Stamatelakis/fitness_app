// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/database.dart';
import 'package:fitness_app/training_split/set.dart';

class TrainingSplit {
  final String? name;
  final List<ISession> trainingSessions;
  final String? dbID;

  TrainingSplit({required this.name, required this.trainingSessions, required this.dbID});
}

class ISession {

}
class TrainingSession extends ISession {
  final String? dbID;
  final String name;
  final List<ExerciseBlock> exercises;
  TrainingSession({required this.dbID, required this.name, required this.exercises});
}

class RestSession extends ISession{

}
/// Represents a collection of subsequent sets
class ExerciseBlock {
  final MovementPattern? movementPattern;
  final Exercise? exercise;
  final List<ISet?> sets;

  ExerciseBlock({required this.movementPattern, required this.exercise, required this.sets});
  void add(ISet set) {
    sets.add(set);
  }
}

class TrainingSessionRetriever extends MultiDatabaseRetriever<TrainingSession> {
  final String trainingSplitID;
  TrainingSessionRetriever({required this.trainingSplitID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    // TODO: implement fromDocument
    throw UnimplementedError();
  }  
  @override
  Future<QuerySnapshot<Object?>> getQuerySnapshot() {
    return FirebaseFirestore.instance.collection("StaticSessions").where('training_split_id', isEqualTo: trainingSplitID).get();
  }
}

class TrainingSessionFactory {
  static Future<TrainingSession> fromDocument(DocumentSnapshot snapshot) async {
    var data = snapshot.data() as Map<String, dynamic>;
    return TrainingSession(
      dbID: snapshot.id, name: data['name'], exercises: await decode<SetCollection>(data['exercise_blocks'])
    );
  }

  static Future<List<ExerciseBlock>> decode<T extends ISet>(List<Map<String,dynamic>> blockMap) async {
    List<ExerciseBlock> exerciseBlocks = [];
    for (Map<String,dynamic> json in blockMap) {
      List<ISet?> sets = [];
      for (Map<String, dynamic> setJson in json['sets']) {
        sets.add(SetFactory.fromJson<T>(setJson));
      }
      String exerciseID = json['exercise_id'];
      Exercise? exercise = await SingleExerciseRetriever(dbID: exerciseID).retrieve();
      exerciseBlocks.add(ExerciseBlock(sets: sets, exercise: exercise, movementPattern: exercise?.movementPattern));
    }
    return exerciseBlocks;
  } 


}
