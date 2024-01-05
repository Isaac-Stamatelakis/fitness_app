// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrackedSet {
  late TrackedSetType? type;
  late Map<String, dynamic> data;

  TrackedSet({required this.type, required this.data});
}

enum TrackedSetType {
  Cardio,
  Standard,
  IntegratedLengthenedPartialSet,
  DropSet,
  LengthenedPartialSet
}


class TrackingSetFactory {
  static Widget getModifyWidget(TrackedSet set) {
    switch (set.type) {
      case TrackedSetType.Cardio:
        return _CardioSetModify(set: set);
      case TrackedSetType.Standard:
        return _StandardSetModify(set: set);
      case TrackedSetType.IntegratedLengthenedPartialSet:
        return _StandardSetModify(set: set);
      case TrackedSetType.DropSet:
        return _DropSetSetModify(set: set);
      case TrackedSetType.LengthenedPartialSet:
        return _StandardSetModify(set: set);
      case null:
        return Container();
    }
  }

  static String getFormattedString(TrackedSet set) {
    switch (set.type) {
      case null:
        return "";
      case TrackedSetType.Cardio:
        if (set.data['duration'] == null || set.data['calories_burned'] == null) {
          if (set.data['target_duration'] == null) {
            return "Cardio";
          } else {
            return "${set.data['target_duration']} Minutes of Cardio";
          }
        }
        return "Cardio for ${set.data['duration']} Minutes, Burned ${set.data['calories_burned']} Calories";
      case TrackedSetType.Standard:
        if (set.data['reps'] == null || set.data['weight'] == null) {
          if (set.data['rep_range'] == null) {
            return "Standard Set";
          } else {
            return "${set.data['rep_range']} Reps";
          }
          
        }
        return "${set.data['weight']} lbs for ${set.data['reps']} Reps";
      case TrackedSetType.IntegratedLengthenedPartialSet:
        if (set.data['reps'] == null || set.data['weight'] == null) {
          if (set.data['rep_range'] == null) {
            return "Integrated Lengthened Partial Set";
          } else {
            return "${set.data['rep_range']} Reps Integrated Lengthened Partial Set";
          }
        }
        return "Integrated Lengthened Partial Set of ${set.data['weight']} lbs for ${set.data['reps']} Reps";
      case TrackedSetType.DropSet:
        if (set.data['reps'] == null || set.data['weight_drop'] == null || set.data['start_weight'] == null || set.data['end_weight'] == null) {
          return "DropSet";
        }
        return "DropSet starting at ${set.data['start_weight']} lbs, ending at ${set.data['end_weight']} lbs\n${set.data['reps']} Reps decreasing by ${set.data['weight_drop']} lbs";
      case TrackedSetType.LengthenedPartialSet:
        if (set.data['reps'] == null || set.data['weight'] == null) {
          if (set.data['rep_range'] == null) {
            return "Lengthened Partial Set Set";
          } else {
            return "${set.data['rep_range']} Reps Lengthened Partial Set Set";
          }
        }
        return "Lengthened Partial Set of ${set.data['weight']} lbs for ${set.data['reps']} Reps";
    }
  }
}


abstract class _SetModifier {
  Widget getTargetTile();
}

class _StandardSetModify extends StatefulWidget {
  final TrackedSet set;

  const _StandardSetModify({required this.set});
  @override
  State<StatefulWidget> createState() => _StandardSetModifyState();

}
class _StandardSetModifyState extends State<_StandardSetModify> implements _SetModifier{
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.set.data['reps'] != null) {
      _amountController.text = widget.set.data['reps'].toString();
    }
    if (widget.set.data['weight'] != null) {
      _weightController.text = widget.set.data['weight'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Reps',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['reps'] = double.parse(value);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Weight',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['weight'] = double.parse(value);
          },
        ),
      ],
    );
  }
  @override
  Widget getTargetTile() {
    if (widget.set.data['rep_range'] == null) {
      return Container();
    }
    return ListTile(
      title: Text(
        widget.set.data['rep_range'].toString(),
        style: const TextStyle(
          color: Colors.white
        ),
      ) 
    );
  }
}

class _CardioSetModify extends StatefulWidget {
  final TrackedSet set;

  const _CardioSetModify({required this.set});
  @override
  State<StatefulWidget> createState() => _CardioSetModifyState();

}
class _CardioSetModifyState extends State<_CardioSetModify> implements _SetModifier{
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.set.data['duration'] != null) {
      _amountController.text = widget.set.data['duration'].toString();
    }
    if (widget.set.data['calories_burned'] != null) {
      _weightController.text = widget.set.data['calories_burned'].toString();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getTargetTile(),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Duration',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['duration'] = double.parse(value);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Calories Burned',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['calories_burned'] = double.parse(value);
          },
        ),
      ],
    );
  }

  @override
  Widget getTargetTile() {
    if (widget.set.data['target_duration'] == null) {
      return Container();
    }
    return ListTile(
      title: Text(
        "Target Duration ${widget.set.data['target_duration'].toString()}",
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.white
        ),
      ) 
    );
  }
}

class _DropSetSetModify extends StatefulWidget {
  final TrackedSet set;

  const _DropSetSetModify({required this.set});
  @override
  State<StatefulWidget> createState() => _DropSetModifyState();

}
class _DropSetModifyState extends State<_DropSetSetModify> implements _SetModifier{
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _startWeightController = TextEditingController();
  final TextEditingController _endWeightController = TextEditingController();
  final TextEditingController _weightDropController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.set.data['reps'] != null) {
      _amountController.text = widget.set.data['reps'].toString();
    }
    if (widget.set.data['start_weight'] != null) {
      _startWeightController.text = widget.set.data['start_weight'].toString();
    }
    if (widget.set.data['end_weight'] != null) {
      _endWeightController.text = widget.set.data['end_weight'].toString();
    }
    if (widget.set.data['weight_drop'] != null) {
      _weightDropController.text = widget.set.data['weight_drop'].toString();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getTargetTile(),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Reps',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['reps'] = double.parse(value);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _weightDropController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Weight Drop',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['weight_drop'] = double.parse(value);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _startWeightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Start Weight',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['start_weight'] = double.parse(value);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _endWeightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d+\.?\d{0,2}$'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'End Weight',
            labelStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          onChanged: (value) {
            widget.set.data['end_weight'] = double.parse(value);
          },
        ),
      ],
    );
  }

  @override
  Widget getTargetTile() {
    return Container();
  }
}
