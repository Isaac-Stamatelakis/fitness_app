import 'package:fitness_app/main_scaffold.dart';
import 'package:flutter/material.dart';

abstract class DisplayListFragment<T> extends StatefulWidget {
  final List<T> dataList;
  final List<Color> colors;
  const DisplayListFragment({super.key, required this.dataList, required this.colors});

}

abstract class DisplayListFragmentState<T> extends State<DisplayListFragment> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      content: Stack(
        children: [
          ListView.builder(
            itemCount: widget.dataList.length,
            itemBuilder: (context, index) {
              return _buildTile(context,widget.dataList[index],onPress);
            },
          ),
          buildExtraContent()
        ],
      ),
    );
  }

  void onPress(T data);

  Widget? buildText(T data);
  Widget buildExtraContent();

  Widget? _buildTile(BuildContext context, dynamic data, Function(T) onPress) {
    return ElevatedButton(
      onPressed: () {
        onPress(data);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: widget.colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          height: 100,
          alignment: Alignment.center,
          child: buildText(data),
        ),
      ),
    );
  }
  
}