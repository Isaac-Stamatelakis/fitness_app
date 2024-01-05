import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:fitness_app/misc/tile_list_first.dart';
import 'package:fitness_app/record_session/record_session_page.dart';
import 'package:fitness_app/training_split/db_training_split.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RecordSessionSelectorDialog extends StatefulWidget {
  final User user;
  const RecordSessionSelectorDialog({super.key, required this.user});
  
  @override
  State<StatefulWidget> createState() => _TrainingSplitSelectorDialogState();
}


class _TrainingSplitSelectorDialogState extends State<RecordSessionSelectorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        width: GlobalHelper.getPreferredDialogWidth(context),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Select a Session to Start",
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
            _SessionListLoader(user: widget.user)
          ],
        )
      )
    );
  }
}


class _SessionListLoader extends WidgetLoader {
  final User user;
  const _SessionListLoader({required this.user});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    TrainingSplit? trainingSplit = snapshot.data; 
    int dailySessionIndex = user.getCurrentSession();
    int sessionLength = trainingSplit!.trainingSessions.length;
    int sessionToday = (dailySessionIndex % sessionLength);
    List<ISession?>? ordedSessions = [];
    for (int i = 0; i < sessionLength; i++) {
      ordedSessions.add(trainingSplit.trainingSessions[(i+sessionToday)%sessionLength]);
    }
    return _SessionSelectorList(list: ordedSessions, user: user);
  }

  @override
  Future getFuture() async {
    return await TrainingSplitRetriever(dbID: user.trainingSplitID!).fromDatabase();
  }

}
class _SessionSelectorList extends AbstractOrderedTileList<ISession> {
  const _SessionSelectorList({required super.user,required super.list});
  
  @override
  State<StatefulWidget> createState() => _SessionSelectorListState();
}

class _SessionSelectorListState extends AbstractOrderedTileListState<ISession> {
  @override
  Widget? buildFirstTile(BuildContext context, ISession? element) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue], // Set your desired gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: buildTile(element),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  @override
  Widget? buildLaterTile(BuildContext context, ISession? element) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.green], // Set your desired gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: buildTile(element)
        ),
      ],
    );
  }
    
  @override
  Widget? buildTile(ISession? element) {
    return ListTile(
      title: Text(element!.name),
      textColor: Colors.white,      
      onTap: (){
        onPress(element);
      },
      onLongPress: () {
        onLongPress(element);
      },
    );
  }

  @override
  void onLongPress(ISession? element) async {
    // Do Nothing
  }
  @override
  void onPress(ISession? element) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _SelectionConfirmation(
          callback: _onSelection, 
          displayText: "Are you sure you want to select ${element!.name}? This will delete your current session!", 
          session: element
        );
      }
    );
  }

  void _onSelection(ISession? session) async {
    int dailySessionIndex = widget.user.getCurrentSession();
    int sessionLength = widget.list!.length;
    int offset = ((dailySessionIndex % sessionLength)+widget.list!.indexOf(session))% sessionLength;
    if (widget.user.currentSessionID != null && widget.user.currentSessionID!.isNotEmpty) {
      await FirebaseFirestore.instance.collection("RecordedSessions").doc(widget.user.currentSessionID).delete();
      Logger().i("Deleted Recorded Session ${widget.user.currentSessionID}");
    }
    widget.user.currentSessionID = "";
    widget.user.lastSession = DateTime(1,1,1);
    widget.user.splitTimer = {
      'session':offset,
      'date': DateTime.now()
    };
    await FirebaseFirestore.instance.collection("Users").doc(widget.user.dbID).update({
      'last_session': widget.user.lastSession,
      'split_timer': widget.user.splitTimer
    });
    Logger().i("User timer updated ${widget.user.splitTimer}");
    setState(() {
      List<ISession?>? ordedSessions = [];
      int selectedIndex = widget.list!.indexOf(session);
      int sessionLength = widget.list!.length;
      for (int i = 0; i < sessionLength; i++) {
        ordedSessions.add(widget.list![(i+selectedIndex)%sessionLength]);
      }
      for (int i = 0; i < sessionLength; i ++) {
        widget.list![i] = ordedSessions[i];
      }
    });
    
  }
}

class _SelectionConfirmation extends StatelessWidget {
  final ISession? session;
  const _SelectionConfirmation({required this.displayText, required this.session, required this.callback});
  final String displayText;
  final Function(ISession?) callback;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        height: 200,
        width: 300,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.blue,Colors.blue.shade400],text: "Confirm",onPress: _onConfirm),
                  const SizedBox(width: 20),
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.red,Colors.red.shade400],text: "Cancel",onPress: _popBack),
                ],
              )
            ) 
          ],
        ),
      )
    );
  }
  void _onConfirm(BuildContext context) {
    _popBack(context);
    callback(session);
    
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}