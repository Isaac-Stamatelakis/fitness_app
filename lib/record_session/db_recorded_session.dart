
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

/// Returns Recorded Training Session with empty block
class RecordedSessionUserQuery extends MultiDatabaseRetriever<RecordedTrainingSession> {
  final String userID;
  RecordedSessionUserQuery({required this.userID});
  @override
  RecordedTrainingSession fromDocument(DocumentSnapshot<Object?> snapshot) {
    Timestamp timestamp = snapshot['created'];
    return RecordedTrainingSession(
      staticSessionID: snapshot['static_session_id'], 
      name: snapshot['name'], 
      blocks: [], 
      dbID: snapshot.id, 
      date: timestamp.toDate()
    );
  }

  @override
  Future<QuerySnapshot<Object?>> getQuerySnapshot() {
    return FirebaseFirestore.instance.collection("RecordedSessions")
    .where('owner_id', isEqualTo: userID)
    .orderBy('created', descending: true)
    .get();
  }
 
}