import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscle_list.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/page/list_training.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';


class TrainingSplitPage extends StatelessWidget {
  
  final TrainingSplit? trainingSplit;
  const TrainingSplitPage({super.key, this.trainingSplit});
  @override
  Widget build(BuildContext context) {
    // Required so that background scaffold rng is not constantly reloaded when state updated
    return MainScaffold(
      content: _TrainingPageContent(trainingSplit: trainingSplit), 
      title: "Training Split"
    );
  }

}

class _TrainingPageContent extends StatefulWidget {
  final TrainingSplit? trainingSplit;
  const _TrainingPageContent({required this.trainingSplit});
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_TrainingPageContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(width: 50),
            Flexible(
              child: TrainingSessionList(
                sessions: widget.trainingSplit?.trainingSessions
              ), 
            )
          ],
        ),
        Positioned(
          bottom: 100,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'addButton',
            backgroundColor: Colors.red,
            onPressed: _onAddPress,
            child:  const Icon(
              Icons.add,
              color: Colors.white
            )
          )
        ),
         Positioned(
          bottom: 10,
          left: 10,
          child: FloatingActionButton(
            heroTag: 'saveButton',
            backgroundColor: Colors.red,
            onPressed: _onCompletePress,
            child:  const Icon(
              Icons.check,
              color: Colors.white
            )
          )
        )
      ],
    );
  }

  void _onAddPress() {
    setState(() {
      widget.trainingSplit?.trainingSessions.add(TrainingSession(dbID: null, name: "New Session", exerciseBlocks: []));
    });
  }

  void _onCompletePress() {
    print(widget.trainingSplit!.trainingSessions.length);
  }
}

