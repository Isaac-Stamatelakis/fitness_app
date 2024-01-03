// ignore_for_file: unused_element, constant_identifier_names, unused_field

import 'dart:math';

import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/page/edit_block/exercise_edit_block.dart';
import 'package:fitness_app/training_split/page/edit_block/set_edit_block.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

class EditBlockDialogFactory extends StatelessWidget {
  final IBlock? block;
  final Function(IBlock?) moveUp;
  final Function(IBlock?) moveDown;
  final Function(IBlock?, IBlock?) onBlockTypeChanged;

  const EditBlockDialogFactory({super.key, this.block, required this.moveUp, required this.moveDown, required this.onBlockTypeChanged});
  @override
  Widget build(BuildContext context) {
    if (block is ExerciseBlock) {
      return _LiftingEditDialog(block: block, moveUp: moveUp, moveDown: moveDown, onBlockTypeChanged: onBlockTypeChanged);
    } else if (block is CardioBlock) {
      return _CardioEditDialog(block: block, moveUp: moveUp, moveDown: moveDown, onBlockTypeChanged: onBlockTypeChanged);
    }
    return Container();
  }

}

abstract class _EditBlockDialog extends StatefulWidget {
  final IBlock? block;
  final Function(IBlock?) moveUp;
  final Function(IBlock?) moveDown;
  final Function(IBlock?, IBlock?) onBlockTypeChanged;
  const _EditBlockDialog({super.key, required this.block, required this.moveUp, required this.moveDown, required this.onBlockTypeChanged});
}

abstract class _EditBlockDialogState extends State<_EditBlockDialog> {
  late _EditBlockMenuOption selectedOption = _EditBlockMenuOption.Exercises;
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
        child: SingleChildScrollView(
           child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.black,
                title: const Text(
                  "Edit Block",
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
              const SizedBox(height: 20),
              _BlockTypeSelector(onSelect: _onBlockTypeChanged, initalSelect: _getOption()),
              const SizedBox(height: 20),
              _EditSelector(onSelect: _onOptionChanged, initalSelect: _EditBlockMenuOption.Exercises),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SquareGradientButtonSizeable(
                    onPress: _onSavePress, 
                    text: "Update", 
                    colors: [Colors.blue,Colors.blue.shade300], 
                    size: const Size(100,50)
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){widget.moveUp(widget.block);}, 
                        icon: const Icon(
                          Icons.arrow_circle_up,
                          color: Colors.white,
                          size: 50,
                        )
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: (){widget.moveDown(widget.block);}, 
                        icon: const Icon(
                          Icons.arrow_circle_down,
                          color: Colors.white,
                          size: 50,
                        )
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _getOptionContent(),
              
            ],
          )
        ),
      )
    );
  }
  Widget _getOptionContent();

  void _onMovementSelected(MovementPattern? pattern) {
    setState(() {
      widget.block!.movementPattern = pattern;
      widget.block!.exercise = null;
      widget.block!.variation = null;
    });
  } 

  void _onSavePress(BuildContext context) {
    print(widget.block!.movementPattern.toString());
    print(widget.block!.exercise!.exerciseName);
  }

  void _onOptionChanged(_EditBlockMenuOption? option) {
    if (option == null) {
      return;
    }
    setState(() {
      selectedOption = option;
    });
  }

  void _onBlockTypeChanged(_BlockTypeOption? option) {
    if (option == null) {
      return;
    }
    IBlock? newBlock;
    switch (option) {
      case _BlockTypeOption.Lifting:
        newBlock = ExerciseBlock(null, sets: [], movementPattern: null, exercise: null);
      case _BlockTypeOption.Cardio:
        newBlock = CardioBlock(null, movementPattern: MovementPattern.Cardio, exercise: null, set: CardioSet(duration: 0));
    }
    widget.onBlockTypeChanged(widget.block, newBlock);
  }

  _BlockTypeOption _getOption() {
    if (widget.block is ExerciseBlock) {
      return _BlockTypeOption.Lifting;
    } else {
      return _BlockTypeOption.Cardio;
    }
  }
}

class _LiftingEditDialog extends _EditBlockDialog {
  const _LiftingEditDialog({required super.block, required super.moveUp, required super.moveDown, required super.onBlockTypeChanged});
  @override
  State<StatefulWidget> createState() => _LiftingEditDialogState();

}

class _LiftingEditDialogState extends _EditBlockDialogState {
  @override
  Widget _getOptionContent() {
    switch (selectedOption) {
      case _EditBlockMenuOption.Exercises:
        return LiftingEditBlockExercise(block: widget.block, onMovementSelected: _onMovementSelected);
      case _EditBlockMenuOption.Sets:
        return LiftingEditBlockSet(block: widget.block);
    }
  }
}

class _CardioEditDialog extends _EditBlockDialog {
  const _CardioEditDialog({required super.block, required super.moveUp, required super.moveDown, required super.onBlockTypeChanged});
  @override
  State<StatefulWidget> createState() => _CardioEditDialogState();

}

class _CardioEditDialogState extends _EditBlockDialogState {
  @override
  Widget _getOptionContent() {
    switch (selectedOption) {
      case _EditBlockMenuOption.Exercises:
        return CardioEditBlockExercise(block: widget.block, onMovementSelected: _onMovementSelected);
      case _EditBlockMenuOption.Sets:
        return CardioEditBlockSet(block: widget.block);
    }
  }

}

enum _EditBlockMenuOption {
  Exercises,
  Sets
}


class _EditSelector extends AbstractDropDownSelector<_EditBlockMenuOption> {
  const _EditSelector({required super.onSelect, required super.initalSelect}) : super(options: _EditBlockMenuOption.values);
  @override
  _EditSelectorState createState() => _EditSelectorState();
}

class _EditSelectorState extends AbstractDropDownSelectorState<_EditBlockMenuOption> {
  @override
  String optionToString(_EditBlockMenuOption option) {
    switch (option) {
      case _EditBlockMenuOption.Exercises:
        return "Edit Exercises";
      case _EditBlockMenuOption.Sets:
        return "Edit Sets";
    }
  }
}

enum _BlockTypeOption {
  Lifting,
  Cardio
}

class _BlockTypeSelector extends AbstractDropDownSelector<_BlockTypeOption> {
  const _BlockTypeSelector({required super.onSelect, required super.initalSelect}) : super(options: _BlockTypeOption.values);

  @override
  State<StatefulWidget> createState() => _BlockTypeSelectorState();

}

class _BlockTypeSelectorState extends AbstractDropDownSelectorState<_BlockTypeOption> {
  @override
  String optionToString(_BlockTypeOption option) {
    switch (option) {
      default:
        return option.toString().split(".")[1];
    }
  }

}

