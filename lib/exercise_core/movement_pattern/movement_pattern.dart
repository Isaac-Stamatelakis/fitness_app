// ignore_for_file: constant_identifier_names

import 'package:fitness_app/exercise_core/muscle/muscles.dart';

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
  Pullover,
  WristFlexion,
  UndefinedMovement,
  Cardio
}

class MovementPatternFactory {
  static List<Muscle> getMusclesWorked(MovementPattern? movementPattern) {
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
  static String patternToFormattedString(MovementPattern? movementPattern) {
    switch (movementPattern) {
      case MovementPattern.HorizontalPress:
        return "Horizontal Press";
      case MovementPattern.InclinePress:
        return "Incline Press";
      case MovementPattern.VerticlePress:
        return "Vertical Press";
      case MovementPattern.VerticalPull:
        return "Vertical Pull";
      case MovementPattern.HorizontalPull:
        return "Horizontal Pull";
      case MovementPattern.ShoulderAbduction:
        return "Shoulder Abduction";
      case MovementPattern.ShoulderFlexion:
        return "Shoulder Flexion";
      case MovementPattern.ShoulderRotation:
        return "Shoulder Rotation";
      case MovementPattern.LegFlexion:
        return "Leg Flexion";
      case MovementPattern.LegExtension:
        return "Leg Extension";
      case MovementPattern.AnkleExtension:
        return "Ankle Extension";
      case MovementPattern.ElbowFlexion:
        return "Elbow Flexion";
      case MovementPattern.ElbowExtension:
        return "Elbow Extension";
      case MovementPattern.HipAdduction:
        return "Hip Adduction";
      case MovementPattern.HipAdbuction:
        return "Hip Adbuction";
      case MovementPattern.SpinalExtension:
        return "Spinal Extension";
      case MovementPattern.ChestFly:
        return "Chest Fly";
      case MovementPattern.UpperChestFly:
        return "Upper Chest Fly";
      default:
        return patternToString(movementPattern);
    }
  }

  static String patternToString(MovementPattern? movementPattern) {
    if (movementPattern == null) {
      return "";
    }
    return movementPattern.toString().split(".")[1];
  }
  static MovementPattern? stringToPattern(String string) {
    for (MovementPattern movementPattern in MovementPattern.values) {
      if (string == patternToString(movementPattern)) {
        return movementPattern;
      }
    }
    return null;
  }
  static List<MovementPattern> getNoneNullPatterns() {
    List<MovementPattern> patterns = MovementPattern.values
      .where((pattern) => pattern != MovementPattern.UndefinedMovement)
      .toList();
    return patterns;
  }
}

