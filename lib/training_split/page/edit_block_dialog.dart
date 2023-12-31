import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

class EditBlockDialog extends StatelessWidget {
  final IBlock? block;
  final Function(IBlock?) moveUp;
  final Function(IBlock?) moveDown;
  const EditBlockDialog({super.key, required this.block, required this.moveUp, required this.moveDown});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Edit Block",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back, 
                  color: Colors.white
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            const SizedBox(height: 20),
            MovementPatternDropButton(list: MovementPatternFactory.getNoneNullPatterns(), width: double.infinity),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SquareGradientButtonSizeable(
                  onPress: _onSavePress, 
                  text: "Update", 
                  colors: [Colors.blue,Colors.blue.shade300], 
                  size: const Size(100,50)
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){moveUp(block);}, 
                      icon: const Icon(
                        Icons.arrow_circle_up,
                        color: Colors.white,
                        size: 50,
                      )
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: (){moveDown(block);}, 
                      icon: const Icon(
                        Icons.arrow_circle_down,
                        color: Colors.white,
                        size: 50,
                      )
                    ),
                  ],
                ),
              ],
            )
          ],
        )
      )
    );
    
  }
  void _onSavePress(BuildContext context) {

  }
}

class MovementPatternDropButton extends ASearchDropDownButton<MovementPattern> {
  const MovementPatternDropButton({super.key, required super.list, required super.width});

  @override
  State<StatefulWidget> createState() => _DropButtonState();

}

class _DropButtonState extends ASearchDropDownButtonState<MovementPattern> {
  @override
  String elementToString(MovementPattern movementPattern) {
    return MovementPatternFactory.movementPatternToString(movementPattern);
  }
  
 

}