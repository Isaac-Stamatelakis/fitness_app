import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class ExerciseVariationList extends AbstractList<ExerciseVariation> {
  const ExerciseVariationList({super.key, required super.dataList, required super.colors});
  @override
  State<StatefulWidget> createState() => _ExerciseVariationListState();

}
class _ExerciseVariationListState extends AbstractListState<ExerciseVariation> {
  @override
  Widget? getContainerWidget(ExerciseVariation? data) {
    return Text(
      data!.variationName,
      style: const TextStyle(
        color: Colors.grey
      ),
    );
  }
  
  @override
  void onLongPress(ExerciseVariation? data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          displayText: "Are you sure you want to remove ${data?.variationName}?", 
          // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
          onConfirmCallback: (BuildContext) {
            _deleteVariation(data!);
          }
        );
      }
    );
  }
  
  @override
  void onPress(ExerciseVariation? data) {
    // Do Nothing
  }
  
  void _deleteVariation(ExerciseVariation data) {
    FirebaseFirestore.instance.collection("ExerciseVariations").doc(data.dbID).delete()
    .then((_) {
      Logger().i("Deleted ${data.variationName} id:${data.dbID}");
      setState(() {
        widget.dataList?.remove(data);
      });
    })
    .catchError((error) {
      Logger().e("Deletion of ${data.variationName} id:${data.dbID} Failed error:$error");
    });
  }
}

class ExerciseVariationListLoader extends WidgetLoader {
  final List<Color> colors;
  final String exerciseID;

  const ExerciseVariationListLoader({super.key, required this.colors, required this.exerciseID});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return ExerciseVariationList(colors: colors, dataList: snapshot.data);
  }

  @override
  Future getFuture() {
    return ExerciseVariationRetriever(exerciseID: exerciseID).retrieve();
  }
}