import 'package:fitness_app/misc/global_widgets.dart';
import 'package:flutter/material.dart';

class NewTrainingSplitDialog extends StatelessWidget {
  const NewTrainingSplitDialog({super.key, required this.displayText, required this.onConfirmCallback});
  final Function(BuildContext) onConfirmCallback;
  final String displayText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayText,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.blue,Colors.blue.shade400],text: "Confirm",onPress: _onConfirm),
                  const SizedBox(width: 20),
                  SquareGradientButtonSizeable(size: const Size(100,50), colors: [Colors.red,Colors.red.shade400],text: "Cancel",onPress: _popBack),
                ],
              )
            ) 
          ],
        ),
        
      )
    );
  }
  void _onConfirm(BuildContext context) {
    onConfirmCallback(context);
    _popBack(context);
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}