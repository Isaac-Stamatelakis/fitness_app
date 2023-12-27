import 'package:fitness_app/movement_patterns/display_list_fragment.dart';
import 'package:fitness_app/movement_patterns/movement_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class MovementPatternPage extends DisplayListFragment<MovementPattern> {
  const MovementPatternPage({super.key, required super.dataList, required super.colors});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends DisplayListFragmentState<MovementPattern> {
  @override
  Widget? buildText(data) {
    return Text(
      data.toString(),

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