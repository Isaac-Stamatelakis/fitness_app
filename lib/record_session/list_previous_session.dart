import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:fitness_app/record_session/record_session_page.dart';
import 'package:fitness_app/record_session/tracking_set.dart';
import 'package:fitness_app/record_session/db_recorded_session.dart';
import 'package:fitness_app/record_session/recorded_training_session.dart';
import 'package:fitness_app/training_split/db_training_split.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class PreviousSessionListLoader extends PageLoader {
  final User user;
  const PreviousSessionListLoader({super.key, required this.user});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: getTitle(),
      content: _PreviousSessionListPage(sessions: snapshot.data, user: user), 
    );
  }

  @override
  Future getFuture() {
    return RecordedSessionUserQuery(userID: user.dbID!).retrieve();
  }

  @override
  String getTitle() {
    return "Previous Sessions";
  }
}

class _PreviousSessionListPage extends StatefulWidget {
  final User user;
  final List<RecordedTrainingSession?> sessions;

  const _PreviousSessionListPage({required this.sessions, required this.user});
  @override
  State<StatefulWidget> createState() => _PreviousSessionListPageState();

}

class _PreviousSessionListPageState extends State<_PreviousSessionListPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
            PreviousSessionList(sessions: widget.sessions, user: widget.user,)
            ],
          )
        )
      ] 
    );
  }
}

class PreviousSessionList extends StatefulWidget {
  final List<RecordedTrainingSession?> sessions;
  final User user;
  const PreviousSessionList({super.key, required this.sessions, required this.user});
  @override
  State<StatefulWidget> createState() => _PreviousSessionListState();
}

class _PreviousSessionListState extends State<PreviousSessionList> implements IButtonListState<RecordedTrainingSession?>{
  @override
  Widget? getContainerWidget(RecordedTrainingSession? session) {
    String formattedDate = DateFormat('MMMM d\'st\', y').format(session!.date!);
    return Text(
      "${session.name}, $formattedDate",
      style: const TextStyle(
        color: Colors.white
      ),
    );
  }

  @override
  void onLongPress(RecordedTrainingSession? session) {
    // Do Nothing
  }

  @override
  void onPress(RecordedTrainingSession? session) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordedSessionLoader(
          user: widget.user,
          dbID: session!.dbID!,
        )
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: ListView.builder(
          itemCount: widget.sessions.length,
          itemBuilder: (context, index) {
            return _buildTile(context,widget.sessions[index]);
          },
        ),
      ) 
    );
  }

  Widget? _buildTile(BuildContext context, RecordedTrainingSession? data) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            onPress(data);
          },
          onLongPress: () {
            onLongPress(data);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            padding: const EdgeInsets.all(0.0),
          ),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              height: 100,
              alignment: Alignment.center,
              child: getContainerWidget(data)
            ),
          ),
        ),
      ],
    );
  }

}