import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/db_training_split.dart';
import 'package:fitness_app/training_split/page/edit_block/edit_block_dialog.dart';
import 'package:fitness_app/training_split/page/edit_session_dialog.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class ASessionList extends StatefulWidget {
  final String? traingSplitID;
  final List<ISession>? sessions;

  const ASessionList({super.key, required this.sessions, required this.traingSplitID});
  @override
  State<StatefulWidget> createState();

}

abstract class ASessionListState<T extends ISession> extends State<ASessionList> implements IButtonListState<int>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.sessions?.length,
      itemBuilder: (context, index) {
        return _buildTile(context,index);
      },
    ); 
  }

  Widget? _buildTile(BuildContext context, int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 1),
            ElevatedButton(
              onPressed: () {
                onPress(index);
              },
              onLongPress: () {
                onLongPress(index);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                padding: const EdgeInsets.all(0.0),
              ),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                    colors: [Colors.red.shade400,Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  child: getContainerWidget(index)
                ),
              ),
            ),
          ],
        ),
        TrainingSessionFactory.generateBlockList(widget.sessions![index])
      ],
    ); 
  }
}


class TrainingSessionList extends ASessionList {
  const TrainingSessionList({super.key, required super.sessions, required super.traingSplitID});
  @override
  State<StatefulWidget> createState() => _TrainingSessionListState();
}

class _TrainingSessionListState extends ASessionListState {
  @override
  Widget? getContainerWidget(int? index) {
    return TrainingSessionFactory.toText(widget.sessions![index!]);
  }

  @override
  void onLongPress(int? index) async {
    ISession? session = widget.sessions?.removeAt(index!);
    setState(() {
      
    });
    if (session!.dbID != null && session.dbID!.isNotEmpty) {
      SessionUploader.deleteSession(session);
    }
    // Shifts all session indexs down by own whose index is now at the deleted index
    for (int i = 0; i < widget.sessions!.length; i ++) {
      await _updateOrder(i);
    }
  }

  @override
  void onPress(int? index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditSessionDialog(addBlock: _addBlock, session: widget.sessions![index!], moveLeft: _moveLeft, moveRight: _moveRight);
      }
    );
    if (widget.sessions![index!].dbID != null) {
      SessionUploader.updateSession(widget.sessions![index], widget.traingSplitID, index);
    }
    setState((){});
  }
  void _moveLeft(ISession? session) async {
    int index = widget.sessions!.indexOf(session!);
    int newIndex;
    index > 0 ? newIndex = index-1 : newIndex=widget.sessions!.length-1;
    setState(() {
      dynamic temp = widget.sessions![index];
      widget.sessions![index] = widget.sessions![newIndex];
      widget.sessions![newIndex] = temp; 
    });
    await _updateOrder(index);
    await _updateOrder(newIndex);
  }

  void _moveRight(ISession? session) async {
    int index = widget.sessions!.indexOf(session!);
    int newIndex;
    index < widget.sessions!.length-1 ? newIndex = index+1 : newIndex=0;
    setState(() {
      dynamic temp = widget.sessions![index];
      widget.sessions![index] = widget.sessions![newIndex];
      widget.sessions![newIndex] = temp; 
    });
    await _updateOrder(index);
    await _updateOrder(newIndex);
  }

  Future<void> _updateOrder(int index) async {
    if (widget.sessions![index].dbID != null) {
      await FirebaseFirestore.instance.collection("StaticSessions").doc(widget.sessions![index].dbID).update(
        {
          'order': index
        }
      );
    }
  }

  void _addBlock(ISession? session) {
    setState(() {
      if (session is TrainingSession) {
        session.exerciseBlocks.add(ExerciseBlock(null, movementPattern: MovementPattern.UndefinedMovement, exercise: null, sets: []));
      }
    });
    _updateSession(session);
  }

  void _updateSession(ISession? session) {
    if (session!.dbID != null && session.dbID!.isNotEmpty) {
      SessionUploader.updateSession(session, null, null);
    }
  }
}



