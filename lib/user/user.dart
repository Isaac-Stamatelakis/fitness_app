import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/misc/database.dart';
import 'package:fitness_app/misc/global.dart';

class User {
  late String? name;
  late String? currentSessionID;
  late String? trainingSplitID;
  late String? dbID;
  late DateTime lastSession;
  late Map<String, dynamic>? splitTimer;
  User({required this.name, required this.currentSessionID, required this.trainingSplitID, required this.dbID, required this.splitTimer, required this.lastSession});

  /// Returns current session non mod
  int getCurrentSession() {
    if (splitTimer!['date'] is Timestamp) {
      Timestamp timestamp =splitTimer!['date'];
      splitTimer!['date'] = timestamp.toDate();
    }
     
    Duration difference = DateTime.now().difference(splitTimer!['date']);
    int dayDifference = difference.inDays;
    int session = splitTimer!['session'];
    return dayDifference+session;
  }

  /// Returns true if a session has been created today, false otherwise
  bool createdSessionToday() {
    Duration difference = DateTime.now().difference(lastSession);
    int dayDifference = difference.inDays;
    return dayDifference == 0;
  }
}

class UserFactory {
  static User fromDocument(DocumentSnapshot snapshot) {
    var json = GlobalHelper.docToJson(snapshot);
    Timestamp lastSession = json['last_session'];
    return User(
      name: json['name'], 
      currentSessionID: json['current_session_id'], 
      trainingSplitID: json['training_split_id'],
      dbID: snapshot.id,
      splitTimer: json['split_timer'],
      lastSession: lastSession.toDate()
    );
  }
}

class UserRetriever extends DatabaseHelper<User> {
  final String userID;
  UserRetriever({required this.userID});
  @override
  User fromDocument(DocumentSnapshot<Object?> snapshot) {
    return UserFactory.fromDocument(snapshot);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Users").doc(userID);
  }

}