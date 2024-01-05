import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/page/edit_block/exercise_edit_block.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddExerciseDialog extends StatefulWidget {
  final String userID;
  final Function(IExercise?) callback;
  const AddExerciseDialog({super.key, required this.userID, required this.callback});

  @override
  State<AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  late String input = "";
  late MovementPattern movementPattern = MovementPattern.VerticalPull;
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
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Add Exercise Variation",
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
            _MovementPatternSelector(
              initalSelect: MovementPattern.VerticalPull, 
              options: MovementPatternFactory.getNoneNullPatterns(), 
              onSelect: _onMovementPatternSelected
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                labelStyle: TextStyle(
                  color: Colors.grey
                )
              ),
              onChanged: (value) {
                input = value;
              },
            ),
            SquareGradientButton(
              height: 50, 
              onPress: _addExercise, 
              text: "Add", 
              colors: [Colors.red,Colors.red.shade300]
            )
          ],
        )
      )
    );
  }
  
  void _addExercise(BuildContext context) async {
    if (input.isEmpty) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("Exercise $input Successfully Added!"),
        duration: const Duration(seconds: 2), 
      )
    );
    Navigator.pop(context);
    DocumentReference reference = await FirebaseFirestore.instance.collection("CustomExercises").add({
      'movementPattern' : MovementPatternFactory.patternToString(movementPattern),
      'name' : input,
      'owner_id' : widget.userID
    });
    
    IExercise exercise = IExercise(
      movementPattern: movementPattern, 
      exerciseName: input, 
      dbID: reference.id, 
      exerciseType: ExerciseType.Custom
    );
    Logger().i("Added exercise $input id: ${reference.id}");
    widget.callback(exercise);
  }
  void _onMovementPatternSelected(MovementPattern? movementPattern) {
    this.movementPattern = movementPattern!;
  }
}


class _MovementPatternSelector extends AbstractDropDownSelector<MovementPattern> {
  const _MovementPatternSelector({required super.onSelect, required super.options, required super.initalSelect});

  @override
  State<StatefulWidget> createState() => _MovementPatternSelectorState();

}

class _MovementPatternSelectorState extends AbstractDropDownSelectorState<MovementPattern> {
  @override
  String optionToString(option) {
    return MovementPatternFactory.patternToFormattedString(option);
  }

}