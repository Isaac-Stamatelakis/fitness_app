// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';

/// Represents an exercise. Has name and movement pattern that the exercise belongs to
class IExercise {
  final ExerciseType exerciseType;
  IExercise({required this.movementPattern, required this.exerciseName, required this.dbID, required this.exerciseType});
  final MovementPattern? movementPattern;
  final String exerciseName;
  List<Muscle> getMusclesWorked() {
    return MovementPatternFactory.getMusclesWorked(movementPattern);
  }
  final String dbID;
}

enum ExerciseType {
  Custom,
  Preset
}
class ExerciseFactory {
  static IExercise fromDocument(DocumentSnapshot snapshot, ExerciseType type) {
    var data = snapshot.data() as Map<String, dynamic>;
    MovementPattern? exercisePattern;
    for (MovementPattern movementPattern in MovementPattern.values) {
      if (data['movementPattern'] == MovementPatternFactory.patternToString(movementPattern)) {
        exercisePattern = movementPattern;
      }
    }
    return IExercise(
      movementPattern: exercisePattern, exerciseName: data['name'], dbID: snapshot.id, exerciseType: type);
  }
}
