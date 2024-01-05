import 'package:fitness_app/misc/display_list.dart';
import 'package:fitness_app/user/user.dart';
import 'package:flutter/material.dart';

abstract class AbstractOrderedTileList<T> extends StatefulWidget {
  final List<T?>? list;
  final User user;
  const AbstractOrderedTileList({super.key, required this.list, required this.user});
}

abstract class AbstractOrderedTileListState<T> extends State<AbstractOrderedTileList<T>>{
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: ListView.builder(
          itemCount: widget.list?.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return buildFirstTile(context,widget.list?[index]);
            } else {
              return buildLaterTile(context,widget.list?[index]);
            }
          },
        ),
      ) 
    );
  }
  Widget? buildFirstTile(BuildContext context, T? element);
  Widget? buildLaterTile(BuildContext context, T? element);
  Widget? buildTile(T? element);
  void onLongPress(T? element);
  void onPress(T? element);
}