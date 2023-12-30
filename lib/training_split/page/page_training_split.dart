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
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                    colors: [Colors.black,Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: getContainerWidget(session)
                ),
              ),
            ),
          ],
        ),
        MuscleList(dataList: Muscle.values, colors: [Colors.white,Colors.indigo.shade300])
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
  void onLongPress(ISession? data) {
    // TODO: implement onLongPress
  }

  @override
  void onPress(ISession? data) {
    // TODO: implement onPress
  }

}


