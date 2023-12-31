import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';

/// Represents an exercise. Has name and movement pattern that the exercise belongs to
class Exercise {
  Exercise(this.exerciseName, this.dbID, {required this.movementPattern});
  final MovementPattern? movementPattern;
  final String exerciseName;
  List<Muscle> getMusclesWorked() {
    return MovementPatternFactory.getMusclesWorked(movementPattern);
  }
  final String dbID;
}


class ExerciseFactory {
  static Exercise fromDocument(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    MovementPattern? exercisePattern;
    for (MovementPattern movementPattern in MovementPattern.values) {
      if (data['movementPattern'] == MovementPatternFactory.movementPatternToString(movementPattern)) {
        exercisePattern = movementPattern;
      }
    }
    return Exercise(data['name'], movementPattern: exercisePattern, snapshot.id);
  }
}
