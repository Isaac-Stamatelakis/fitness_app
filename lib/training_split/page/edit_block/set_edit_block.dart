
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

class EditBlockSet extends StatefulWidget {
  final IBlock? block;
  const EditBlockSet({super.key, required this.block});

  @override
  State<StatefulWidget> createState() => _EditSetWidgetState();
}

class _EditSetWidgetState extends State<EditBlockSet> {
  @override
  Widget build(BuildContext context) {

    if (widget.block is ExerciseBlock?) {
      ExerciseBlock? eBlock = widget.block as ExerciseBlock?;
      print(eBlock!.sets.length);
    }
    return const Column(
      children: [
        //_SetList(dataList: widget.,)
      ],
    );
  }
}

class _SetList extends AbstractList<ISet> {
  final List<ISet> sets;

  _SetList({required super.dataList, required super.colors, required this.sets});
  @override
  State<StatefulWidget> createState() => _SetListState();

}

class _SetListState extends AbstractListState<ISet> {
  @override
  Widget? getContainerWidget(ISet? set) {
    // TODO: implement getContainerWidget
    throw UnimplementedError();
  }

  @override
  void onLongPress(ISet? set) {
    // TODO: implement onLongPress
  }

  @override
  void onPress(ISet? set) {
    // TODO: implement onPress
  }

}