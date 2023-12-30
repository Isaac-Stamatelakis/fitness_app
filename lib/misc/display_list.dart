import 'package:flutter/material.dart';

abstract class AbstractList<T> extends StatefulWidget {
  final List<T>? dataList;
  final List<Color> colors;
  const AbstractList({super.key, required this.dataList, required this.colors});
}

abstract class AbstractListState<T> extends State<AbstractList<T>> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: ListView.builder(
          itemCount: widget.dataList?.length,
          itemBuilder: (context, index) {
            return _buildTile(context,widget.dataList?[index]);
          },
        ),
      ) 
    );
  }

  Widget? _buildTile(BuildContext context, T? data) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            onPress(data);
          },
          onLongPress: () {
            onLongPress(data);
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
              child: getContainerWidget(data)
            ),
          ),
        ),
      ],
    );
  }

  Widget? getContainerWidget(T? data);

  void onPress(T? data);

  void onLongPress(T? data);
}