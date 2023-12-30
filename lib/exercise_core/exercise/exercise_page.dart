import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/misc/display_list_fragment.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_dialog.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExercisePageLoader extends PageLoader {
  const ExercisePageLoader({super.key});

  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return ExercisePage(dataList: snapshot.data, colors: const [Colors.black,Colors.black87]);
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



class ExercisePage extends DisplayListFragment<Exercise> {
  const ExercisePage({super.key, required super.dataList, required super.colors});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends DisplayListFragmentState<Exercise> {
  @override
  Widget? buildText(Exercise exercise) {
    return Text(
      exercise.exerciseName
    );
  }

  @override
  void onPress(Exercise exercise) {
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
        onPressed: (){}
      )
    );
  }
  
  @override
  String getTitle() {
    return "Exercises";
  }
  
  @override
  void onLongPress(Exercise data) {
    print("Hello");
  }
  
  @override
  void updateDisplayedFields(String searchText) {
    // TODO: implement updateDisplayedFields
  }
}