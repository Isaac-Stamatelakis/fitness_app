import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';

/// Represents an exercise. Has name and movement pattern that the exercise belongs to
class IExercise {
  IExercise(this.exerciseName, this.dbID, {required this.movementPattern});
  final MovementPattern? movementPattern;
  final String exerciseName;
  List<Muscle> getMusclesWorked() {
    return MovementPatternFactory.getMusclesWorked(movementPattern);
  }
  final String dbID;
}

/// Represents an exercise from presets. Is immutable to user
class PresetExercise extends IExercise {
  PresetExercise(super.exerciseName, super.dbID, {required super.movementPattern});

}

/// Represents an exercise that the user created.
class UserExercise extends IExercise {
  UserExercise(super.exerciseName, super.dbID, {required super.movementPattern});
}
class ExerciseFactory {
  static IExercise fromDocument<T extends IExercise>(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    MovementPattern? exercisePattern;
    for (MovementPattern movementPattern in MovementPattern.values) {
      if (data['movementPattern'] == MovementPatternFactory.patternToString(movementPattern)) {
        exercisePattern = movementPattern;
      }
    }
    if (T is PresetExercise) {
      return PresetExercise(data['name'], movementPattern: exercisePattern, snapshot.id);
    } else if (T is UserExercise) {
      return UserExercise(data['name'], movementPattern: exercisePattern, snapshot.id);
    }
    return IExercise(data['name'], movementPattern: exercisePattern, snapshot.id);
  }
}
