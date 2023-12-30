// ignore_for_file: constant_identifier_names

import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/training_split/set.dart';
import 'package:fitness_app/training_split/training_split.dart';

enum TrainingSplitPreset {
 PushPullLeg,
 BroSplit,
 UpperLower,
 Custom 
}

class TrainingSplitPresetFactory {
  String presetToString(TrainingSplitPreset preset) {
    switch (preset) {
      case TrainingSplitPreset.PushPullLeg:
        return "Push/Pull/Legs";
      case TrainingSplitPreset.BroSplit:
        return "Bro Split";
      case TrainingSplitPreset.UpperLower:
        return "Upper/Lower";
      default:
        return preset.toString().split(".")[1];
    }
  }

  TrainingSplit? buildSplit(TrainingSplitPreset preset) {
    switch (preset) {
      case TrainingSplitPreset.PushPullLeg:
        return TrainingSplit(
          name: "Push/Pull/Leg",
          dbID: null,
          trainingSessions: [
            TrainingSession(
              dbID: null, 
              name: "Push", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.VerticlePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.InclinePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ShoulderAbduction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Pull", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.VerticalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.Pullover, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.WristFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Leg", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.Squat, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.AnkleExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HipAdbuction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.SpinalExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Push", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.VerticlePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.InclinePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ShoulderAbduction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Pull", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.VerticalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.Pullover, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.WristFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Leg", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.Squat, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.AnkleExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HipAdbuction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.SpinalExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ]
            ),
            RestSession()
          ],
        );
      case TrainingSplitPreset.BroSplit:
        return TrainingSplit(
          name: "Bro Split",
          dbID: null,
          trainingSessions: [
            TrainingSession(
              dbID: null, 
              name: "Chest", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.InclinePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ChestFly, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.UpperChestFly, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Back", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.VerticalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.Pullover, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.VerticalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPull, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Leg", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.Squat, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.AnkleExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HipAdbuction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.SpinalExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Shoulders", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.InclinePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ShoulderAbduction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ShoulderFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.InclinePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ShoulderHorizontalAbduction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Arms", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.WristFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            RestSession(),
            RestSession()
          ],
        );
      case TrainingSplitPreset.UpperLower:
        return TrainingSplit(
          name: "Upper/Lower",
          dbID: null,
          trainingSessions: [
            TrainingSession(
              dbID: null, 
              name: "Upper1", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.HorizontalPress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ElbowExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.InclinePress, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.ShoulderAbduction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            TrainingSession(
              dbID: null, 
              name: "Lower1", 
              exercises: [
                ExerciseBlock(
                  movementPattern: MovementPattern.Squat, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegFlexion, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.LegExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.AnkleExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.HipAdbuction, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
                ExerciseBlock(
                  movementPattern: MovementPattern.SpinalExtension, 
                  exercise: null, 
                  sets: [
                    SetCollection(
                      amount: 3, 
                      type: SetType.Standard, 
                      data: {},
                    )
                  ]
                ),
              ],
            ),
            RestSession()
          ],
        );
      case TrainingSplitPreset.Custom:
        return TrainingSplit(
          name: "Custom Split",
          dbID: null,
          trainingSessions: [

          ],
          
        );
    }

  }
}