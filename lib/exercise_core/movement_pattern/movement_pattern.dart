// ignore_for_file: constant_identifier_names
import 'package:fitness_app/exercise_core/muscles.dart';

enum MovementPattern {
  Squat,
  Hinge,
  Lunge,
  HorizontalPress,
  VerticlePress,
  InclinePress,
  VerticalPull,
  HorizontalPull,
  ShoulderAbduction,
  ShoulderFlexion,
  ShoulderRotation,
  ShoulderHorizontalAbduction,
  LegFlexion,
  LegExtension,
  AnkleExtension,
  ElbowFlexion,
  ElbowExtension,
  HipAdduction,
  HipAdbuction,
  SpinalExtension,
  Core,
  ChestFly,
  UpperChestFly,
  Undefined
}

class MovementPatternMuscleFactory {
  static List<Muscle> getMusclesWorked(MovementPattern movementPattern) {
    switch (movementPattern) {
      case MovementPattern.Squat:
        return [Muscle.Quadriceps,Muscle.Glutes,Muscle.Adductors];
      case MovementPattern.Hinge:
        return [Muscle.Hamstrings,Muscle.Glutes,Muscle.SpinalErectors];
      case MovementPattern.Lunge:
        return [Muscle.Quadriceps, Muscle.Hamstrings, Muscle.Glutes, Muscle.Calves];
      case MovementPattern.HorizontalPress:
        return [Muscle.LowerChest, Muscle.FrontDeltoid, Muscle.Triceps];
      case MovementPattern.InclinePress:
        return [Muscle.LowerChest, Muscle.UpperChest, Muscle.FrontDeltoid, Muscle.Triceps];
      case MovementPattern.VerticlePress:
        return [Muscle.FrontDeltoid, Muscle.Triceps];
      case MovementPattern.VerticalPull:
        return [Muscle.LatissimusDorsi, Muscle.Rhomboids, Muscle.Biceps];
      case MovementPattern.HorizontalPull:
        return [Muscle.LatissimusDorsi, Muscle.Rhomboids, Muscle.Biceps];
      case MovementPattern.ShoulderAbduction:
        return [Muscle.LateralDeltoid];
      case MovementPattern.ShoulderFlexion:
        return [Muscle.FrontDeltoid, Muscle.LowerChest];
      case MovementPattern.ShoulderRotation:
        return [Muscle.RotatorCuff];
      case MovementPattern.LegFlexion:
        return [Muscle.Hamstrings];
      case MovementPattern.LegExtension:
        return [Muscle.Quadriceps];
      case MovementPattern.AnkleExtension:
        return [Muscle.Calves];
      case MovementPattern.ElbowFlexion:
        return [Muscle.Biceps, Muscle.Brachialis, Muscle.Forearms];
      case MovementPattern.ElbowExtension:
        return [Muscle.Triceps];
      case MovementPattern.HipAdduction:
        return [Muscle.Adductors];
      case MovementPattern.HipAdbuction:
        return [Muscle.Glutes];
      case MovementPattern.Core:
        return [Muscle.Abdominis];
      case MovementPattern.SpinalExtension:
        return [Muscle.SpinalErectors];
      case MovementPattern.ChestFly:
        return [Muscle.LowerChest, Muscle.FrontDeltoid];
      case MovementPattern.UpperChestFly:
        return [Muscle.LowerChest, Muscle.UpperChest, Muscle.FrontDeltoid];
      default:
        return [];
    }
  }
  static String movementPatternToString(MovementPattern movementPattern) {
    return movementPattern.toString().split(".")[1];
  }
}

