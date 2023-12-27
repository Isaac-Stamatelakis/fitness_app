import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userID;
  const HomePage({super.key, required this.userID});
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HomePage> {
  late DateTime selectedDay = DateTime.now();
  late DateTime firstDayOfMonth = DateTime(selectedDay.year, selectedDay.month, 1);
  late DateTime lastDayOfMonth = DateTime(selectedDay.year, selectedDay.month+1, 0);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,      
        children: [
          _SquareGradientButton(_toSession, text: "Start Session", colors: [Colors.red,Colors.red.shade200], size: const Size(300,100)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               _SquareGradientButton(_toTrainingSplit, text: "Edit Training Split", colors: [Colors.blue,Colors.blue.shade200], size: const Size(200,100)),
               const SizedBox(width: 20),
               _SquareGradientButton(_toProgress, text: "View Progress", colors: [Colors.blue,Colors.blue.shade200], size: const Size(200,100))
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SizedBox(
              width: 500,
              child: _SessionList()
            ),
          ),
        ],
      )
    );
  }


  void _toSession() {

  }

  void _toTrainingSplit() {

  }

  void _toProgress() {
    
  }

}



class _SessionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7, // Number of days in a week
      itemBuilder: (context, index) {
        return Column(
          children: [
            Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                  colors: [Colors.green,Colors.green.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                height: 100,
                width: 400,
                alignment: Alignment.center,
                child: const Text(
                  "Hello",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              )
            ),
            const SizedBox(
              height: 10
            )
          ],
        );
      }
    );
  }

}

class _SquareGradientButton extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final List<Color> colors;
  final Size size;

  const _SquareGradientButton(this.onPress,{required this.text, required this.colors, required this.size});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
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

 
