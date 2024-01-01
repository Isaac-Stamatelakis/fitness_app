import 'dart:math';

import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
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
  late MovementPattern? selectedPattern;
  late IExercise? selectedExercise;
  late ExerciseVariation? selectedVariation;

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
            _MovementPatternDropButton(
              list: MovementPatternFactory.getNoneNullPatterns(), 
              width: double.infinity, 
              label: 'Search Movements', 
              onSelect: _onMovementSelected
            ),
            const SizedBox(height: 20),
            _ExerciseDropDownLoader(
              pattern: widget.block!.movementPattern, 
              onSelect: _onExerciseSelected,
            ),
            const SizedBox(height: 20),
            _ExerciseVariationDropButtonLoader(
              onSelect: _onVariationSelected, 
              exercise: selectedExercise
            ),
          ],
        )
      )
    );
  
  }

  void _onMovementSelected(MovementPattern pattern) {

  }

  void _onExerciseSelected(IExercise exercise) {

  }

  void _onVariationSelected(ExerciseVariation variation) {

  }

  void _onSavePress(BuildContext context) {

  }
}

class _MovementPatternDropButton extends ASearchDropDownButton<MovementPattern> {
  const _MovementPatternDropButton({required super.list, required super.width, required super.label, required super.onSelect});
  @override
  State<StatefulWidget> createState() => _DropButtonState();

}

class _DropButtonState extends ASearchDropDownButtonState<MovementPattern> {
  @override
  String elementToString(MovementPattern movementPattern) {
    return MovementPatternFactory.patternToString(movementPattern);
  }
}

class _ExerciseDropDownLoader extends WidgetLoader {
  final MovementPattern? pattern;
  final Function(IExercise) onSelect;
  const _ExerciseDropDownLoader({required this.onSelect, required this.pattern});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _ExerciseDropButton(list: snapshot.data, width: double.infinity, label: "Search Exercises", onSelect: onSelect,);
  }

  @override
  Future getFuture() {
    return EntirePatternExerciseQuery(pattern: pattern).retrieve();
  }

}

class _ExerciseDropButton extends ASearchDropDownButton<IExercise> {
  const _ExerciseDropButton({required super.list, required super.width, required super.label, required super.onSelect});
  @override
  State<StatefulWidget> createState() => _ExerciseDropButtonState();
}

class _ExerciseDropButtonState extends ASearchDropDownButtonState<IExercise> {
  @override
  String elementToString(IExercise element) {
    return element.exerciseName;
  }
}

class _ExerciseVariationDropButtonLoader extends WidgetLoader {
  final IExercise? exercise;
  final Function(ExerciseVariation) onSelect;
  const _ExerciseVariationDropButtonLoader({required this.onSelect, required this.exercise});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _ExerciseVariationDropButton(list: snapshot.data, width: double.infinity, label: "Search Variations", onSelect: onSelect,);
  }

  @override
  Future getFuture() {
    return ExerciseVariationRetriever(exerciseID: exercise!.dbID).retrieve();
  }

}

class _ExerciseVariationDropButton extends ASearchDropDownButton<ExerciseVariation> {
  const _ExerciseVariationDropButton({required super.list, required super.width, required super.label, required super.onSelect});
  @override
  State<StatefulWidget> createState() => _ExerciseVariationDropButtonState();
}

class _ExerciseVariationDropButtonState extends ASearchDropDownButtonState<ExerciseVariation> {
  @override
  String elementToString(ExerciseVariation? element) {
    return element!.variationName;
  }
}