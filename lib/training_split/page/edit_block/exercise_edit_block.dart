import 'package:fitness_app/exercise_core/exercise/exercise.dart';
import 'package:fitness_app/exercise_core/exercise/exercise_db.dart';
import 'package:fitness_app/exercise_core/exercise/variation/exercise_variation.dart';
import 'package:fitness_app/exercise_core/movement_pattern/movement_pattern.dart';
import 'package:fitness_app/misc/global_widgets.dart';
import 'package:fitness_app/misc/page_loader.dart';
import 'package:fitness_app/training_split/training_split.dart';
import 'package:flutter/material.dart';

/// As movement pattern is fixed, only exercise selection is required
class CardioEditBlockExercise extends StatelessWidget {
  final IBlock? block;
  final Function(MovementPattern?) onMovementSelected;
  const CardioEditBlockExercise({super.key, this.block, required this.onMovementSelected});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ExerciseAndVariationContainerLoader(block: block)
      ],
    );
  }
}

/// Loads all drop down menus for lifting exercise selection
class LiftingEditBlockExercise extends StatelessWidget {
  final IBlock? block;
  final Function(MovementPattern?) onMovementSelected;
  const LiftingEditBlockExercise({super.key, required this.block, required this.onMovementSelected});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MovementPatternDropButton(
            list: MovementPatternFactory.getNoneNullPatterns(), 
            width: double.infinity, 
            label: 'Search Movements', 
            onSelect: onMovementSelected, 
            initialValue: block!.movementPattern
          ),
        const SizedBox(height: 20),
        _ExerciseAndVariationContainerLoader(block: block,)
      ],
    );
  }
}

/// Loads exercise and variation drop down menus
class _ExerciseAndVariationContainerLoader extends WidgetLoader {
  final IBlock? block;
  const _ExerciseAndVariationContainerLoader({required this.block});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    List<IExercise?> exercises = [null];
    exercises.addAll(snapshot.data);
    return _ExerciseAndVariationContainer(block: block, exercises: exercises);
  }

  @override
  Future getFuture() {
    return EntirePatternExerciseQuery(pattern: block!.movementPattern).retrieve();
  }

}

class _ExerciseAndVariationContainer extends StatefulWidget {
  final IBlock? block;
  final List<IExercise?> exercises;
  const _ExerciseAndVariationContainer({required this.block, required this.exercises});

  @override
  State<StatefulWidget> createState() => _ExerciseAndVariationContainerState();

}

class _ExerciseAndVariationContainerState extends State<_ExerciseAndVariationContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ExerciseDropButton(
          list: widget.exercises, 
          width: 300, 
          label: "Search Exercises", 
          onSelect: _onExerciseSelected, 
          initialValue: widget.block!.exercise
        ),
        const SizedBox(height: 20),
        _ExerciseVariationDropButtonLoader(
          block: widget.block!,
          onSelect: _onVariationSelected
        ),
      ],
    );
  }

  void _onExerciseSelected(IExercise? exercise) {
    setState(() {
      widget.block!.exercise = exercise;
      widget.block!.variation = null;
    });
  }

  void _onVariationSelected(ExerciseVariation? variation) {
    widget.block!.variation = variation;
  }
}



class MovementPatternDropButton extends ASearchDropDownButton<MovementPattern> {
  const MovementPatternDropButton({super.key, required super.list, required super.width, required super.label, required super.onSelect, required super.initialValue});
  @override
  State<StatefulWidget> createState() => _DropButtonState();

}

class _DropButtonState extends ASearchDropDownButtonState<MovementPattern> {
  @override
  String elementToString(MovementPattern? movementPattern) {
    return MovementPatternFactory.patternToString(movementPattern);
  }
  
  @override
  int getInitalIndex() {
    if (widget.list!.contains(widget.initialValue)) {
      return widget.list!.indexOf(widget.initialValue);
    }
    if (widget.list!.isNotEmpty) {
      return 0;
    }
    return -1;
  }
}

class _ExerciseDropButton extends ASearchDropDownButton<IExercise> {
  const _ExerciseDropButton({required super.list, required super.width, required super.label, required super.onSelect, required super.initialValue});
  @override
  State<StatefulWidget> createState() => _ExerciseDropButtonState();
}

class _ExerciseDropButtonState extends ASearchDropDownButtonState<IExercise> {
  @override
  String elementToString(IExercise? element) {
    if (element == null) {
      return "None";
    }
    return element.exerciseName;
  }
  
  @override
  int getInitalIndex() {
    int index = 0;
    for (IExercise? exercise in widget.list!) {
      if (exercise != null && widget.initialValue != null && exercise.exerciseName == widget.initialValue!.exerciseName) {
        return index;
      }
      index += 1;
    }
    return 0;
  }
}

class _ExerciseVariationDropButtonLoader extends WidgetLoader {
  final IBlock? block;
  final Function(ExerciseVariation?) onSelect;
  const _ExerciseVariationDropButtonLoader({required this.onSelect, required this.block});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    List<ExerciseVariation?> variations = [null];
    variations.addAll(snapshot.data);
    return _ExerciseVariationDropButton(list: variations, width: 300, label: "Search Variations", onSelect: onSelect, initialValue: block!.variation,);
  }

  @override
  Future getFuture() {
    if (block!.exercise == null) {
      return ExerciseVariationQuery(exerciseID: "").retrieve();
    } else {
      return ExerciseVariationQuery(exerciseID: block!.exercise!.dbID).retrieve();
    }
    
  }

}

class _ExerciseVariationDropButton extends ASearchDropDownButton<ExerciseVariation> {
  const _ExerciseVariationDropButton({required super.list, required super.width, required super.label, required super.onSelect, required super.initialValue});
  @override
  State<StatefulWidget> createState() => _ExerciseVariationDropButtonState();
}

class _ExerciseVariationDropButtonState extends ASearchDropDownButtonState<ExerciseVariation> {
  @override
  String elementToString(ExerciseVariation? element) {
    if (element != null) {
      return element.variationName;
    } 
    return "None";
  }
  @override
  int getInitalIndex() {
    if (widget.initialValue == null) {
      return 0;
    }
    int index = 0;
    for (ExerciseVariation? variation in widget.list!) {
      if (variation != null && variation.variationName == widget.initialValue!.variationName) {
        return index;
      }
      index += 1;
    }
    return 0;
  }
}