// ignore_for_file: non_constant_identifier_names

import 'dart:ui_web';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:fitness_app/training_split/db_training_split.dart';
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
      'owner_id' : widget.user.dbID,
      'date_created' : DateTime.now()
    };
    DocumentReference splitRef = await FirebaseFirestore.instance.collection("TrainingSplits").add(splitUpload);
    Logger().i("Split Uploaded: ${splitRef.id}");
    
    String splitID = splitRef.id;
    widget.user.trainingSplitID = splitID;
    await FirebaseFirestore.instance.collection('Users').doc(widget.user.dbID).update({
      'training_split_id' : splitID
    });
    Logger().i("User Current Split Set: ${splitRef.id}");
    int index = 0;
    for (ISession session in widget.trainingSplit!.trainingSessions) {
      SessionUploader.uploadSession(session, splitID, index);
      index += 1;
    }
  }
}

class ModifyTrainingSplitPageLoader extends PageLoader {
  final User user;
  const ModifyTrainingSplitPageLoader({super.key, required this.user});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: "Training Split", 
      content:_ModifyTrainingPageContent(
        trainingSplit: snapshot.data, 
        user: user), 
      );
  }

  @override
  Future getFuture() {
    return TrainingSplitRetriever(dbID: user.trainingSplitID!).fromDatabase();
  }

  @override
  String getTitle() {
    return "Training Split";
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

