// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:runmaze2/database/database_helper.dart';
import 'package:runmaze2/model/month_distance.dart';
import 'package:runmaze2/model/workout.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutTable {
  static const String TABLE_NAME = "workout";
  static const String COL_WORKOUT_DATE = "workout_date";
  static const String COL_ID = "id";
  static const String COL_DISTANCE = "distance";
  static const String COL_ACTIVITY_TYPE = "activity_type";
  static const String COL_DURATION_HH = "duration_hh";
  static const String COL_DURATION_MM = "duration_mm";
  static const String COL_DURATION_SS = "duration_ss";
  static const String COL_LINK = "link";

  final DatabaseHelper dbHandler;

  WorkoutTable(this.dbHandler);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
      CREATE TABLE $TABLE_NAME ( 
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COL_WORKOUT_DATE TEXT, 
        $COL_ACTIVITY_TYPE TEXT, 
        $COL_DISTANCE REAL, 
        $COL_DURATION_HH INTEGER, 
        $COL_DURATION_MM INTEGER, 
        $COL_DURATION_SS INTEGER, 
        $COL_LINK TEXT
        )
       ''';
    db.execute(createTableSql);
  }

  void upgradeTable(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $TABLE_NAME");
    createTable(db);
  }

  void addWorkout(Workout workout) async {
    Database db = await dbHandler.database;
    var values = {
      COL_WORKOUT_DATE: workout.getDateTime(),
      COL_DISTANCE: workout.getDistance(),
      COL_ACTIVITY_TYPE: workout.getActivityType(),
      COL_DURATION_HH: workout.getHH(),
      COL_DURATION_MM: workout.getMM(),
      COL_DURATION_SS: workout.getSS(),
      COL_LINK: workout.getLink(),
    };
    db.insert(TABLE_NAME, values);
  }

  void updateWorkout(Workout workout) async {
    Database db = await dbHandler.database;
    var values = {
      COL_WORKOUT_DATE: workout.getDateTime(),
      COL_DISTANCE: workout.getDistance(),
      COL_ACTIVITY_TYPE: workout.getActivityType(),
      COL_DURATION_HH: workout.getHH(),
      COL_DURATION_MM: workout.getMM(),
      COL_DURATION_SS: workout.getSS(),
      COL_LINK: workout.getLink(),
    };
    db.update(TABLE_NAME, values,
        where: "$COL_ID = ?", whereArgs: [workout.getId()]);
  }

  void deleteWorkout(int id) async {
    Database db = await dbHandler.database;
    db.delete(TABLE_NAME, where: "$COL_ID = ?", whereArgs: [id]);
  }

  Future<int> getNumberOfActivities() async {
    Database db = await dbHandler.database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM $TABLE_NAME");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Future<double?> getTotalDistance() async {
  //   Database db = await dbHandler.database;
  //   var result = await db.rawQuery("SELECT SUM($COL_DISTANCE) FROM $TABLE_WORKOUT");
  //   return Sqflite.firstDoubleValue(result);
  // }

  Future<double> getTotalDistance() async {
    Database db = await dbHandler.database;

    // Use a parameterized query to prevent SQL injection vulnerabilities
    String sql = "SELECT SUM($COL_DISTANCE) as total_distance FROM $TABLE_NAME";
    List<Map<String, dynamic>> queryResponse = await db.rawQuery(sql);

    // Extract the first element (total distance) and handle null scenarios
    double totalDistance =
        queryResponse.isNotEmpty ? queryResponse[0]['total_distance'] : 0.0;

    return totalDistance;
  }

  Future<List<MonthDistance>> getMonthlyDistance() async {
    Database db = await dbHandler.database;
    var result = await db.rawQuery("SELECT SUM($COL_DISTANCE) distance, "
        "strftime('%Y-%m', $COL_WORKOUT_DATE) year_month, "
        "strftime('%Y', $COL_WORKOUT_DATE) year, "
        "strftime('%m', $COL_WORKOUT_DATE) month "
        "FROM $TABLE_NAME "
        "GROUP BY year_month "
        "ORDER BY year_month");
    List<MonthDistance> arrayList = [];
    for (var row in result) {
      arrayList.add(MonthDistance(row['month'], row['year'], row['distance']));
    }
    return arrayList;
  }

  Future<String> getTotalHoursMinutes() async {
    Database db = await dbHandler.database;
    var result = await db.rawQuery("SELECT SUM($COL_DURATION_HH) AS HOURS, "
        "SUM($COL_DURATION_MM) AS MINUTES, "
        "SUM($COL_DURATION_SS) AS SECONDS "
        "FROM $TABLE_NAME");
    var sumHours = result.first['HOURS'];
    var sumMinutes = result.first['MINUTES'];
    var sumSeconds = result.first['SECONDS'];
    sumMinutes += (sumSeconds / 60).floor();
    sumHours += (sumMinutes / 60).floor();
    sumMinutes %= 60;
    return "$sumHours h $sumMinutes min";
  }

  Future<List<Workout>> getWorkouts() async {
    List<Workout> arrayList = [];
    Database db = await dbHandler.database;
    var result = await db.query(TABLE_NAME);
    for (var row in result) {
      Workout workout = Workout();
      workout.setId(row[COL_ID]);
      workout.setDatetime(row[COL_WORKOUT_DATE]);
      workout.setActivityType(row[COL_ACTIVITY_TYPE]);
      workout.setDistance(row[COL_DISTANCE]);
      workout.setHH(row[COL_DURATION_HH]);
      workout.setMM(row[COL_DURATION_MM]);
      workout.setSS(row[COL_DURATION_SS]);
      workout.setLink(row[COL_LINK]);
      arrayList.add(workout);
    }
    return arrayList;
  }

  Future<Workout> getWorkout(int id) async {
    Database db = await dbHandler.database;
    var result =
        await db.query(TABLE_NAME, where: "$COL_ID = ?", whereArgs: [id]);
    if (result.isNotEmpty) {
      var row = result.first;
      Workout workout = Workout();
      workout.setId(row[COL_ID]);
      workout.setDatetime(row[COL_WORKOUT_DATE]);
      workout.setActivityType(row[COL_ACTIVITY_TYPE]);
      workout.setDistance(row[COL_DISTANCE]);
      workout.setHH(row[COL_DURATION_HH]);
      workout.setMM(row[COL_DURATION_MM]);
      workout.setSS(row[COL_DURATION_SS]);
      workout.setLink(row[COL_LINK]);
      return workout;
    }
    return null;
  }
}
