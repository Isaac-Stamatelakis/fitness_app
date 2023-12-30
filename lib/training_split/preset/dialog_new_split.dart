import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/page/page_training_split.dart';
import 'package:fitness_app/training_split/preset/split_presets.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';

class NewTrainingSplitDialog extends StatelessWidget {
  final User user;

  const NewTrainingSplitDialog({super.key, required this.user});
  
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Select a Training Split Preset",
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
            TrainingSplitPresetList(
              colors: [Colors.white,Colors.indigo.shade300]
            ),
          ],
        ),
      )
    );
  }
}

class TrainingSplitPresetList extends AbstractList<TrainingSplitPreset> {
  const TrainingSplitPresetList({super.key, required super.colors}) : super(dataList: TrainingSplitPreset.values);
  @override
  State<StatefulWidget> createState() => _TrainingPresetListState();
}

class _TrainingPresetListState extends AbstractListState<TrainingSplitPreset> {
  @override
  Widget? getContainerWidget(TrainingSplitPreset? preset) {
    return Text(
      TrainingSplitPresetFactory.presetToString(preset),
      style: const TextStyle(
        color: Colors.black
      ),
    );
  }

  @override
  void onLongPress(TrainingSplitPreset? data) {
    // Do Nothing
  }

  @override
  void onPress(TrainingSplitPreset? preset) {
    Navigator.pop(context);
    print(preset.toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrainingSplitPage(
        trainingSplit: TrainingSplitPresetFactory.buildSplit(preset))
      )
    );
  }
}