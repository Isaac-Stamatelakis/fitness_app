import 'package:fitness_app/main_scaffold.dart';
import 'package:flutter/material.dart';

abstract class DisplayListFragment<T> extends StatefulWidget {
  final List<T>? dataList;
  final List<Color> colors;
  const DisplayListFragment({super.key, required this.dataList, required this.colors});

}

abstract class DisplayListFragmentState<T> extends State<DisplayListFragment> {
  late List? displayedDataList = widget.dataList;
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: getTitle(),
      content: Stack(
        children: [
          buildExtraContent(),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: TextField(
                    onChanged: (value) {
                      updateDisplayedFields(value);
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
                      itemCount: widget.dataList?.length,
                      itemBuilder: (context, index) {
                        return _buildTile(context,displayedDataList?[index],onPress);
                      },
                    ),
                  ) 
                ) 
              ],
            ),
          ) 
        ],
      )
    );
  }

  void onPress(T data);
  void onLongPress(T data);
  void updateDisplayedFields(String searchText);
  Widget? buildText(T data);
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
              height: 100,
              alignment: Alignment.center,
              child: buildText(data),
            ),
          ),
        ),
      ],
    );
  }
  
}