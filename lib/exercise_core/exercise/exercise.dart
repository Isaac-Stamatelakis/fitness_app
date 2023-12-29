import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscles.dart';
import 'package:fitness_app/misc/database.dart';

/// Represents an exercise. Has name and movement pattern that the exercise belongs to
class Exercise {
  Exercise(this.exerciseName, {required this.movementPattern});
  final MovementPattern movementPattern;
  final String exerciseName;
  List<Muscle> getMusclesWorked() {
    return MovementPatternMuscleFactory.getMusclesWorked(movementPattern);
  }
}


class ExerciseFactory {
  static Exercise fromDocument(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    MovementPattern exercisePattern = MovementPattern.Undefined;
    for (MovementPattern movementPattern in MovementPattern.values) {
      if (data['movementPattern'] == MovementPatternMuscleFactory.movementPatternToString(movementPattern)) {
        exercisePattern = movementPattern;
      }
    }
    return Exercise(data['name'], movementPattern: exercisePattern);
  }
}




/// Retrieves exercises from preset collection which are preincluded and immutable by user
class PresetExerciseRetriever {
  Future<List<Exercise>> retrieve() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("PresetExercises").get();
    List<Exercise> exercises = [];
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      exercises.add(ExerciseFactory.fromDocument(documentSnapshot));
    }
    return exercises;
  }
}

/// Retrives exercises from users exercise collection
class CustomExerciseRetriever {
  final String ownerID;
  CustomExerciseRetriever({required this.ownerID});
  Future<List<Exercise>> retrieve() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("CustomExercises").where('owner_id', isEqualTo: ownerID).get();
    List<Exercise> exercises = [];
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      exercises.add(ExerciseFactory.fromDocument(documentSnapshot));
    }
    return exercises;
  }
}

/// Retrives combination of user custom exercises and presets
class EntireExerciseRetriever {
  final String ownerID;
  EntireExerciseRetriever({required this.ownerID});
  Future<List<Exercise>> retrieve() async {
    List<Exercise> exercises = [];
    exercises.addAll(await CustomExerciseRetriever(ownerID: ownerID).retrieve());
    exercises.addAll(await PresetExerciseRetriever().retrieve());
    return exercises;
  }
}


/// Deprecated, now on database, still here cause this took too much time to make
class PreSetExercises {
  static List<Exercise> getPresets() {
    return [
      Exercise("Bench Press", movementPattern: MovementPattern.HorizontalPress),
      Exercise("Incline Bench Press", movementPattern: MovementPattern.InclinePress),
      Exercise("Dumbbell Bench Press", movementPattern: MovementPattern.HorizontalPress),
      Exercise("Machine Chest Press", movementPattern: MovementPattern.HorizontalPress),
      Exercise("Machine Shoulder Press", movementPattern: MovementPattern.VerticlePress),
      Exercise("Dumbell Shoulder Press", movementPattern: MovementPattern.VerticlePress),
      Exercise("Overhead Press", movementPattern: MovementPattern.VerticlePress),
      Exercise("Incline Dumbbell Bench Press", movementPattern: MovementPattern.InclinePress),
      Exercise("JM Press", movementPattern: MovementPattern.ElbowExtension),
      Exercise("Cable Lateral Raise", movementPattern: MovementPattern.ShoulderAbduction),
      Exercise("Dumbbell Lateral Raise", movementPattern: MovementPattern.ShoulderAbduction),
      Exercise("Lat Pulldown", movementPattern: MovementPattern.VerticalPull),
      Exercise("Pullup", movementPattern: MovementPattern.VerticalPull),
      Exercise("Bentover Row", movementPattern: MovementPattern.HorizontalPull),
      Exercise("Machine Row", movementPattern: MovementPattern.HorizontalPull),
      Exercise("Rear Delt Machine Fly", movementPattern: MovementPattern.ShoulderHorizontalAbduction),
      Exercise("Rear Delt Dumbbell Fly", movementPattern: MovementPattern.ShoulderHorizontalAbduction),
      Exercise("Dumbbell Bicep Curl", movementPattern: MovementPattern.ElbowFlexion),
      Exercise("Cable Bicep Curl", movementPattern: MovementPattern.ElbowFlexion),
      Exercise("Preacher Curl", movementPattern: MovementPattern.ElbowFlexion),
      Exercise("Hammer Curl", movementPattern: MovementPattern.ElbowFlexion),
      Exercise("Calf Raise", movementPattern: MovementPattern.AnkleExtension),
      Exercise("Barbell Squat", movementPattern: MovementPattern.Squat),
      Exercise("Barbell Deadlift", movementPattern: MovementPattern.Hinge),
      Exercise("Good Mornings", movementPattern: MovementPattern.Hinge),
      Exercise("Romanian Deadlifts", movementPattern: MovementPattern.Hinge),
      Exercise("Leg Extension", movementPattern: MovementPattern.LegExtension),
      Exercise("Leg Press", movementPattern: MovementPattern.LegExtension),
      Exercise("Hack Squat", movementPattern: MovementPattern.Squat),
      Exercise("Seated Leg Curl", movementPattern: MovementPattern.LegFlexion),
      Exercise("Lying Leg Curl", movementPattern: MovementPattern.LegFlexion),
      Exercise("Split Squat", movementPattern: MovementPattern.LegExtension),
      Exercise("Dumbbell Lunges", movementPattern: MovementPattern.Lunge),
      Exercise("Hip Adduction", movementPattern: MovementPattern.HipAdduction),
      Exercise("Hip Adbuction", movementPattern: MovementPattern.HipAdbuction),
      Exercise("Pec Deck", movementPattern: MovementPattern.ChestFly),
      Exercise("Cable Chest Fly", movementPattern: MovementPattern.ChestFly),
      Exercise("Cable Upper Chest Fly", movementPattern: MovementPattern.UpperChestFly),
      Exercise("Crunches", movementPattern: MovementPattern.Core),
      Exercise("Leg Raises", movementPattern: MovementPattern.Core),
    ];
  }

  
}
