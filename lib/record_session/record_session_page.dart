import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:fitness_app/record_session/db_recorded_session.dart';
import 'package:fitness_app/record_session/dialog_edit_tracking_set.dart';
import 'package:fitness_app/record_session/recorded_training_session.dart';
import 'package:fitness_app/record_session/tracking_set.dart';
import 'package:fitness_app/training_split/db_training_split.dart';
import 'package:fitness_app/training_split/page/edit_block/exercise_edit_block.dart';
import 'package:fitness_app/training_split/page/list_training.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';

/// Loads a Session Recorder from a static session (ie session layout in training plan)
class NewSessionTrackerLoader extends PageLoader {
  final String staticSessionID;
  final User user;
  const NewSessionTrackerLoader({super.key, required this.staticSessionID, required this.user});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: getTitle(),
      content: _RecordSessionPage(session: TrackedBlockFactory.staticToRecordedSession(snapshot.data), user: user)
    );
  }

  @override
  Future getFuture() {
    return TrainingSessionRetriever(dbID: staticSessionID).fromDatabase();
  }

  @override
  String getTitle() {
    return "Session Tracker";
  }
}

/// Loads a Session Recorded from database
class RecordedSessionLoader extends PageLoader {
  final String dbID;
  final User user;
  const RecordedSessionLoader({super.key,required this.user, required this.dbID});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: getTitle(),
      content: _RecordSessionPage(session: snapshot.data, user: user)
    );
  }

  @override
  Future getFuture() {
    return RecordedSessionRetriever(dbID: dbID).fromDatabase();
  }

  @override
  String getTitle() {
    return "Session Tracker";
  }

}

class _RecordSessionPage extends StatefulWidget {
  final User user;
  final RecordedTrainingSession? session;
  const _RecordSessionPage({required this.session, required this.user});

  @override
  State<StatefulWidget> createState() => _RecordSessionState();

}

class _RecordSessionState extends State<_RecordSessionPage> {
  @override
    void initState() {
      super.initState();
      if (widget.session!.dbID == null) {
        RecordedTrainingSessionDBCom.upload(widget.session, widget.user);
      }
      
    }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const SizedBox(width: 50),
            Flexible(child: _TrackingBlockList(blocks: widget.session!.blocks, session: widget.session, user: widget.user))   
          ],
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
        )
      ],
    );
  }

  void _onAddPress() async {
    setState(() {
      widget.session!.blocks!.add(TrackedBlock(null, movementPattern: MovementPattern.UndefinedMovement, exercise: null, sets: []));
    });
    await RecordedTrainingSessionDBCom.update(widget.session, widget.user);
  }
}
class _TrackingBlockList extends StatefulWidget {
  final User user;
  final List<TrackedBlock?>? blocks;
  final RecordedTrainingSession? session;
  const _TrackingBlockList({required this.blocks, required this.session, required this.user});
  
  @override
  State<StatefulWidget> createState() => _TrackingBlockListState();
}

class _TrackingBlockListState extends State<_TrackingBlockList> implements IButtonListState<int>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.blocks?.length,
      itemBuilder: (context, index) {
        return _buildTile(context,index);
      },
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
                colors: [Colors.red,Colors.black],
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
        _TrackingSetList(block: widget.blocks?[index], sets: widget.blocks?[index]!.sets, session: widget.session!)
      ],
    );
  }
  
  @override
  Widget? getContainerWidget(int? index) {
    IBlock? block = widget.blocks![index!];
    String string = MovementPatternFactory.patternToFormattedString(block!.movementPattern);
    if (block.exercise != null) {
      if (block.variation != null) {
        string += "\n${block.variation!.variationName}";
      } else {
        string += "\n${block.exercise!.exerciseName}";
      }
    }
    return Text(
       string,
       textAlign: TextAlign.center,
       style: const TextStyle(
        color: Colors.white
       ),
    );
  }

  @override
  void onLongPress(int? index) async {
    setState(() {
      widget.blocks!.removeAt(index!);
    });
    await RecordedTrainingSessionDBCom.update(widget.session, widget.user);
  }
  
  @override
  void onPress(int? index) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _EditRecordBlockDialog(
          block:  widget.blocks?[index!],
          moveLeft: _moveLeft, 
          moveRight: _moveRight,
        );
      }
    );
    setState(() {});
    await RecordedTrainingSessionDBCom.update(widget.session, widget.user);
  }

  void _moveLeft(TrackedBlock? block) async {
    int index = widget.blocks!.indexOf(block);
    int newIndex;
    index > 0 ? newIndex = index-1 : newIndex=widget.blocks!.length-1;
    setState(() {
      dynamic temp = widget.blocks![index];
      widget.blocks![index] = widget.blocks![newIndex];
      widget.blocks![newIndex] = temp; 
    });
    await RecordedTrainingSessionDBCom.update(widget.session, widget.user);
  }

  void _moveRight(TrackedBlock? block) async {
    int index = widget.blocks!.indexOf(block);
    int newIndex;
    index < widget.blocks!.length-1 ? newIndex = index+1 : newIndex=0;
    setState(() {
      dynamic temp = widget.blocks![index];
      widget.blocks![index] = widget.blocks![newIndex];
      widget.blocks![newIndex] = temp; 
    });
    await RecordedTrainingSessionDBCom.update(widget.session, widget.user);
  } 
}

