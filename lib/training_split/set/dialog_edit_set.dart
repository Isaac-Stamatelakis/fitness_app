import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/training_split/set/set.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';


class CardioEditSetDialogue extends StatefulWidget {
  final CardioSet set;
  const CardioEditSetDialogue({super.key, required this.set});

  @override
  State<CardioEditSetDialogue> createState() => _CardioEditSetDialogueState();
}

class _CardioEditSetDialogueState extends State<CardioEditSetDialogue> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.set.duration.toString();
  }
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
                    "Edit Cardio Set",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back, 
                      color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  centerTitle: true,
                ),
                TextField(
                  controller: _controller,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Edit Duration",
                  ),
                  onChanged: (String search) {
                    int? intValue = int.tryParse(search);
                    if (intValue != null) {
                      widget.set.duration = intValue;
                    } else {
                      Logger().e("Cardio Set Edit Dialog: error string couldn't be parsed to int");
                    }
                  },
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}

class LiftingEditSetDialogue extends StatefulWidget {
  final LiftingSet set;
  const LiftingEditSetDialogue({super.key, required this.set});

  @override
  State<LiftingEditSetDialogue> createState() => _LiftingEditSetDialogueState();
}

class _LiftingEditSetDialogueState extends State<LiftingEditSetDialogue> {
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
                    "Edit Lifting Set",
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
                _LiftingSetTypeMenu(onSelect: _onTypeChanged, initalSelect: widget.set.type),
                _buildContent(widget.set.type)
              ],
            ),
          ],
        )
      )
    );
  }

  void _onTypeChanged(LiftingSetType? type) {
    setState(() {
      widget.set.type = type;
    });
  }

  Widget _buildContent(LiftingSetType? type) {
    LiftingSetType? type = widget.set.type;
    if (type == null) {
      return Container();
    } else if (
      type == LiftingSetType.Standard ||
      type == LiftingSetType.LengthenedPartialSet||
      type == LiftingSetType.IntegratedLengthenedPartialSet)
    {
      return _StandardSetEdit(set: widget.set);
    } else if (type == LiftingSetType.DropSet) {
      return _DropEditSet(set: widget.set);
    } 
    return Container();
  }
}

abstract class _SetEdit extends StatefulWidget {
  final LiftingSet set;
  const _SetEdit({required this.set});
}

abstract class _SetEditState extends State<_SetEdit> {
  String rangeValueToString(RangeValues rangeValues) {
    String returnString = "${rangeValues.start.floor().toString()}-${rangeValues.end.floor().toString()}";;
    if (returnString == "0-0") {
      return "0-1";
    } else {
      return returnString;
    }
  }
  RangeValues stringToRange(String? string) {
    if (string == null) {
      return getMinMaxRange();
    }
    List<String> splitStrings = string.split("-");
    if (splitStrings.length != 2) {
      return getMinMaxRange();
    }
    double? minValue = double.tryParse(splitStrings[0]);
    double? maxValue = double.tryParse(splitStrings[1]);
    if (minValue != null && maxValue != null) {
      return RangeValues(minValue, maxValue);
    }
    Logger().e("Lifting Set Edit Dialog: Error parsing ranges");
    return getMinMaxRange();
  }
  RangeValues getMinMaxRange();
}

class _StandardSetEdit extends _SetEdit {
  const _StandardSetEdit({required super.set});

  @override
  State<StatefulWidget> createState() => _StandardSetEditState();
}

class _StandardSetEditState extends _SetEditState {
  final TextEditingController _amountController = TextEditingController();
  late RangeValues _setRepValues;
  @override
  void initState() {
    super.initState();
    if (widget.set.data == {}) {
      widget.set.data = {
        'amount' :3,
        'rep_range' : '8-12'
      };
    }
    _setRepValues = stringToRange(widget.set.data['rep_range']);
    _amountController.text = widget.set.data['amount'].toString();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _amountController,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
          ],
          decoration: const InputDecoration(
            labelText: "Amount of Sets",
          ),
          onChanged: (String search) {
            int? intValue = int.tryParse(search);
            if (intValue != null) {
              widget.set.data['amount'] = intValue;
            } else {
              Logger().e("Lifting Set Edit Dialog: error string couldn't be parsed to int");
            }
          },
        ),
        const SizedBox(height: 20),
        Text(
          "Rep Range: ${rangeValueToString(_setRepValues)}",
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (index) => Text("${getMinMaxRange().start+ getMinMaxRange().end/10*index}")),
          ),
        ),
        SliderTheme(
          data: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: RangeSlider(
            values: _setRepValues, 
            min: 0,
            max: 30,
            onChanged: (RangeValues rangeValues) {
              setState(() {
                _setRepValues = rangeValues;
                widget.set.data['rep_range'] = rangeValueToString(rangeValues);
              });
            }
          )
        )
      ],
    );
  }
  
  @override
  RangeValues getMinMaxRange() {
    return const RangeValues(0, 30);
  }
}

class _DropEditSet extends _SetEdit {
  const _DropEditSet({required super.set});

  @override
  State<StatefulWidget> createState() => _DropEditSetState();
}

class _DropEditSetState extends _SetEditState {
  final TextEditingController _weightDropController = TextEditingController();
  late RangeValues _setRepValues;
  @override
  void initState() {
    super.initState();
    if (widget.set.data == {}) {
      widget.set.data = {
        'weight_drop' :3,
        'rep_range' : '3-6'
      };
    }
    _setRepValues = stringToRange(widget.set.data['rep_range']);
    _weightDropController.text = widget.set.data['amount'].toString();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _weightDropController,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
          ],
          decoration: const InputDecoration(
            labelText: "Weight Drop",
          ),
          onChanged: (String search) {
            int? intValue = int.tryParse(search);
            if (intValue != null) {
              widget.set.data['amount'] = intValue;
            } else {
              Logger().e("Lifting Set Edit Dialog: error string couldn't be parsed to int");
            }
          },
        ),
        const SizedBox(height: 20),
        Text(
          "Rep Range: ${rangeValueToString(_setRepValues)}",
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (index) => Text("${getMinMaxRange().start+ getMinMaxRange().end/10*index}")),
          ),
        ),
        SliderTheme(
          data: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: RangeSlider(
            values: _setRepValues, 
            min: 0,
            max: 10,
            onChanged: (RangeValues rangeValues) {
              setState(() {
                _setRepValues = rangeValues;
                widget.set.data['rep_range'] = rangeValueToString(rangeValues);
              });
            }
          )
        )
      ],
    );
  }
  @override
  RangeValues getMinMaxRange() {
    return const RangeValues(0, 10);
  }
}

class _LiftingSetTypeMenu extends AbstractDropDownSelector<LiftingSetType> {
  const _LiftingSetTypeMenu({required super.onSelect,required super.initalSelect}) : super(options: LiftingSetType.values);

  @override
  State<StatefulWidget> createState() => _LiftingSetTypeMenuState();

}

class _LiftingSetTypeMenuState extends AbstractDropDownSelectorState<LiftingSetType> {
  @override
  String optionToString(LiftingSetType option) {
    return SetFactory.liftingSetTypeToString(option);
  }

}