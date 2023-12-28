import 'dart:js_interop';

import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:fitness_app/homepage.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/movement_patterns/exercise.dart';
import 'package:fitness_app/movement_patterns/movement_page.dart';
import 'package:fitness_app/movement_patterns/movement_pattern.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white
            ),
            bodySmall: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white
            )
          )
      ),
      home: const MainScaffold(title: "Overload Training", content: HomePage(userID: "C86Yk50EFU6Gj1U69rEj"))
    );
  }
}
