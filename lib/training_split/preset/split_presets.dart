// ignore_for_file: constant_identifier_names
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

enum TrainingSplitPreset {
  Custom,
  PushPullLeg,
  BroSplit,
  UpperLower,
}

class TrainingSplitPresetFactory {
  static String presetToString(TrainingSplitPreset? preset) {
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

  static TrainingSplit? buildSplit(TrainingSplitPreset? preset) {
    switch (preset) {
      case TrainingSplitPreset.PushPullLeg:
        return TrainingSplit(
          name: "Push/Pull/Leg",
          dbID: null,
          trainingSessions: [
            TrainingSession(
              dbID: null, 
              name: "Push", 
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              name: "Legs", 
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              name: "Legs", 
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
            TrainingSession(dbID: null, name: "Rest", exerciseBlocks: [])
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              name: "Legs", 
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
            TrainingSession(dbID: null, name: "Rest", exerciseBlocks: []),
            TrainingSession(dbID: null, name: "Rest", exerciseBlocks: [])
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
              exerciseBlocks: [
                ExerciseBlock(
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
                  null,
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
            TrainingSession(dbID: null, name: "Rest", exerciseBlocks: [])
          ],
        );
      case TrainingSplitPreset.Custom:
        return TrainingSplit(
          name: "Custom Split",
          dbID: null,
          trainingSessions: [

          ],
        );
      case null:
        return null;
    }
  }
}