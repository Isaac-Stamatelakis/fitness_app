// ignore_for_file: unused_element, constant_identifier_names

import 'dart:math';

import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/page/edit_block/exercise_edit_block.dart';
import 'package:fitness_app/training_split/page/edit_block/set_edit_block.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';



class EditBlockDialog extends StatefulWidget {
  final IBlock? block;
  final Function(IBlock?) moveUp;
  final Function(IBlock?) moveDown;
  const EditBlockDialog({super.key, required this.block, required this.moveUp, required this.moveDown});

  @override
  State<EditBlockDialog> createState() => _EditBlockDialogState();
}

class _EditBlockDialogState extends State<EditBlockDialog> {
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
              _EditSelector(onSelect: _onOptionChanged),
              const SizedBox(height: 20),
              SizedBox(
                  width: 300,
                  child: _getOptionContent(),
              )
            ],
          )
        ),
      )
    );
  
  }

  Widget _getOptionContent() {
    switch (selectedOption) {
      case _EditBlockMenuOption.Exercises:
        return EditBlockExercise(block: widget.block, onMovementSelected: _onMovementSelected);
      case _EditBlockMenuOption.Sets:
        return EditBlockSet(block: widget.block);
    }
  }
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
}

class _EditSelector extends StatefulWidget {
  final Function(_EditBlockMenuOption?) onSelect;

  const _EditSelector({super.key, required this.onSelect});
  @override
  _EditSelectorState createState() => _EditSelectorState();
}

class _EditSelectorState extends State<_EditSelector> {
  final List<_EditBlockMenuOption> options = _EditBlockMenuOption.values;
  late _EditBlockMenuOption selected = options[0];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.black
      ), 
      child: SizedBox(
        width: 300,
        height: 50, 
        child :DropdownButton<_EditBlockMenuOption>(
          value: selected,
          onChanged: (_EditBlockMenuOption? newValue) {
            widget.onSelect(newValue);
          },
          items: options.map((_EditBlockMenuOption option) {
            return DropdownMenuItem<_EditBlockMenuOption>(
              value: option,
              child: Row(
                children: [
                  Text(
                    optionToString(option),
                    style: const TextStyle(
                      color: Colors.white70
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      )
    );
  }

  String optionToString(_EditBlockMenuOption option) {
    switch (option) {
      case _EditBlockMenuOption.Exercises:
        return "Edit Exercises";
      case _EditBlockMenuOption.Sets:
        return "Edit Sets";
    }
  }
}

enum _EditBlockMenuOption {
  Exercises,
  Sets
}

