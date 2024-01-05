import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/record_session/recorded_training_session.dart';
import 'package:fitness_app/record_session/tracking_set.dart';
import 'package:flutter/material.dart';

class EditTrackingSetDialog extends StatefulWidget {
  final TrackedBlock? block;
  final TrackedSet? set;
  final int index;
  final Function(int?) moveUp;
  final Function(int?) moveDown;

  const EditTrackingSetDialog({super.key, required this.block, required this.set, required this.moveUp, required this.moveDown, required this.index});

  @override
  State<StatefulWidget> createState() => _EditTrackingSetDialogState();

}
class _EditTrackingSetDialogState extends State<EditTrackingSetDialog> {
  late _EditOption selectedOption = _EditOption.Record;
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
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.black,
                  title: const Text(
                    "Edit Tracking Set",
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
                _OptionSelectorDropDown(onSelect: _onOptionSelected),
                const SizedBox(height: 20),
                _getContent()
              ],
            ),
            
          ],
        )
      )
    );
  }

  void _onOptionSelected(_EditOption? option) {
    if (option == selectedOption) {
      return;
    }
    setState(() {
      selectedOption = option!;
    });
  }

  Widget _getContent() {
    switch (selectedOption) {
      case _EditOption.Record:
        return TrackingSetFactory.getModifyWidget(widget.set!);
      case _EditOption.Modify:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: (){widget.moveUp(widget.index);}, 
                  icon: const Icon(
                    Icons.arrow_circle_up,
                    color: Colors.white,
                    size: 50,
                  )
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: (){widget.moveDown(widget.index);}, 
                  icon: const Icon(
                    Icons.arrow_circle_down,
                    color: Colors.white,
                    size: 50,
                  )
                ),
              ],
            ),
            _SetTypeDropDown(initalSelect: widget.set!.type, onSelect: _onTypeChanged)
        ],
      );
    }
  }

  void _onTypeChanged(TrackedSetType? type) {
    if (widget.set!.type == type!) {
      return;
    }
    setState(() {
      widget.set!.type = type;
    });
  }
}

enum _EditOption {
  Record,
  Modify
}

class _OptionSelectorDropDown extends AbstractDropDownSelector<_EditOption> {
  const _OptionSelectorDropDown({required super.onSelect}) : super(options: _EditOption.values, initalSelect: _EditOption.Record);

  @override
  State<StatefulWidget> createState() => _OptionSelectorDropDownState();

}

class _OptionSelectorDropDownState extends AbstractDropDownSelectorState<_EditOption> {
  @override
  String optionToString(_EditOption option) {
    return option.toString().split(".")[1];
  }
}

class _SetTypeDropDown extends AbstractDropDownSelector<TrackedSetType> {
  const _SetTypeDropDown({required super.onSelect, required super.initalSelect}) : super(options: TrackedSetType.values);
  @override
  State<StatefulWidget> createState() => _SetTypeDropDownState();
}

class _SetTypeDropDownState extends AbstractDropDownSelectorState<TrackedSetType> {
  @override
  String optionToString(TrackedSetType option) {
    return option.toString().split(".")[1];
  }
}