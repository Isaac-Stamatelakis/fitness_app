import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/exercise_core/muscle/muscle_list.dart';
import 'package:flutter/material.dart';

class MovementDialog extends StatelessWidget {
  final MovementPattern? movementPattern;
  const MovementDialog({super.key, required this.movementPattern});

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
              title: Text(
                MovementPatternFactory.patternToString(movementPattern),
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
            const Text("Muscles Trained:"),
            MuscleList(dataList: MovementPatternFactory.getMusclesWorked(movementPattern), colors: [Colors.white,Colors.indigo.shade100],)
          ],
        )
      )
    );
  }

}