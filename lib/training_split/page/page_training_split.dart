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
      content: _TrainingPageContent(trainingSplit: trainingSplit, user: user),
      title: "Training Split"
    );
  }
}

class _TrainingPageContent extends StatefulWidget {
  final User user;
  final TrainingSplit? trainingSplit;
  const _TrainingPageContent({required this.trainingSplit,required this.user});
  @override
  State<StatefulWidget> createState() => _TrainingPageState();

}

class _TrainingPageState extends State<_TrainingPageContent> {
  @override
  void initState() {
    super.initState();
    if (widget.trainingSplit!.dbID == null) {
     _upload();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(width: 50),
            Flexible(
              child: TrainingSessionList(
                sessions: widget.trainingSplit?.trainingSessions, 
                traingSplitID: widget.trainingSplit!.dbID,
              ), 
            )
          ],
        ),  
        Positioned(
          bottom: 80,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'nameButton',
            backgroundColor: Colors.blue,
            onPressed: _onNameEditPress,
            child:  const Icon(
              Icons.edit,
              color: Colors.white
            )
          )
        ),
        Positioned(
          bottom: 10,
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
      ],
    );
  }
  
  void _onNameEditPress() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _EditNameDialog(trainingSplit: widget.trainingSplit);
      }
    );
    if (widget.trainingSplit!.dbID != null && widget.trainingSplit!.dbID!.isNotEmpty) {
      FirebaseFirestore.instance.collection("TrainingSplits").doc(widget.trainingSplit!.dbID!).update(
        {
          'name': widget.trainingSplit!.name
        }
      );
    }
    setState(() {
      
    });
  }

  Future<void> _upload() async {
    Map<String, dynamic> splitUpload = {
      'name': widget.trainingSplit!.name,
      'owner_id' : widget.user.dbID,
      'date_created' : DateTime.now(),
      'last_accessed':  DateTime(1, 1, 1)
    };
    DocumentReference splitRef = await FirebaseFirestore.instance.collection("TrainingSplits").add(splitUpload);
    Logger().i("Split Uploaded: ${splitRef.id}");
    String splitID = splitRef.id;
    int index = 0;
    for (ISession session in widget.trainingSplit!.trainingSessions) {
      SessionUploader.uploadSession(session, splitID, index);
      index += 1;
    }
  }

  void _onAddPress() async {
    TrainingSession newSession = TrainingSession(dbID: null, name: "New Session", exerciseBlocks: []);
    await SessionUploader.uploadSession(newSession, widget.trainingSplit!.dbID, widget.trainingSplit!.trainingSessions.length);
    setState(() {
      widget.trainingSplit?.trainingSessions.add(newSession);
    });
    
  }
}

class _EditNameDialog extends StatefulWidget {
  final TrainingSplit? trainingSplit;

  const _EditNameDialog({required this.trainingSplit});
  @override
  State<StatefulWidget> createState() => _EditNameDialogState();

}

class _EditNameDialogState extends State<_EditNameDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.trainingSplit!.name!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        width: 300,
        height: 200,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Edit Training Split Title",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back, 
                  color: Colors.white
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Colors.grey
                ),
              ),
              onChanged: (value) {
                widget.trainingSplit!.name = value;
              },
            ),
          ],
        )
      )
    );
  }
}

class ModifyTrainingSplitPageLoader extends PageLoader {
  final User user;
  final String? splitID;
  const ModifyTrainingSplitPageLoader({super.key, required this.splitID, required this.user});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: "Training Split", 
      content:_TrainingPageContent(
        trainingSplit: snapshot.data, 
        user: user), 
      );
  }

  @override
  Future getFuture() {
    return TrainingSplitRetriever(dbID: splitID!).fromDatabase();
  }

  @override
  String getTitle() {
    return "Training Split";
  }

}


