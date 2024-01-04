import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalConst {
  static String userID = "C86Yk50EFU6Gj1U69rEj";
  
}

class GlobalHelper {
  static Map<String, dynamic> docToJson(DocumentSnapshot snapshot) {
    return snapshot.data() as Map<String, dynamic>;
  }

  static double getPreferredDialogWidth(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width/2 > 500) {
      return screenSize.width/2;
    } else {
      return screenSize.width-25;
    }
  }
}