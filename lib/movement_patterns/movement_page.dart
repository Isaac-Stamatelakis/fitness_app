import 'package:fitness_app/movement_patterns/display_list_fragment.dart';
import 'package:fitness_app/movement_patterns/movement_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class MovementPageLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class MovementPatternPage extends DisplayListFragment<MovementPattern> {
  const MovementPatternPage({super.key, required super.dataList, required super.colors});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends DisplayListFragmentState<MovementPattern> {
  @override
  Widget? buildText(data) {
    return Text(
      MovementPatternMuscleFactory.movementPatternToString(data),
      style: const TextStyle(
        color: Colors.white
      ),
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
  
  @override
  String getTitle() {
    return "Movement Patterns";
  }
  
  @override
  void onLongPress(MovementPattern data) {
    // Do nothing
  }
  
  @override
  void updateDisplayedFields(String searchText) {
    // TODO: implement updateDisplayedFields
  }
}