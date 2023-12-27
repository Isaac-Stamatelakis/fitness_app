import 'package:fitness_app/homepage.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/movement_patterns/movement_page.dart';
import 'package:fitness_app/movement_patterns/movement_pattern.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your1    application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MainScaffold(content: HomePage(userID: "C86Yk50EFU6Gj1U69rEj"))
    );
  }
}
