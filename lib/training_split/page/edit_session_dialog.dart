import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

class EditSessionDialog extends StatelessWidget {
  final ISession? session;
  final Function(ISession?) addBlock;
  final Function(ISession?) moveLeft;
  final Function(ISession?) moveRight;
  final TextEditingController _titleTextController = TextEditingController();

  EditSessionDialog({super.key, required this.session, required this.addBlock, required this.moveLeft, required this.moveRight});
  @override
  Widget build(BuildContext context) {
    _titleTextController.text = session!.name;
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
                "Edit Session",
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
            TextField(
              controller: _titleTextController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Colors.grey
                ),
              ),
              onChanged: (value) {
                session!.name = value;
              },
            ),
            const SizedBox(height: 20),
            SquareGradientButtonSizeable(
              onPress: _addBlock, 
              text: "Add Exercise Block", 
              colors: [Colors.blue,Colors.blue.shade300], 
              size: const Size(150,80)
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: (){moveLeft(session);}, 
                  icon: const Icon(
                    Icons.arrow_circle_left,
                    color: Colors.white,
                    size: 50,
                  )
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: (){moveRight(session);}, 
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.white,
                    size: 50,
                  )
                ),
              ],
            )
          ],
        )
      )
    );
  }
  void _addBlock(BuildContext context) {
    addBlock(session);
  }

}