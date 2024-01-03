import 'dart:ui_web';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscle_list.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/page/edit_block/exercise_edit_block.dart';
import 'package:fitness_app/training_split/page/list_training.dart';
import 'package:fitness_app/training_split/preset/dialog_new_split.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class TrainingSplitPage extends StatelessWidget {
  
  final TrainingSplit? trainingSplit;
  final User user;
  const TrainingSplitPage({super.key, this.trainingSplit, required this.user});
  @override
  Widget build(BuildContext context) {
    // Required so that background scaffold rng is not constantly reloaded when state updated
    return MainScaffold(
      content: getContent(),
      title: "Training Split"
    );
  }

  Widget getContent() {
    if (user.trainingSplitID!.isEmpty) {
      return _NewTrainingPageContent(trainingSplit: trainingSplit, user: user);
    } else {
      return _ModifyTrainingPageContent(trainingSplit: trainingSplit, user: user);
    }
  }

}

abstract class _AbstractTrainingPageContent extends StatefulWidget {
  final User user;
  final TrainingSplit? trainingSplit;
  const _AbstractTrainingPageContent({required this.trainingSplit,required this.user});

}

abstract class _AbstractTrainingPageState extends State<_AbstractTrainingPageContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(width: 50),
            Flexible(
              child: TrainingSessionList(
                sessions: widget.trainingSplit?.trainingSessions
              ), 
            )
          ],
        ),
        Positioned(
          bottom: 150,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'addButton',
            backgroundColor: Colors.blue,
            onPressed: _onAddPress,
            child:  const Icon(
              Icons.add,
              color: Colors.white
            )
          )
        ),
        Positioned(
          bottom: 80,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'saveButton',
            backgroundColor: Colors.green,
            onPressed: _onCompletePress,
            child:  const Icon(
              Icons.save,
              color: Colors.white
            )
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'deleteButton',
            backgroundColor: Colors.red,
            onPressed: _onDeletePress,
            child:  const Icon(
              Icons.restart_alt,
              color: Colors.white
            )
          ),
        )
      ],
    );
  }

  void _onAddPress() {
    setState(() {
      widget.trainingSplit?.trainingSessions.add(TrainingSession(dbID: null, name: "New Session", exerciseBlocks: []));
    });
  }

  void _onCompletePress();

  void _onDeletePress() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(displayText: "Are you sure you want to delete this split?", onConfirmCallback: _onRestartConfirmation,
        );
      }
    );
  }

  void _onRestartConfirmation(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewTrainingSplitDialog(user: widget.user);
      }
    );
  }
}


class _NewTrainingPageContent extends _AbstractTrainingPageContent {
  _NewTrainingPageContent({required super.trainingSplit, required super.user});

  @override
  State<StatefulWidget> createState() => _NewTrainingPageContentState();
}

class _NewTrainingPageContentState extends _AbstractTrainingPageState {
  @override
  void _onCompletePress() async {
    Map<String, dynamic> splitUpload = {
      'name': widget.trainingSplit!.name,
      'owner_id' : widget.user.dbID
    };
    DocumentReference splitRef = await FirebaseFirestore.instance.collection("TrainingSplits").add(splitUpload);
    Logger().i("Split Uploaded: ${splitRef.id}");
    String splitID = "DELETE_ME";
    int index = 0;
    for (ISession session in widget.trainingSplit!.trainingSessions) {
      if (session is TrainingSession) {
        List<Map<String,dynamic>> exercise_blocks = [];
        for (IBlock block in session.exerciseBlocks) {
          String exercise_id = "";
          String variation_id = "";
          if (block.exercise != null) {
            exercise_id = block.exercise!.dbID;
            if (block.variation != null) {
              variation_id = block.variation!.dbID;
            }
          }
          Map<String,dynamic> blockJson = {
            'exercise_id' : exercise_id,
            'variation_id' : variation_id,
          };

          if (block is CardioBlock) {
            blockJson['sets'] = [
              {
                'type':'Cardio',
                'duration': block.set!.duration
              }
            ];
            exercise_blocks.add(blockJson);
          } else if (block is ExerciseBlock) {
            List<Map<String, dynamic>> sets = [];
            for (ISet? set in block.sets!) {
              if (set is LiftingSet) {
                LiftingSetFactory.cleanUpStaticSetData(set);
                set.data['type'] = SetFactory.liftingSetTypeToString(set.type);
                sets.add(set.data);
              }
            }
            blockJson['sets'] = sets;
            exercise_blocks.add(blockJson);
          }
        }
        print(exercise_blocks.length);
        Map<String,dynamic> sessionUpload = {
          'exercise_blocks': exercise_blocks,
          'name' : session.name,
          'order' : index,
          'training_split_id' : splitID
        };
        index += 1;
        DocumentReference sessionRef = await FirebaseFirestore.instance.collection("StaticSessions").add(sessionUpload);
        Logger().i("Session Uploaded: ${sessionRef.id}");
      }
    }
  }
}

class _ModifyTrainingPageContent extends _AbstractTrainingPageContent {
  _ModifyTrainingPageContent({required super.trainingSplit, required super.user});

  @override
  State<StatefulWidget> createState() => _ModifyTrainingPageContentState();
}

class _ModifyTrainingPageContentState extends _AbstractTrainingPageState {
  @override
  void _onCompletePress() {
    // TODO: implement _onCompletePress
  }
}