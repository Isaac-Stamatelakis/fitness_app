
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/misc/database.dart';
import 'package:fitness_app/record_session/recorded_training_session.dart';
import 'package:fitness_app/training_split/training_split.dart';

class RecordedSessionRetriever extends AsyncDatabaseHelper<RecordedTrainingSession> {
  final String dbID;
  RecordedSessionRetriever({required this.dbID});
  @override
  Future<RecordedTrainingSession?> fromDocument(DocumentSnapshot<Object?> snapshot) async {
    return await TrackedBlockFactory.fromDocument(snapshot);
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("RecordedSessions").doc(dbID);
  }

}