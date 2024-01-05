
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:fitness_app/record_session/tracking_set.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RecordedTrainingSession {
  late String? dbID;
  late String? staticSessionID;
  late String? name;
  late DateTime? date;
  late List<TrackedBlock?>? blocks;

  RecordedTrainingSession({required this.staticSessionID, required this.name, required this.blocks, required this.dbID, required this.date});
  
}
class TrackedBlock extends IBlock {
  TrackedBlock(super.variation, {required super.movementPattern, required super.exercise, required this.sets});
  late List<TrackedSet> sets;
}

class TrackedBlockFactory {
  static RecordedTrainingSession staticToRecordedSession(TrainingSession? session) {
    List<TrackedBlock?> trackedBlocks = [];
    for (IBlock? block in session!.exerciseBlocks) {
      trackedBlocks.add(blockToTrackedBlock(block));
    }
    return RecordedTrainingSession(
      staticSessionID: session.dbID!, 
      name: session.name, 
      blocks: trackedBlocks,
      dbID: null,
      date: DateTime.now()
    );
  }

  static Future<RecordedTrainingSession> fromDocument(DocumentSnapshot snapshot) async {
    var json = GlobalHelper.docToJson(snapshot);
    List<TrackedBlock> blocks = [];
    for (dynamic blockMap in json['exercise_blocks']) {
      List<TrackedSet> sets = [];
      for (dynamic setMap in blockMap['sets']) {
        sets.add(TrackedSet(type: stringToTrackedSetType(setMap['type']), data: setMap));
      }
      MovementPattern pattern = MovementPatternFactory.stringToPattern(blockMap['movementPattern'])!;
      IExercise? exercise;
      if (blockMap['exercise_id'] != null && blockMap['exercise_id'].isNotEmpty) {
        exercise = await SingleExerciseRetriever(dbID: blockMap['exercise_id']).retrieve();
      }
      ExerciseVariation? variation;
      if (blockMap['variation_id'] != null && blockMap['variation_id'].isNotEmpty) {
        variation = await ExerciseVariationRetriever(dbID: blockMap['variation_id']).fromDatabase();
      }
      blocks.add(
        TrackedBlock(variation, movementPattern: pattern, exercise: exercise, sets: sets)
      );
    }
    Timestamp dateTime = json['created'];
    return RecordedTrainingSession(
      staticSessionID: json['static_session_id'], 
      name: json['name'], 
      blocks: blocks, dbID: 
      snapshot.id, 
      date: dateTime.toDate()
    );
  }
  static TrackedBlock? blockToTrackedBlock(IBlock? block) {
    if (block is TrackedBlock) {
      return null;
    }
    TrackedBlock returnBlock = TrackedBlock(block!.variation, movementPattern: block.movementPattern, exercise: block.exercise, sets: []);
    List<TrackedSet> sets = [];
    if (block is ExerciseBlock) {
      for (ISet? set in block.sets!) {
        if (set is LiftingSet) {
          if (set.type == LiftingSetType.Standard || set.type == LiftingSetType.IntegratedLengthenedPartialSet || set.type == LiftingSetType.LengthenedPartialSet) {
            int? amount = int.parse(set.data['amount']);
            for (int i = 0; i < amount; i ++) {
              Map<String,dynamic> goalMap = set.data;
              goalMap['reps']= null;  goalMap['weight']= null;
              sets.add(TrackedSet(
                type: liftingSetToTracked(set.type)!,
                data: goalMap
              ));
            }
              } else if (set.type == LiftingSetType.DropSet) {
                Map<String,dynamic> goalMap = set.data;
                goalMap['reps'] = null; goalMap['start_weight'] = null; goalMap['end_weight'] = null;
                sets.add(TrackedSet(
                type: liftingSetToTracked(set.type)!,
                data: goalMap
              ));
            }
          }
        }
      } else if (block is CardioBlock) {
      sets.add(TrackedSet(
        type: TrackedSetType.Cardio,
        data: {
          'target_duration' : block.set!.duration,
          'duration' : 0,
          'calories_burned': 0,
        }
      ));
    } 
    returnBlock.sets = sets;
    return returnBlock;
  }

  static TrackedSetType? liftingSetToTracked(LiftingSetType? type) {
    switch (type) {
      case LiftingSetType.Standard:
        return TrackedSetType.Standard;
      case LiftingSetType.DropSet:
        return TrackedSetType.DropSet;
      case LiftingSetType.LengthenedPartialSet:
        return TrackedSetType.LengthenedPartialSet;
      case LiftingSetType.IntegratedLengthenedPartialSet:
        return TrackedSetType.IntegratedLengthenedPartialSet;
      case null:
        return null;
    }
  }

  static TrackedSetType? stringToTrackedSetType(String string) {
    for (TrackedSetType type in TrackedSetType.values) {
      if (type.toString().split(".")[1] == string) {
        return type;
      }
    }
    return null;
  }
}


class RecordedTrainingSessionDBCom {
  static Map<String,dynamic> toJson(RecordedTrainingSession? session, User? user) {
    List<Map<String, dynamic>> blockListMap = [];
    for (TrackedBlock? block in session!.blocks!) {
      List<Map<String,dynamic>> sets = [];
      for (TrackedSet? trackedSet in block!.sets) {
        trackedSet!.data['type'] = trackedSet.type.toString().split(".")[1];
        sets.add(trackedSet.data);
      }
      String exercise_id;
      if (block.exercise == null) {
        exercise_id = "";
      } else {
        exercise_id = block.exercise!.dbID;
      }
      String variation_id;
      if (block.variation == null) {
        variation_id = "";
      } else {
        variation_id = block.variation!.dbID;
      }
      blockListMap.add({
        'exercise_id' : exercise_id,
        'variation_id': variation_id,
        'movementPattern': MovementPatternFactory.patternToString(block.movementPattern),
        'sets':sets
      });
    }
    String user_id = "";
    if (user != null) {
      user_id = user.dbID!;
    }
    return {
      'name': session.name,
      'static_session_id' : session.staticSessionID,
      'exercise_blocks': blockListMap,
      'created' : session.date,
      'owner_id' : user_id
    };
  }
  static Future<String?> upload(RecordedTrainingSession? session, User user) async {
    if (session == null) {
      return null;
    }
    if (session.dbID != null && session.dbID!.isNotEmpty) {
      return null;
    }
    dynamic json = toJson(session,user);
    
    DocumentReference reference = await FirebaseFirestore.instance.collection("RecordedSessions").add(json);
    session.dbID = reference.id;
    user.currentSessionID = session.dbID;
    Logger().i("Uploaded Recorded Session: ${reference.id}");
    FirebaseFirestore.instance.collection("Users").doc(user.dbID).update({
      'current_session_id' : session.dbID
    });
    return reference.id;
  }
  static Future<void> update(RecordedTrainingSession? session, User? user) async {
    if (session == null) {
      return;
    }
    if (session.dbID == null || session.dbID!.isEmpty) {
      return;
    }

    dynamic json = toJson(session, user);
    await FirebaseFirestore.instance.collection("RecordedSessions").doc(session.dbID).update(json);
  }
}
