import 'package:fitness_app/main_scaffold.dart';
import 'package:flutter/material.dart';

abstract class DisplayListFragment<T> extends StatefulWidget {
  final List<T>? dataList;
  final List<Color> colors;
  const DisplayListFragment({super.key, required this.dataList, required this.colors});

}

abstract class DisplayListFragmentState<T> extends State<DisplayListFragment> {
  late List? displayedDataList = widget.dataList;
  late String searchValue = "";
  late List<T> valueList = [];
  @override
  void initState() {
    super.initState();
    buildLists("");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildExtraContent(),
        Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: TextField(
                  onChanged: (search) {
                    setState(() {
                      buildLists(search.toLowerCase());
                    });
                  },
                  style: const TextStyle(
                    color: Colors.white
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(
                      color: Colors.grey
                    )
                  ),
                )
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: ListView.builder(
                    itemCount: valueList.length,
                    itemBuilder: (context, index) {
                      return _buildTile(context,valueList[index],onPress);
                    },
                  ),
                ) 
              ) 
            ],
          ),
        ) 
      ],
    );
  }

  void buildLists(String search) {
    List<T> newValueList = [];
    for (T value in widget.dataList!) {
      String stringValue = getString(value);
      if (stringValue.toLowerCase().contains(search)) {
          newValueList.add(value);
      }
    }
    valueList = newValueList;
  }
  void onPress(T data);
  void onLongPress(T data);
  String getString(T data);
  Widget buildExtraContent();
  String getTitle();
  
  Widget? _buildTile(BuildContext context, dynamic data, Function(T) onPress) {
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
              height: 75,
              alignment: Alignment.center,
              child: Text(
                getString(data),
                style: const TextStyle(
                  color: Colors.white
                ),
              )
            ),
          ),
        ),
      ],
    );
  }
  
}