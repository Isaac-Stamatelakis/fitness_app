import 'package:fitness_app/exercise_core/exercise/exercise.dart';

class ExerciseVariation extends Exercise{
  ExerciseVariation(super.exerciseName, this.variationName, {required super.movementPattern});
  final String variationName;
}
