import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:fitness_app/misc/tile_list_first.dart';
import 'package:fitness_app/training_split/db_training_split.dart';
import 'package:fitness_app/training_split/page/page_training_split.dart';
import 'package:fitness_app/training_split/preset/dialog_new_split.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TrainingSplitSelectorDialog extends StatefulWidget {
  final User user;
  const TrainingSplitSelectorDialog({super.key, required this.user});
  
  @override
  State<StatefulWidget> createState() => _TrainingSplitSelectorDialogState();
}


class _TrainingSplitSelectorDialogState extends State<TrainingSplitSelectorDialog> {
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
                "Manage Training Splits",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                SquareGradientButtonSizeable(
                  onPress: _navigateToNewSplit, 
                  text: "Create New Split", 
                  colors: [Colors.red,Colors.red.shade300], 
                  size: const Size(200,100)
                )
              ],
            ),
            _TrainingSplitListLoader(user: widget.user)
          ],
        )
      )
    );
  }

  void _navigateToNewSplit(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewTrainingSplitDialog(user: widget.user);
      }
    );
  }
}

class _TrainingSplitListLoader extends WidgetLoader {
  final User user;

  const _TrainingSplitListLoader({required this.user});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _TrainingSplitList(list: snapshot.data, user: user);
  }

  @override
  Future getFuture() {
    return EmptyTrainingSplitUserQuery(userID: user.dbID!).retrieve();
  }

}

class _TrainingSplitList extends AbstractOrderedTileList<TrainingSplit> {
  const _TrainingSplitList({required super.user,required super.list});
  
  @override
  State<StatefulWidget> createState() => _TrainingSplitListState();
}

class _TrainingSplitListState extends AbstractOrderedTileListState<TrainingSplit> {
  @override
  Widget? buildFirstTile(BuildContext context, TrainingSplit? split) {
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
          child: buildTile(split),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

    @override
    Widget? buildLaterTile(BuildContext context, TrainingSplit? element) {
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
  Widget? buildTile(TrainingSplit? element) {
    return ListTile(
      title: Text(element!.name!),
      textColor: Colors.white,
      trailing: IconButton(
        icon: const Icon(Icons.touch_app),
        color: Colors.white, 
        onPressed: () {
          onPress(element);
        },
      ),
      onLongPress: () {
        onLongPress(element);
      },
      onTap: () {
        _navigateToEdit(context, element);
      },
    );
  }


  void _navigateToEdit(BuildContext context, TrainingSplit? split) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
      ModifyTrainingSplitPageLoader(
          user: widget.user,
          splitID: split!.dbID,
        )
      )
    );
  }

  @override
  void onLongPress(TrainingSplit? split) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DeleteSplitConfirmationDialog(displayText: "Do you want to delete ${split!.name}?", split: split, callback: _onDeleteConfirmation);
      }
    );
  }
  @override
  void onPress(TrainingSplit? split) async {
    User user = widget.user;
    if (user.trainingSplitID == split!.dbID) {
      return;
    }
    await FirebaseFirestore.instance.collection("TrainingSplits").doc(split.dbID).update(
      {
        "last_accessed" : DateTime.now()
      }
    );
    widget.user.lastSession = DateTime(1,1,1);
    widget.user.trainingSplitID = split.dbID;
    widget.user.splitTimer = {
      'session':0,
      'date':DateTime.now()
    };
    await FirebaseFirestore.instance.collection("Users").doc(user.dbID).update(
      {
        "training_split_id" : split.dbID,
        'split_timer': widget.user.splitTimer,
        'last_session': widget.user.lastSession
      }
    );
    Logger().i("User Training Split Changed to ${split.dbID}");
    setState(() {
      widget.list!.remove(split);
      widget.list!.insert(0,split);
    });
  }

  void _onDeleteConfirmation(TrainingSplit? split) async {
    await FirebaseFirestore.instance.collection("TrainingSplits").doc(split!.dbID!).delete();
    Logger().i("Deleted Training Split: ${split.dbID}");
    setState(() {
      widget.list!.remove(split);
    });
  }
}

class _DeleteSplitConfirmationDialog extends StatelessWidget {
  final TrainingSplit? split;
  const _DeleteSplitConfirmationDialog({required this.displayText, required this.split, required this.callback});
  final String displayText;
  final Function(TrainingSplit?) callback;
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
    callback(split);
    
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}