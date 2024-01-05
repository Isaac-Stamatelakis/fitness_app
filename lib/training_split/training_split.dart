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
  late String? name;
  final List<ISession> trainingSessions;
  final String? dbID;

  TrainingSplit({required this.name, required this.trainingSessions, required this.dbID});
}

abstract class ISession {
  late String? dbID;
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


class TrainingSessionFactory {

  static Map<String, dynamic>? sessionToJson(ISession? session, int? index, String? splitID) {
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
      };
      if (index != null) {
        sessionUpload['order'] = index;
      }
      if (splitID != null) {
        sessionUpload['training_split_id'] = splitID;
      }
     
      return sessionUpload;
    }
   
    return null;
  }

  static Future<TrainingSession> fromDocument(DocumentSnapshot snapshot) async {
    var data = snapshot.data() as Map<String, dynamic>;
    return TrainingSession(
      dbID: snapshot.id, name: data['name'], exerciseBlocks: await decode<LiftingSet>(data['exercise_blocks'])
    );
  }

  static Future<List<IBlock>> decode<T extends ISet>(List<dynamic> listMap) async {
    List<IBlock> blocks = [];
    if (listMap.isEmpty) {
      return [];
    }
    for (dynamic val in listMap) {
      Map<String,dynamic> json = val as Map<String,dynamic>;
      String exerciseID = json['exercise_id'];
      String? variationID = json['variation_id'];
      IExercise? exercise;
      ExerciseVariation? variation;
      MovementPattern? movementPattern = MovementPatternFactory.stringToPattern(json['movement_pattern']);
      if (exerciseID.isNotEmpty) {
        exercise = await SingleExerciseRetriever(dbID: exerciseID).retrieve();
        if (variationID != null && variationID.isNotEmpty) {
          variation = await ExerciseVariationRetriever(dbID: variationID).fromDatabase();
        }
      }
      List<ISet?> sets = [];
      _BlockTypeOption? blockTypeOption;
      List<dynamic> list = json['sets'];
      if (list.isEmpty) {
        blocks.add(ExerciseBlock(variation, sets: sets, movementPattern: movementPattern, exercise: exercise));
        continue;
      }
      for (dynamic setVal in json['sets']) {
        Map<String,dynamic> setJson = setVal as Map<String,dynamic>;
        if (setJson['type'] == "Cardio") {
          sets.add(CardioSet(duration: setJson['duration']));
          blockTypeOption = _BlockTypeOption.Cardio;
          continue;
        }
        for (LiftingSetType type in LiftingSetType.values) {
          if (setVal['type'] == SetFactory.liftingSetTypeToString(type)) {
            sets.add(LiftingSet(type: type, data: setJson));
            blockTypeOption = _BlockTypeOption.Lifting;
          }
        }
      }
      switch (blockTypeOption) {
        case null:
          // Do nothing
        case _BlockTypeOption.Cardio:
          blocks.add(CardioBlock(variation, movementPattern: MovementPattern.Cardio, exercise: exercise, set: sets[0] as CardioSet));
        case _BlockTypeOption.Lifting:
          blocks.add(ExerciseBlock(variation, sets: sets, movementPattern: movementPattern, exercise: exercise));
      }
    }
    return blocks;
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
      return TrainingBlockList(blocks: session.exerciseBlocks, session: session, scrollDirection: Axis.vertical);
    }
    return Container();
  }


}

enum _BlockTypeOption {
  Cardio,
  Lifting,
}
