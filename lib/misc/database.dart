import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

abstract class DatabaseHelper<T> {
  Future<T?> fromDatabase() async {
    try {
      DocumentSnapshot documentSnapshot = await getDatabaseReference().get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return fromDocument(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  T? fromDocument(DocumentSnapshot snapshot);

  dynamic getDatabaseReference();
}


abstract class MultiDatabaseRetriever<T> {
  Future<List<T>> retrieve() async {
    try {
      QuerySnapshot querySnapshot = await getQuerySnapshot();
      List<T> items = [];
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        items.add(fromDocument(documentSnapshot));
      }
      return items;
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return [];
    }
  }
  T fromDocument(DocumentSnapshot snapshot);

  Future<QuerySnapshot> getQuerySnapshot();
}

abstract class DatabaseQuery {
  Future<List<dynamic>?> fromDatabase() async {
    try {
      List<dynamic> queryResults = [];
      QuerySnapshot querySnapshot = await getQuery().get();
      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        queryResults.add(fromDocument(snapshot));
      }
      return queryResults;
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  dynamic fromDocument(DocumentSnapshot snapshot);

  dynamic getQuery();
}

