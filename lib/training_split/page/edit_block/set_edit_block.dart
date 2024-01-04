
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

class LiftingEditBlockSet extends StatefulWidget {
  final IBlock? block;
  const LiftingEditBlockSet({super.key, required this.block});

  @override
  State<StatefulWidget> createState() => _EditSetWidgetState();
}

class _EditSetWidgetState extends State<LiftingEditBlockSet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: _addSet, icon: const Icon(Icons.add)),
        SetFactory.buildSetSelector(widget.block)
      ],
    );
  }

  void _addSet() {
    IBlock? block = widget.block; 
    setState(() {
      if (block is ExerciseBlock) {
        block.sets!.add(
          LiftingSet(data: {}, type: LiftingSetType.Standard)
        );
      }
    });
  }
}

class CardioEditBlockSet extends StatefulWidget {
  final IBlock? block;
  const CardioEditBlockSet({super.key, required this.block});

  @override
  State<StatefulWidget> createState() => _CardioEditBlockSetState();
}

class _CardioEditBlockSetState extends State<CardioEditBlockSet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SetFactory.buildSetSelector(widget.block)
      ],
    );
  }
}