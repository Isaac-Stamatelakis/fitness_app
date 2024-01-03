// ignore_for_file: constant_identifier_names

import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/muscle/muscle_list.dart';
import 'package:fitness_app/exercise_core/muscle/muscles.dart';
import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/training_split/set/dialog_edit_set.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


/*
class Set extends ISet {
  final Exercise exercise;
  final int reps;
  final double weight;

  Set({required this.exercise, required this.reps, required this.weight});
}

class DropSet extends ISet {
  final int targetRep;
  final int finalRep;
  final double weightDrop;
  final double startWeight;

  DropSet({required this.targetRep, required this.finalRep, required this.weightDrop, required this.startWeight});
}

class LengthenedPartialSet extends Set {
  LengthenedPartialSet({required super.exercise, required super.reps, required super.weight});

}

class IntegratedLengthenedPartialSet extends Set {
  IntegratedLengthenedPartialSet({required super.exercise, required super.reps, required super.weight});
  
}

*/
enum LiftingSetType {
  Standard,
  DropSet,
  LengthenedPartialSet,
  IntegratedLengthenedPartialSet,
}

abstract class ISet {

}

class CardioSet extends ISet {
  late int duration;
  CardioSet({required this.duration});
}
/// Represents how subsequent sets are stored for a training plan
/// ie sets 3 of bicep curls, data={'rep_range':'8-12'}
class LiftingSet extends ISet {
  late LiftingSetType? type;
  late Map<String, dynamic> data;
  LiftingSet({required this.type, required this.data});
}


class LiftingSetFactory {
  static Map<String, dynamic> formatStaticEmptyJson(LiftingSet set) {
    if (
      set.type == LiftingSetType.IntegratedLengthenedPartialSet ||
      set.type == LiftingSetType.LengthenedPartialSet ||
      set.type == LiftingSetType.Standard 
    ) {
      return {
        "amount" : 0,
        "rep_range": "8-12",
      };
    } else if (
      set.type == LiftingSetType.DropSet 
    ) {
      return {
        "weight_drop" : 15,
        "rep_range" : 0
      };
    }
    return {};
  }
  static Map<String, dynamic> cleanUpStaticSetData(LiftingSet set) {
    Iterable<String> keys = set.data.keys;
    if (
      set.type == LiftingSetType.IntegratedLengthenedPartialSet ||
      set.type == LiftingSetType.LengthenedPartialSet ||
      set.type == LiftingSetType.Standard 
    ) {
      
      for (String key in keys) {
        if (key != 'amount' || key != 'rep_range') {
          set.data.remove(key);
        }
      }
    } else if (
      set.type == LiftingSetType.DropSet 
    ) {
      for (String key in keys) {
        if (key != 'weight_drop' || key != 'rep_range') {
          set.data.remove(key);
        }
      }
    }
    return {};
  }
  static String formatString(LiftingSet set) {
    if (set.data.isEmpty) {
      return "";
    }
    switch (set.type) {
      case null:
        return "";
      case LiftingSetType.Standard:
        return "${set.data['amount']} Sets of ${set.data['rep_range']} Reps";
      case LiftingSetType.DropSet:
        return "Drop Set ${set.data['reps']} weight drop ${set.data['weight_drop']}";
      case LiftingSetType.LengthenedPartialSet:
        return "${set.data['amount']} Lengthened Partial Sets of ${set.data['rep_range']} Reps";
      case LiftingSetType.IntegratedLengthenedPartialSet:
        return "${set.data['amount']} Integrated Lengthened Partial Sets of ${set.data['rep_range']} Reps";
    }
  }
}

class SetFactory {
  static LiftingSetType? liftingSetTypeFromString(String string) {
    for (LiftingSetType setType in LiftingSetType.values) {
      if (liftingSetTypeToString(setType) == string) {
        return setType;
      }
    }
    return null;
  }

  static String liftingSetTypeToString(LiftingSetType? setType) {
    return setType.toString().split(".")[1];
  }

  static ISet? fromJson<T extends ISet>(Map<String, dynamic> json) {
   if (T is LiftingSet) {
      return LiftingSet(type: SetFactory.liftingSetTypeFromString(json['type']), data: json['data']);
    } else {
      return null;
    }
  }

  static Widget buildSetSelector(IBlock? block) {
    List<Color> colors = const [Colors.black, Colors.black87];
    Size size = const Size(300,400);
    if (block is ExerciseBlock) {
      return _LiftingSetList(dataList: block.sets, colors: colors, size: size);
    } else if (block is CardioBlock) {
      return _CardioSetList(dataList: [block.set as ISet], colors: colors, size: size,);
    } 
    return Container();
  }

  static Widget buildTextFromSet(ISet? set) {
    if (set is LiftingSet) {
      return Text(
        liftingSetTypeToString(set.type),
        style: const TextStyle(
          color: Colors.white70
        ),
      );
    } else if (set is CardioSet) {
      return Text(
        "Duration: ${set.duration} Minutes",
        style: const TextStyle(
          color: Colors.white70
        ),
      );
    }
    return Container();
  }
}


class _LiftingSetList extends NonFlexAbstractList<ISet> {
  const _LiftingSetList({required super.dataList, required super.colors, required super.size});
  @override
  State<StatefulWidget> createState() => _SetListState();
}

class _SetListState extends NonFlexAbstractListState<ISet> {
  @override
  Widget? getContainerWidget(ISet? set) {
    return SetFactory.buildTextFromSet(set);
  }

  @override
  void onLongPress(ISet? set) {
    setState(() {
      widget.dataList!.remove(set);
    });
  }

  @override
  void onPress(ISet? set) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LiftingEditSetDialogue(set: set as LiftingSet);
      }
    );
    setState(() {
      
    });
  }

}

class _CardioSetList extends NonFlexAbstractList<ISet> {
  const _CardioSetList({required super.dataList, required super.colors, required super.size});
  @override
  State<StatefulWidget> createState() => _CardioSetListState();
}

class _CardioSetListState extends NonFlexAbstractListState<ISet> {
  @override
  Widget? getContainerWidget(ISet? set) {
    return SetFactory.buildTextFromSet(set);
  }

  @override
  void onLongPress(ISet? set) {
    // Do Nothing
  }

  @override
  void onPress(ISet? set) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CardioEditSetDialogue(set: set as CardioSet);
      }
    );
    setState(() {
      
    });
  }

}