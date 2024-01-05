import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class AddExerciseVariationDialog extends StatefulWidget {
  final IExercise exercise;
  final Function(ExerciseVariation) callback;
  const AddExerciseVariationDialog({super.key, required this.exercise, required this.callback});

  @override
  State<AddExerciseVariationDialog> createState() => _AddExerciseVariationDialogState();
}

class _AddExerciseVariationDialogState extends State<AddExerciseVariationDialog> {
  late String input;

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
            TextField(
              decoration: const InputDecoration(
                labelText: 'Variation Name',
                labelStyle: TextStyle(
                  color: Colors.grey
                )
              ),
              onChanged: (value) {
                input = value;
              },
            ),
            SquareGradientButton(height: 50, onPress: _addVariation, text: "Add", colors: [Colors.red,Colors.red.shade300])
          ],
        )
      )
    );
  }

  void _addVariation(BuildContext context) async {
    Map<String, dynamic> jsonDoc = {
      "name" : input,
      "exercise_id": widget.exercise.dbID
    };
    FirebaseFirestore.instance.collection("ExerciseVariations").add(jsonDoc)
    .then((DocumentReference docRef) {
      Logger().i("Document added with ID: ${docRef.id}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Exercise Variation $input Successfully Added!"),
          duration: const Duration(seconds: 2), 
        )
      );
      Navigator.pop(context);
      widget.callback(ExerciseVariation(docRef.id, variationName: input));
    })
    .catchError((error) {
      Logger().e("Error adding document: $error");
      Navigator.pop(context);
    }
  );
  }
}
