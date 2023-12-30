// ignore_for_file: constant_identifier_names
enum Muscle {
  LowerChest,
  UpperChest,
  FrontDeltoid,
  LateralDeltoid,
  RearDeltoid,
  RotatorCuff,
  Neck,
  Abdominis,
  Obliques,
  LatissimusDorsi,
  Trapezius,
  Rhomboids,
  SpinalErectors,
  Biceps,
  Triceps,
  Brachialis,
  Forearms,
  Quadriceps,
  Hamstrings ,
  Adductors,
  Glutes,
  Calves,
}

class MuscleHelper {
  static String muscleToString(Muscle? muscle) {
    switch (muscle) {
      default:
        return muscle.toString().split(".")[1];
    }
  }
}