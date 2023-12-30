import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/misc/database.dart';
import 'package:fitness_app/misc/global.dart';

class User {
  final String? name;
  final String? currentSessionID;
  final String? trainingSplitID;
  final String? dbID;
  User({required this.name, required this.currentSessionID, required this.trainingSplitID, required this.dbID});
}

class UserFactory {
  static User fromDocument(DocumentSnapshot snapshot) {
    var json = GlobalHelper.docToJson(snapshot);
    return User(
      name: json['name'], 
      currentSessionID: json['current_session_id'], 
      trainingSplitID: json['training_split_id'],
      dbID: snapshot.id
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