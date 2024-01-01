import 'package:fitness_app/misc/display_list_fragment.dart';
import 'package:fitness_app/exercise_core/movement_pattern/move_dialog.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:flutter/material.dart';

class MovementPatternPage extends DisplayListFragment<MovementPattern> {
  const MovementPatternPage({super.key, required super.dataList, required super.colors});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends DisplayListFragmentState<MovementPattern> {
  

  @override
  void onPress(MovementPattern movementPattern) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MovementDialog(movementPattern: movementPattern);
      }
    );
  }
  
  @override
  Widget buildExtraContent() {
    // No extra content
    return Container();
  }
  
  @override
  String getTitle() {
    return "Movement Patterns";
  }
  
  @override
  void onLongPress(MovementPattern data) {
    // Do nothing
  }

  @override
  String getString(MovementPattern pattern) {
    return MovementPatternFactory.patternToString(pattern);
  }
}