abstract class ATrainingBlockList extends StatefulWidget {
  final List<IBlock>? blocks;
  final ISession? session;
  final Axis scrollDirection;
  const ATrainingBlockList({super.key, required this.blocks, required this.session, required this.scrollDirection});
  @override
  State<StatefulWidget> createState();
}

abstract class ATrainingBlockListState extends State<ATrainingBlockList> implements IButtonListState<int>{
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: 200,
        child: ListView.builder(
          scrollDirection: widget.scrollDirection,
          itemCount: widget.blocks?.length,
          itemBuilder: (context, index) {
            return _buildTile(context,index);
          },
        ),
      ) 
    );
  }

  Widget? _buildTile(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 1),
        ElevatedButton(
          onPressed: () {
            onPress(index);
          },
          onLongPress: () {
            onLongPress(index);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            padding: const EdgeInsets.all(0.0),
          ),
          child: Ink(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                colors: [Colors.black,Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: getContainerWidget(index)
            ),
          ),
        ),
      ],
    );
  }
}

class TrainingBlockList extends ATrainingBlockList {
  const TrainingBlockList({super.key, required super.blocks, required super.session, required super.scrollDirection});
  @override
  State<StatefulWidget> createState() => TrainingBlockListState();

}

class TrainingBlockListState extends ATrainingBlockListState {
  @override
  Widget? getContainerWidget(int? index) {
    IBlock block = widget.blocks![index!];
    return generateText(block);
  }

  @override
  void onLongPress(int? index) {
    setState(() {
      widget.blocks?.removeAt(index!);
    });
    _updateSession();
  }

  @override
  void onPress(int? index) async {
    _startEditDialog(index);
  }
  
  Widget generateText(IBlock? block) {
    String returnString = "${MovementPatternFactory.patternToString(block!.movementPattern)}\n"; 
    if (block.variation != null) {
      returnString += "${block.variation!.variationName}\n";
    } else {
      if (block.exercise != null) {
        returnString += "${block.exercise!.exerciseName}\n";
      }
    }
    if (block is ExerciseBlock) {
      if (block.sets!.isNotEmpty) {
        LiftingSet set = block.sets![0] as LiftingSet;
        returnString += LiftingSetFactory.formatString(set);
      } 
      if (block.sets!.length > 1) {
        returnString += "\n...";
      }
    } else if (block is CardioBlock) {
      returnString += "${block.set!.duration.toString()} Minutes";
    }
    return Text(
        returnString,
        style: const TextStyle(
          color: Colors.white70
        ),
        textAlign: TextAlign.center,
      );
  }
  void _moveUp(int? index) {
    setState(() {
      int newIndex;
      index! > 0 ? newIndex = index-1 : newIndex=widget.blocks!.length-1;
      dynamic temp = widget.blocks![index];
      widget.blocks![index] = widget.blocks![newIndex];
      widget.blocks![newIndex] = temp; 
    });
    if (widget.session!.dbID != null && widget.session!.dbID!.isNotEmpty) {
      SessionUploader.updateSession(widget.session, null, null);
    }
    _updateSession();
  }

  void _moveDown(int? index) {
    setState(() {
      int newIndex;
      index! < widget.blocks!.length-1 ? newIndex = index+1 : newIndex=0;
      dynamic temp = widget.blocks![index];
      widget.blocks![index] = widget.blocks![newIndex];
      widget.blocks![newIndex] = temp; 
    });
    _updateSession();
  }

  void _onBlockTypeChanged(int? index, IBlock? newBlock) {
    widget.blocks?[index!] = newBlock!;
    Navigator.pop(context);
    _startEditDialog(index);
  }

  void _startEditDialog(int? index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditBlockDialogFactory(
          block:  widget.blocks?[index!],
          moveUp: _moveUp, 
          moveDown: _moveDown, 
          onBlockTypeChanged: _onBlockTypeChanged, 
          index: index
        );
      }
    );
    setState(() {});
    _updateSession();
  }

  void _updateSession() {
    if (widget.session!.dbID != null && widget.session!.dbID!.isNotEmpty) {
      SessionUploader.updateSession(widget.session, null, null);
    }
  }
}
