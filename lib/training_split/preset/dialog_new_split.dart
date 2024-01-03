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
              colors: [Colors.white,Colors.indigo.shade300], 
              user: user,
            ),
          ],
        ),
      )
    );
  }
}

class TrainingSplitPresetList extends AbstractList<TrainingSplitPreset> {
  final User user;
  const TrainingSplitPresetList({super.key, required super.colors, required this.user}) : super(dataList: TrainingSplitPreset.values);
  @override
  State<StatefulWidget> createState() => _TrainingPresetListState();
}

class _TrainingPresetListState extends State<TrainingSplitPresetList> implements IButtonListState<TrainingSplitPreset>{
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: ListView.builder(
          itemCount: widget.dataList?.length,
          itemBuilder: (context, index) {
            return _buildTile(context,widget.dataList?[index]);
          },
        ),
      ) 
    );
  }

  Widget? _buildTile(BuildContext context, TrainingSplitPreset? data) {
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
                colors: widget.colors,
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrainingSplitPage(
        trainingSplit: TrainingSplitPresetFactory.buildSplit(preset), 
        user: widget.user,
        )
      )
    );
  }
  
  
}