class _EditRecordBlockDialog extends StatefulWidget {
  final TrackedBlock? block;
  final Function(TrackedBlock?) moveLeft;
  final Function(TrackedBlock?) moveRight;
  const _EditRecordBlockDialog({required this.block, required this.moveLeft, required this.moveRight});
  
  @override
  State<StatefulWidget> createState() => _EditRecordBlockDialogState();
}

class _EditRecordBlockDialogState extends State<_EditRecordBlockDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
           child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.black,
                title: const Text(
                  "Edit Block",
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
              const SizedBox(height: 20),
              SquareGradientButtonSizeable(
                // ignore: avoid_types_as_parameter_names
                onPress: (BuildContext){widget.block!.sets.add(TrackedSet(type:TrackedSetType.Standard, data: {}));} , 
                text: "Add Set", 
                colors: [Colors.blue,Colors.blue.shade300], 
                size: Size(200,100)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      widget.moveLeft(widget.block);
                    }, 
                    icon: const Icon(
                      Icons.arrow_circle_left,
                      color: Colors.white,
                      size: 50,
                    )
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: (){
                      widget.moveRight(widget.block);
                      
                    }, 
                    icon: const Icon(
                      Icons.arrow_circle_right,
                      color: Colors.white,
                      size: 50,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LiftingEditBlockExercise(block: widget.block, onMovementSelected: _onMovementSelected)
            ],
          )
        ),
      )
    );
  }

  void _onMovementSelected(MovementPattern? pattern) {
    setState(() {
      widget.block!.movementPattern = pattern;
      widget.block!.exercise = null;
      widget.block!.variation = null;
    });
  } 
}

class _TrackingSetList extends StatefulWidget {
  final List<TrackedSet?>? sets;
  final TrackedBlock? block;
  final RecordedTrainingSession session;
  const _TrackingSetList({required this.block, required this.sets, required this.session});
  
  @override 
  State<StatefulWidget> createState() => _TrackingSetListState();

}

class _TrackingSetListState extends State<_TrackingSetList> implements IButtonListState<int>{
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: 200,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.sets?.length,
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
  
  @override
  Widget? getContainerWidget(int? index) {
    return Text(
       TrackingSetFactory.getFormattedString(widget.block!.sets[index!]),
       textAlign: TextAlign.center,
       style: const TextStyle(
        color: Colors.white
       ),
    );
  }
  
  @override
  void onLongPress(int? index) async {
    setState(() {
      widget.block!.sets.removeAt(index!);
    });
    await RecordedTrainingSessionDBCom.update(widget.session, null);
  }
  
  @override
  void onPress(int? index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTrackingSetDialog(
          index: index!,
          block: widget.block, 
          set: widget.block!.sets[index], 
          moveUp: _moveUp, moveDown: _moveDown);
      }
    );
    setState(() {});
    await RecordedTrainingSessionDBCom.update(widget.session, null);
  }

  void _moveUp(int? index) async {
    setState(() {
      int newIndex;
      index! > 0 ? newIndex = index-1 : newIndex=widget.block!.sets.length-1;
      dynamic temp = widget.block!.sets[index];
      widget.block!.sets[index] = widget.block!.sets[newIndex];
      widget.block!.sets[newIndex] = temp; 
    });
    await RecordedTrainingSessionDBCom.update(widget.session, null);
  }

  void _moveDown(int? index) async {
    setState(() {
      int newIndex;
      index! < widget.block!.sets.length-1 ? newIndex = index+1 : newIndex=0;
      dynamic temp = widget.block!.sets[index];
      widget.block!.sets[index] = widget.block!.sets[newIndex];
      widget.block!.sets[newIndex] = temp; 
    });
    await RecordedTrainingSessionDBCom.update(widget.session, null);
  }
}

