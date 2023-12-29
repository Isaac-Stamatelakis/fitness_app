import 'package:fitness_app/exercise_core/display_list_fragment.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';


class ExercisePageLoader extends StatelessWidget {
  final List<Color> colors;
  const ExercisePageLoader({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: EntireExerciseRetriever(ownerID: GlobalConst.userID).retrieve(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MainScaffold(
                content: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/2,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                title: "Exercises"
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else { 
              return ExercisePage(dataList: snapshot.data, colors: colors);
            }
          }
      );
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
  void onPress(data) {
    // TODO: implement onPress
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