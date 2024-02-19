import 'package:hive_flutter/hive_flutter.dart';
import 'package:runmaze2/model/athlete.dart';

class AthleteHive {
  final String _boxName = 'athletes';

  Box<Athlete> _athleteBox = Hive.box<Athlete>('athletes');



  // Future<void> openBox() async {
  //   _athleteBox = await Hive.openBox<Athlete>(_boxName);
  // }

  Future<void> _prepareBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _athleteBox = await Hive.openBox<Athlete>(_boxName);
    } else {
      _athleteBox = Hive.box(_boxName);
    }
  }

  Future<void> addAthlete(Athlete athlete) async {
    await _prepareBox();
    _athleteBox.add(athlete);
  }

  Future<void> updateAthlete(Athlete oldAthlete, Athlete newAthlete) async {
    await _prepareBox();
    final int index = _athleteBox.values.toList().indexOf(oldAthlete);
    if (index != -1) {
      _athleteBox.putAt(index, newAthlete);
    }
  }

  Future<void> updateAthleteByKey(int key, Athlete athlete) async {
    await _prepareBox();
    if (_athleteBox.containsKey(key)) {
      _athleteBox.put(key, athlete);
    }
  }

  Future<void> deleteAthlete(Athlete athlete) async {
    await _prepareBox();
    final int index = _athleteBox.values.toList().indexOf(athlete);
    if (index != -1) {
      _athleteBox.deleteAt(index);
    }
  }

  Future<bool> deleteAthleteByKey(int key) async {
    await _prepareBox();
    final Athlete? athlete = _athleteBox.get(key);
    if (athlete != null) {
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

  Future<List<Athlete>> getAllAthletes() async {
    await _prepareBox();
    return _athleteBox.values.toList();
  }

  Future<Athlete?> getAthleteByKey(int key) async {
    await _prepareBox();
    return _athleteBox.get(key);
  }

  Future<Athlete?> getAthleteAt(int index) async {
    await _prepareBox();
    return _athleteBox.getAt(index);
  }

  Future<void> close() async {
    await _prepareBox();
    await _athleteBox.close();
  }

  Future<Athlete?> login(String email, String password) async {
    await _prepareBox();
    var data = _athleteBox.values.where(
        (athlete) => athlete.email == email && athlete.password == password);
    if (data.isEmpty) return null;
    return data.first;
  }


}



