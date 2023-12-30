import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscle_list.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

class TrainingSplitPage extends StatefulWidget {
  final TrainingSplit? trainingSplit;
  const TrainingSplitPage({super.key, required this.trainingSplit});
  @override
  State<StatefulWidget> createState() => _State();
  
}

class _State extends State<TrainingSplitPage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      content: _buildContent(), 
      title: "Training Split"
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        TrainingSessionList(sessions: widget.trainingSplit?.trainingSessions)
      ],
    );
  }
}

abstract class ASessionList extends StatefulWidget {
  final List<ISession>? sessions;

  const ASessionList({super.key, required this.sessions});
  @override
  State<StatefulWidget> createState();

}

abstract class ASessionListState<T extends ISession> extends State<ASessionList> {
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

  Widget? getContainerWidget(ISession? data);

  void onPress(ISession? data);

  void onLongPress(ISession? data);

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
  void onPress(ISession? data) {
    // TODO: implement onPress
  }

}

abstract class ATrainingBlockList extends StatefulWidget {
  final List<IBlock>? blocks;

  const ATrainingBlockList({super.key, required this.blocks});
  @override
  State<StatefulWidget> createState();
}

abstract class ATrainingBlockListState extends State<ATrainingBlockList> {
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
  Widget? getContainerWidget(IBlock? block);
  void onLongPress(IBlock? block);
  void onPress(IBlock? block);
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
        MovementPatternMuscleFactory.movementPatternToString(block.movementPattern),
        style: const TextStyle(
          color: Colors.white70
        ),
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
