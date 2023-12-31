import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/page/edit_session_dialog.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class ASessionList extends StatefulWidget {
  final List<ISession>? sessions;

  const ASessionList({super.key, required this.sessions});
  @override
  State<StatefulWidget> createState();

}

abstract class ASessionListState<T extends ISession> extends State<ASessionList> implements IButtonListState<ISession?>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.sessions?.length,
      itemBuilder: (context, index) {
        return _buildTile(context,widget.sessions?[index]);
      },
    ); 
  }

  Widget? _buildTile(BuildContext context, ISession? session) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 1),
            ElevatedButton(
              onPressed: () {
                onPress(session);
              },
              onLongPress: () {
                onLongPress(session);
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
                  child: getContainerWidget(session)
                ),
              ),
            ),
          ],
        ),
        TrainingSessionFactory.generateBlockList(session)
      ],
    ); 
  }
}


class TrainingSessionList extends ASessionList {
  const TrainingSessionList({super.key, required super.sessions});
  @override
  State<StatefulWidget> createState() => _TrainingSessionListState();
}

class _TrainingSessionListState extends ASessionListState {
  @override
  Widget? getContainerWidget(ISession? session) {
    return TrainingSessionFactory.toText(session);
  }

  @override
  void onLongPress(ISession? session) {
    setState(() {
      widget.sessions?.remove(session);
    });
  }

  @override
  void onPress(ISession? session) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditSessionDialog(addBlock: _addBlock, session: session, moveLeft: _moveLeft, moveRight: _moveRight);
      }
    );
  }
  void _moveLeft(ISession? session) {
    setState(() {
      int index = widget.sessions!.indexOf(session!);
      int newIndex;
      index > 0 ? newIndex = index-1 : newIndex=widget.sessions!.length-1;
      dynamic temp = widget.sessions![index];
      widget.sessions![index] = widget.sessions![newIndex];
      widget.sessions![newIndex] = temp; 
    });
  }

  void _moveRight(ISession? session) {
    setState(() {
      int index = widget.sessions!.indexOf(session!);
      int newIndex;
      index < widget.sessions!.length-1 ? newIndex = index+1 : newIndex=0;
      dynamic temp = widget.sessions![index];
      widget.sessions![index] = widget.sessions![newIndex];
      widget.sessions![newIndex] = temp; 
    });
  }
  void _addBlock(ISession? session) {
    setState(() {
      if (session is TrainingSession) {
        session.exerciseBlocks.add(ExerciseBlock(movementPattern: MovementPattern.UndefinedMovement, exercise: null, sets: []));
      }
    });
  }
}



abstract class ATrainingBlockList extends StatefulWidget {
  final List<IBlock>? blocks;

  const ATrainingBlockList({super.key, required this.blocks});
  @override
  State<StatefulWidget> createState();
}

abstract class ATrainingBlockListState extends State<ATrainingBlockList> implements IButtonListState<IBlock?>{
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: 200,
        child: ListView.builder(
          itemCount: widget.blocks?.length,
          itemBuilder: (context, index) {
            return _buildTile(context,widget.blocks?[index]);
          },
        ),
      ) 
    );
    
  }

  Widget? _buildTile(BuildContext context, IBlock? block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 1),
        ElevatedButton(
          onPressed: () {
            onPress(block);
          },
          onLongPress: () {
            onLongPress(block);
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
              child: getContainerWidget(block)
            ),
          ),
        ),
      ],
    );
  }
}

class TrainingBlockList extends ATrainingBlockList {
  const TrainingBlockList({super.key, required super.blocks});
  @override
  State<StatefulWidget> createState() => TrainingBlockListState();

}

class TrainingBlockListState extends ATrainingBlockListState {
  @override
  Widget? getContainerWidget(IBlock? block) {
    if (block is ExerciseBlock) {
      return Text(
        "${MovementPatternFactory.movementPatternToString(block.movementPattern)}\n${block.exercise.toString()}",
        style: const TextStyle(
          color: Colors.white70
        ),
        textAlign: TextAlign.center,
      );
    }
    return null;
  }

  @override
  void onLongPress(IBlock? block) {
    setState(() {
      widget.blocks?.remove(block);
    });
  }

  @override
  void onPress(IBlock? block) {
    // TODO: implement onPress
  }

}
