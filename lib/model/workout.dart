// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 1)
class Workout {

  @HiveField(0)
  int row_id;

  @HiveField(1)
  DateTime workout_date;

  @HiveField(2)
  int athlete_id;

  @HiveField(3)
  double distance;

  @HiveField(4)
  String activity_type;

  @HiveField(5)
  int duration_hh;

  @HiveField(6)
  int duration_mm;

  @HiveField(7)
  int duration_ss;

  @HiveField(8)
  String link;

  @HiveField(9)
  int remote_update;


  Workout({
    required this.row_id,
    required this.workout_date,
    required this.athlete_id,
    required this.distance,
    required this.activity_type,
    required this.duration_hh,
    required this.duration_mm,
    required this.duration_ss,
    required this.link,
    required this.remote_update,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      row_id: map['id'],
      workout_date: DateTime.parse(map['date']),
      athlete_id: map['athlete_id'],
      distance: double.parse(map['distance'].toString()),
      activity_type: map['type'],
      duration_hh: map['hh'],
      duration_mm: map['mm'],
      duration_ss: map['ss'],
      link: map['link'],
      remote_update: map['remote_update'],
    );
  }

  Workout copyWith({
    int? row_id,
    DateTime? workout_date,
    int? athlete_id,
    double? distance,
    String? activity_type,
    int? duration_hh,
    int? duration_mm,
    int? duration_ss,
    String? link,
    int? remote_update,
  }) =>
      Workout(
        row_id: row_id ?? this.row_id,
        workout_date: workout_date ?? this.workout_date,
        athlete_id: athlete_id ?? this.athlete_id,
        distance: distance ?? this.distance,
        activity_type: activity_type ?? this.activity_type,
        duration_hh: duration_hh ?? this.duration_hh,
        duration_mm: duration_mm ?? this.duration_mm,
        duration_ss: duration_ss ?? this.duration_ss,
        link: link ?? this.link,
        remote_update: remote_update ?? this.remote_update,
      );

  Map<String, dynamic> getJsonObject() {
    Map<String, dynamic> jsonObject = {};
    try {
      jsonObject['id'] = getId();
      jsonObject['athlete_id'] = getAthleteId();
      jsonObject['datetime'] = getDateTime();
      jsonObject['distance'] = getDistance();
      jsonObject['activityType'] = getActivityType();
      jsonObject['HH'] = getHH();
      jsonObject['MM'] = getMM();
      jsonObject['SS'] = getSS();
      jsonObject['link'] = getLink();
      jsonObject['remote_update'] = getRemoteUpdate();
    } catch (e) {
      print(e);
    }
    return jsonObject;
  }

  int getId() {
    return row_id;
  }

  void setId(int id) {
    row_id = id;
  }

  int getAthleteId() {
    return athlete_id;
  }

  void setAthleteId(int athleteId) {
    athlete_id = athleteId;
  }

  DateTime getDateTime() {
    return workout_date;
  }

  void setDatetime(DateTime datetime) {
    workout_date = datetime;
  }

  String getActivityType() {
    return activity_type;
  }

  void setActivityType(String activityType) {
    activity_type = activityType;
  }

  double getDistance() {
    return distance;
  }

  void setDistance(double distance) {
    distance = distance;
  }

  int getHH() {
    return duration_hh;
  }

  void setHH(int HH) {
    duration_hh = HH;
  }

  int getMM() {
    return duration_mm;
  }

  void setMM(int MM) {
    duration_mm = MM;
  }

  int getSS() {
    return duration_ss;
  }

  void setSS(int SS) {
    duration_ss = SS;
  }

  String getLink() {
    return link;
  }

  void setLink(String link) {
    link = link;
  }

  int getRemoteUpdate() {
    return remote_update;
  }

  void setRemoteUpdate(int remoteUpdate) {
    remote_update = remoteUpdate;
  }

  String getPace() {
    double totalTime = (duration_hh + duration_mm / 60 + duration_ss / 3600);
    double pace = totalTime / distance * 60;
    int paceMin = pace.toInt();
    int paceSec = ((pace - paceMin) * 60).toInt();
    return "$paceMin:${paceSec.toString().padLeft(2, '0')} min/km";
  }

  String getSpeed() {
    double totalTime = (duration_hh + duration_mm / 60 + duration_ss / 3600);
    return "${(distance / totalTime).toStringAsFixed(2)} km/h";
  }
}

class Workouts {
  final List<Workout> workoutList;

  Workouts({required this.workoutList});

  factory Workouts.fromMapList(List<Map<String, dynamic>> mapList) {
    return Workouts(
      workoutList: mapList.map((item) => Workout.fromMap(item)).toList(),
    );
  }
}
