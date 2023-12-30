import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalConst {
  static String userID = "C86Yk50EFU6Gj1U69rEj";
  
}

class GlobalHelper {
  static Map<String, dynamic> docToJson(DocumentSnapshot snapshot) {
    return snapshot.data() as Map<String, dynamic>;
  }
}