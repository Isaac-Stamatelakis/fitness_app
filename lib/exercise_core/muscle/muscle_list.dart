import 'package:fitness_app/exercise_core/muscle/muscles.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:flutter/material.dart';

class MuscleList extends AbstractList<Muscle> {
  const MuscleList({required super.dataList, super.key, required super.colors});
  
  @override
  State<StatefulWidget> createState() => _MuscleListState();
}

class _MuscleListState extends AbstractListState<Muscle> {
  @override
  Widget? getContainerWidget(Muscle? data) {
    return Text(
      MuscleHelper.muscleToString(data),
      style: const TextStyle(
        color: Colors.black
      ),
    );
  }
  
  @override
  void onLongPress(Muscle? data) {
    // Do Nothing
  }
  
  @override
  void onPress(Muscle? data) {
    // Do Nothing
  }

}