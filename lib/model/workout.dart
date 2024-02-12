// ignore_for_file: non_constant_identifier_names

class Workout {
  final int row_id;
  final DateTime workout_date;
  final int athlete_id;
  final double distance;
  final String activity_type;
  final int duration_hh;
  final int duration_mm;
  final int duration_ss;
  final String link;
  final int remote_update;
  final String object_id;

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
    required this.object_id,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      row_id: map['row_id'],
      workout_date: DateTime.parse(map['workout_date']),
      athlete_id: map['athlete_id'],
      distance: map['distance'],
      activity_type: map['activity_type'],
      duration_hh: map['duration_hh'],
      duration_mm: map['duration_mm'],
      duration_ss: map['duration_ss'],
      link: map['link'],
      remote_update: map['remote_update'],
      object_id: map['object_id'],
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
    String? object_id,
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
        object_id: object_id ?? this.object_id,
      );
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
