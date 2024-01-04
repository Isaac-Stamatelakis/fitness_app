import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_page.dart';
import 'package:fitness_app/main_scaffold.dart';
import 'package:fitness_app/misc/global.dart';
import 'package:flutter/material.dart';

abstract class PageLoader extends StatelessWidget {
  const PageLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: getFuture(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MainScaffold(
                content: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/2,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                title: getTitle()
              );
            } else if (snapshot.hasError) {
              return MainScaffold(
                content: Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                  )
                ),
                title: getTitle()
              );
            } else { 
              return generateContent(snapshot);
            }
          }
      );
  }
  Widget generateContent(AsyncSnapshot<dynamic> snapshot);
  Future getFuture();
  String getTitle();
}

abstract class WidgetLoader extends StatelessWidget {
  const WidgetLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFuture(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
              
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else { 
            return generateContent(snapshot);
          }
        }
    );
  }
  Widget generateContent(AsyncSnapshot<dynamic> snapshot);
  Future getFuture();
}

abstract class SizedWidgetLoader extends StatelessWidget {
  final Size size;
  const SizedWidgetLoader({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFuture(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: const CircularProgressIndicator()
              )
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else { 
            return generateContent(snapshot);
          }
        }
    );
  }
  Widget generateContent(AsyncSnapshot<dynamic> snapshot);
  Future getFuture();
}