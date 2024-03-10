import 'package:hive_flutter/hive_flutter.dart';
import 'package:runmaze2/model/workout.dart';

class WorkoutHive {
  final String _boxName = 'workouts';

  Box<Workout> _workoutBox = Hive.box<Workout>('workouts');

  Future<void> _prepareBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _workoutBox = await Hive.openBox<Workout>(_boxName);
    } else {
      _workoutBox = Hive.box(_boxName);
    }
  }

  Future<void> addWorkout(Workout workout) async {
    await _prepareBox();
    _workoutBox.add(workout);
  }

  Future<void> addWorkouts(List<Workout> workouts) async {
    await _prepareBox();
    _workoutBox.addAll(workouts);
  }

  Future<void> updateWorkout(Workout oldWorkout, Workout newWorkout) async {
    await _prepareBox();
    final int index = _workoutBox.values.toList().indexOf(oldWorkout);
    if (index != -1) {
      _workoutBox.putAt(index, newWorkout);
    }
  }

  Future<void> updateWorkoutByKey(int key, Workout workout) async {
    await _prepareBox();
    if (_workoutBox.containsKey(key)) {
      _workoutBox.put(key, workout);
    }
  }

  Future<void> deleteWorkout(Workout workout) async {
    await _prepareBox();
    final int index = _workoutBox.values.toList().indexOf(workout);
    if (index != -1) {
      _workoutBox.deleteAt(index);
    }
  }

  Future<bool> deleteWorkoutByKey(int key) async {
    await _prepareBox();
    final Workout? workout = _workoutBox.get(key);
    if (workout != null) {
      try {
        _workoutBox.delete(key);
      } catch (e) {
        print("Error in deleting record: $e");
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  Future<List<Workout>> getAllWorkouts() async {
    await _prepareBox();
    return _workoutBox.values.toList();
  }

  Future<Workout?> getWorkoutByKey(int key) async {
    await _prepareBox();
    return _workoutBox.get(key);
  }

  Future<Workout?> getWorkoutAt(int index) async {
    await _prepareBox();
    return _workoutBox.getAt(index);
  }

  Future<void> close() async {
    await _prepareBox();
    await _workoutBox.close();
  }
}
