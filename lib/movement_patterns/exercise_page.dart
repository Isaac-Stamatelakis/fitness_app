import 'package:fitness_app/movement_patterns/display_list_fragment.dart';
import 'package:fitness_app/movement_patterns/exercise.dart';
import 'package:fitness_app/movement_patterns/movement_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExercisePage extends DisplayListFragment<Exercise> {
  const ExercisePage({super.key, required super.dataList, required super.colors});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends DisplayListFragmentState<Exercise> {
  @override
  Widget? buildText(Exercise exercise) {
    return Text(
      exercise.exerciseName
    );
  }

  @override
  void onPress(data) {
    // TODO: implement onPress
  }
  
  @override
  Widget buildExtraContent() {
    return Container();
  }
}