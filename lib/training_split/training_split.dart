// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/database.dart';
import 'package:fitness_app/training_split/page/list_training.dart';
import 'package:fitness_app/training_split/page/page_training_split.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:flutter/material.dart';

class TrainingSplit {
  final String? name;
  final List<ISession> trainingSessions;
  final String? dbID;

  TrainingSplit({required this.name, required this.trainingSessions, required this.dbID});
}

abstract class ISession {
  final String? dbID;
  late String name;
  ISession({required this.dbID, required this.name});
}
class TrainingSession extends ISession {
  final List<IBlock> exerciseBlocks;
  TrainingSession({required super.dbID, required super.name, required this.exerciseBlocks});
}



class IBlock {
  late MovementPattern? movementPattern;
  late IExercise? exercise;
  late ExerciseVariation? variation;

  IBlock(this.variation, {required this.movementPattern, required this.exercise});
}
/// Represents a collection weight lighting subsequent sets of the same exercise
class ExerciseBlock extends IBlock {
  final List<ISet?>? sets;
  ExerciseBlock(super.variation, {required this.sets, required super.movementPattern, required super.exercise});
}
class CardioBlock extends IBlock {
  late CardioSet? set;
  CardioBlock(super.variation, {required super.movementPattern, required super.exercise, required this.set});
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
      dbID: snapshot.id, name: data['name'], exerciseBlocks: await decode<LiftingSet>(data['exercise_blocks'])
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
      String? variationID = json['variation_id'];
      IExercise? exercise = await SingleExerciseRetriever(dbID: exerciseID).retrieve();
      ExerciseVariation? variation;
      if (variationID != null && variationID.isNotEmpty) {
        variation = await ExerciseVariationRetriever(dbID: variationID).fromDatabase();
      }
      
      exerciseBlocks.add(ExerciseBlock(variation, sets: sets, exercise: exercise, movementPattern: exercise?.movementPattern));
    }
    return exerciseBlocks;
  } 

  static Widget? toText(ISession? session) {
    TextStyle textStyle = const TextStyle(
      color: Colors.white
    );
    if (session is TrainingSession) {
      return Text(
        session.name,
        style: textStyle,
      );
    } 
    return null;
  }

  static Widget generateBlockList(ISession? session) {
    if (session is TrainingSession) {
      return TrainingBlockList(blocks: session.exerciseBlocks);
    }
    return Container();
  }


}
