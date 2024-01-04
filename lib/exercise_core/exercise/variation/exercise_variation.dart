import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/misc/database.dart';

class ExerciseVariation {
  ExerciseVariation(this.dbID, {required this.variationName});
  final String variationName;
  final String dbID;
}

class ExerciseVariationFactory {
  static ExerciseVariation fromDocument(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return ExerciseVariation(snapshot.id, variationName: data['name']);
  } 
}

class ExerciseVariationQuery extends MultiDatabaseRetriever<ExerciseVariation> {
  final String exerciseID;
  ExerciseVariationQuery({required this.exerciseID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return ExerciseVariationFactory.fromDocument(snapshot);
  }
  @override
  Future<QuerySnapshot<Object?>> getQuerySnapshot() {
    return FirebaseFirestore.instance.collection("ExerciseVariations").where('exercise_id', isEqualTo: exerciseID).get();
  }
}

class ExerciseVariationRetriever extends DatabaseHelper<ExerciseVariation> {
  final String dbID;
  ExerciseVariationRetriever({required this.dbID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return ExerciseVariationFactory.fromDocument(snapshot);
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("ExerciseVariations").doc(dbID);
  }

}