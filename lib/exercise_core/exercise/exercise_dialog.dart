import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_page.dart';
import 'package:fitness_app/exercise_core/exercise/variation/add_variation_dialog.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/exercise/variation/variation_display.dart';
import 'package:fitness_app/exercise_core/movement_pattern/move_dialog.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:flutter/material.dart';

/// Displays exercise name, movement pattern, exercise variations, PR

class ExerciseDialog extends StatefulWidget {
  const ExerciseDialog({super.key, required this.exercise});
  final Exercise exercise;
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExerciseDialog> {
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
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.black,
                  title: Text(
                    widget.exercise.exerciseName,
                    style: const TextStyle(
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
                SquareGradientButton(
                  height: 100,
                  onPress: _showMovementDialog, 
                  text: MovementPatternMuscleFactory.movementPatternToString(widget.exercise.movementPattern), 
                  colors: [Colors.blue,Colors.blue.shade300]
                ),
                const SizedBox(
                  height: 30,
                ),
                ExerciseVariationListLoader(colors: [Colors.white,Colors.indigo.shade100], exerciseID: widget.exercise.dbID)
              ],
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.add,
                  color: Colors.white
                ),
                onPressed: (){_addExerciseVariation(context);}
              )
            )
            
          ],
        )
      )
    );
  }

  void _showMovementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MovementDialog(movementPattern: widget.exercise.movementPattern);
      }
    );
  }
  
  void _addExerciseVariation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseVariationDialog(exercise: widget.exercise, callback: _onVariationAdded);
      }
    );
  }

  void _onVariationAdded(ExerciseVariation variation) {
    setState(() {
      
    });
  }
}

