import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/dialog_add_exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/misc/display_list_fragment.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_dialog.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';

class ExercisePageLoader extends PageLoader {
  const ExercisePageLoader({super.key});

  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: "Exercises",
      content:  ExercisePage(dataList: snapshot.data, colors: const [Colors.black,Colors.black87]), 
    );
  }

  @override
  Future getFuture() {
    return EntireExerciseRetriever(ownerID: GlobalConst.userID).retrieve();
  }

  @override
  String getTitle() {
    return "Exercises";
  }
}



class ExercisePage extends DisplayListFragment<IExercise> {
  const ExercisePage({super.key, required super.dataList, required super.colors});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends DisplayListFragmentState<IExercise> {
  @override
  void onPress(IExercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExerciseDialog(exercise: exercise);
      }
    );
  }
  
  @override
  Widget buildExtraContent() {
    return Positioned(
      bottom: 10,
      left: 10,
      child: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          color: Colors.white
        ),
        onPressed: (){_addExercise();}
      )
    );
  }
  
  void _addExercise() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseDialog(userID: GlobalConst.userID, callback: _onAdd);
      }
    );
  }

  void _onAdd(IExercise? exercise) {
    setState(() {
      widget.dataList!.insert(0,exercise);
    });
  }
  @override
  String getTitle() {
    return "Exercises";
  }
  
  @override
  void onLongPress(IExercise? exercise) {
    switch (exercise!.exerciseType) {

      case ExerciseType.Custom:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              displayText: "Are you sure you want to remove ${exercise.exerciseName}?", 
              // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
              onConfirmCallback: (BuildContext) {
                _deleteVariation(exercise);
              }
            );
          }
        );
      case ExerciseType.Preset:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleButtonDialog(
              displayText: "Can't Remove Preset Exercises", 
              buttonText: 'Continue', 
              buttonColors: [Colors.blue,Colors.blue.shade300], 
              dialogColors: const [Colors.black, Colors.black87], 
            
            );
          }
        );
    }
  }
 
  void _deleteVariation(IExercise? exercise) async {
    super.valueList.remove(exercise);
    widget.dataList!.remove(exercise);
    setState(() {

    });
    await FirebaseFirestore.instance.collection("CustomExercises").doc(exercise!.dbID).delete();
    Logger().i("Deleted ${exercise.exerciseName} id:${exercise.dbID}");
  }

  @override
  String getString(IExercise exercise) {
    return exercise.exerciseName;
  }
}