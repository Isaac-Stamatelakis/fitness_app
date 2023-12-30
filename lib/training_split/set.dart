// ignore_for_file: constant_identifier_names

import 'package:fitness_app/exercise_core/exercise/exercise.dart';


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
enum SetType {
  Standard,
  DropSet,
  LengthenedPartialSet,
  IntegratedLengthenedPartialSet,
  Undefined
}

abstract class ISet {

}

/// Similar to how its encoded on database. Let data be data
class Set extends ISet {
  final SetType? type;
  final Map<String, dynamic> data;
  Set({required this.data,required this.type});
}


/// Represents how subsequent sets are stored for a training plan
/// ie sets 3 of bicep curls, data={'rep_range':'8-12'}
class SetCollection extends ISet {
  final int? amount;
  final SetType? type;
  final Map<String, dynamic> data;
  SetCollection({required this.amount, required this.type, required this.data});
}


class SetFactory {
  static SetType? fromString(String string) {
    for (SetType setType in SetType.values) {
      if (setToString(setType) == string) {
        return setType;
      }
    }
    return SetType.Undefined;
  }

  static String? setToString(SetType setType) {
    return setType.toString().split(".")[1];
  }

  static ISet? fromJson<T extends ISet>(Map<String, dynamic> json) {
    if (T is Set) {
      return Set(type: SetFactory.fromString(json['type']), data: json['data']);
    } else if (T is SetCollection) {
      return SetCollection(amount: json['amount'], type: SetFactory.fromString(json['type']), data: json['data']);
    } else {
      return null;
    }
  }
}
