import 'package:flutter/material.dart';

class SquareGradientButton extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final double height;

  const SquareGradientButton({super.key, required this.onPress, required this.text, required this.colors, required this.height});
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
          height: height,
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

class SquareGradientButtonSizeable extends StatelessWidget {
  final Function(BuildContext) onPress;
  final String text;
  final List<Color> colors;
  final Size size;

  const SquareGradientButtonSizeable({super.key, required this.onPress, required this.text, required this.colors, required this.size});
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
          height: size.height,
          width: size.width,
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
class SingleButtonDialog extends StatelessWidget {
  final String displayText;
  final String buttonText;
  final List<Color> buttonColors;
  final List<Color> dialogColors;

  const SingleButtonDialog({super.key, required this.displayText, required this.buttonText, required this.buttonColors, required this.dialogColors});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: dialogColors,
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
            const SizedBox(height: 20),
            SquareGradientButton(
              height: 50,
              colors: buttonColors,
              text: buttonText,
              onPress: _popBack
            )
          ],
        ),
        
      )
    );
  }
  void _popBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.displayText, required this.onConfirmCallback});
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