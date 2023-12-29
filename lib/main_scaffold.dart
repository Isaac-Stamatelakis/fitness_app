import 'dart:math';

import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_page.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_page.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget content;
  const MainScaffold({super.key, required this.content, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            
          )
        ),
        centerTitle: true,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(onPressed: (){
              Scaffold.of(context).openDrawer();
            }, 
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            );
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.home, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context): null;
              },
            ),
            
        ],
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,  
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black,Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
          _LightPatchCollection(),
          content,
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child:  Column(
            children: [
              _SquareGradientButton(
                _navigateMovementPatterns, 
                text: "Movement Patterns", 
                colors: const [Colors.black,Colors.white]
              ),
              const SizedBox(height: 20),
              _SquareGradientButton(
                _navigateExercises, 
                text: "Exercises", 
                colors: const [Colors.black,Colors.white]
              ),
              const SizedBox(height: 20),
              _SquareGradientButton(
                _navigateExerciseVariations, 
                text: "Exercise Variations", 
                colors: const [Colors.black,Colors.white]
              ),
            ],
          )
        )
      ),
    );
  }

  void _navigateMovementPatterns(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MovementPatternPage(
          dataList: MovementPattern.values, colors: [Colors.black,Colors.black87]
        )
      )
    );
  }

  void _navigateExercises(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExercisePageLoader(
          colors: [Colors.black,Colors.black]
        )
      )
    );
  }

  void _navigateExerciseVariations(BuildContext context) {
    Scaffold.of(context).closeDrawer();
  }
}

class _SquareGradientButton extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;

  const _SquareGradientButton(this.onPress,{required this.text, required this.colors});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {onPress(context);},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class _LightPatch extends StatelessWidget {
  final Size size;
  const _LightPatch({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.5, // Adjust the radius as needed
          colors: [
            Colors.blueGrey.withOpacity(0.3), // Inner color (fully opaque)
            Colors.blueGrey.withOpacity(0.0), // Outer color (fully transparent)
          ],
        ),
      ),
    );
  }
}

class _LightPatchCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int seperation = 300;
    Size screenSize = MediaQuery.of(context).size;
    int rows = (screenSize.width/seperation).floor()+1;
    int columns = (screenSize.height/seperation).floor()+1;
    double rowOffset = (screenSize.width-rows*seperation);
    double colOffset = (screenSize.height-columns*seperation);
    return Stack(
      children: List.generate(
          rows*columns,
          (index) => Positioned(
            top: (index/rows).floor() * seperation + colOffset+100+randomInRange(0, 300),
            left: (index % rows) * seperation + rowOffset+randomInRange(0, 100),
            child: const _LightPatch(size: Size(200,200)),
          ),
        ),
    );
  }
  int randomInRange(int min, int max) => min + Random().nextInt(max - min);
}