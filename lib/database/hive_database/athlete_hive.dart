import 'package:hive_flutter/hive_flutter.dart';
import 'package:runmaze2/model/athlete.dart';


class AthleteHive {
  //late Box<TodoItem> _todoBox;
  Box<Athlete> _athleteBox = Hive.box<Athlete>('athletes');

  Future<void> openBox() async {
    _athleteBox = await Hive.openBox<Athlete>('athletes');
  }

  void addAthlete(Athlete athlete) {
    _athleteBox.add(athlete);
  }

  void updateAthlete(Athlete oldAthlete, Athlete newAthlete) {
    final int index = _athleteBox.values.toList().indexOf(oldAthlete);
    if (index != -1) {
      _athleteBox.putAt(index, newAthlete);
    }
  }

  void updateAthleteByKey(int key, Athlete athlete) {
    if (_athleteBox.containsKey(key)) {
      _athleteBox.put(key, athlete);
    }
  }

  void deleteAthlete(Athlete athlete) {
    final int index = _athleteBox.values.toList().indexOf(athlete);
    if (index != -1) {
      _athleteBox.deleteAt(index);
    }
  }

  bool deleteAthleteByKey(int key) {
    final Athlete? athlete = _athleteBox.get(key);
    if (athlete != null ) {
      try {
        _athleteBox.delete(key);
      } catch (e) {
        print("Error in deleting record: $e");
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  List<Athlete> getAllAthletes() {
    return _athleteBox.values.toList();
  }

  // List<Athlete> getActiveTodoItems() {
  //   return _athleteBox.values
  //       // .where((todoItem) => todoItem.isDeleted == true )
  //       // .where((todoItem) =>
  //       //     todoItem.isDeleted == false || todoItem.isDeleted == null)

  //       .where((todoItem) =>
  //           todoItem.isDone == false &&
  //           (todoItem.isDeleted == false || todoItem.isDeleted == null))
  //       .toList();
  // }

  // List<Athlete> getDeletedTodoItems() {
  //   return _athleteBox.values
  //       .where((todoItem) => todoItem.isDeleted == true)
  //       .toList();
  // }

  // List<Athlete> getCompletedTodoItems() {
  //   return _athleteBox.values
  //       .where((todoItem) => todoItem.isDone == true)
  //       .toList();
  // }

  Athlete? getAthleteByKey(int key) {
    return _athleteBox.get(key);
  }

  Athlete? getAthleteAt(int index) {
    return _athleteBox.getAt(index);
  }

  Future<void> close() async {
    await _athleteBox.close();
  }

  // List<Athlete> getTodoItemsByTextContain(String text) {
  //   var filteredItems = _athleteBox.values
  //       .where((todoItem) =>
  //           todoItem.toBeDone.contains(text) &&
  //           (todoItem.isDeleted == false || todoItem.isDeleted == null))
  //       .toList();
  //   return filteredItems;
  // }
}
