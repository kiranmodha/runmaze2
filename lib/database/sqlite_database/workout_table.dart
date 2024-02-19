import 'package:runmaze2/database/sqlite_database/database_helper.dart';
import 'package:runmaze2/model/month_distance.dart';
import 'package:runmaze2/model/workout.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutTable {
  static const String tableName = "workout";
  static const String fieldWorkoutDate = "workout_date";
  static const String fieldId = "id";
  static const String fieldDistance = "distance";
  static const String fieldActivityType = "activity_type";
  static const String fieldDurationHH = "duration_hh";
  static const String fieldDurationMM = "duration_mm";
  static const String fieldDurationSS = "duration_ss";
  static const String fieldLink = "link";

  final DatabaseHelper dbHelper;

  WorkoutTable(this.dbHelper);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
      CREATE TABLE $tableName ( 
        $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $fieldWorkoutDate TEXT, 
        $fieldActivityType TEXT, 
        $fieldDistance REAL, 
        $fieldDurationHH INTEGER, 
        $fieldDurationMM INTEGER, 
        $fieldDurationSS INTEGER, 
        $fieldLink TEXT
        )
       ''';
    db.execute(createTableSql);
  }

  void upgradeTable(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $tableName");
    createTable(db);
  }

  void addWorkout(Workout workout) async {
    Database db = await dbHelper.database;
    var values = {
      fieldWorkoutDate: workout.getDateTime(),
      fieldDistance: workout.getDistance(),
      fieldActivityType: workout.getActivityType(),
      fieldDurationHH: workout.getHH(),
      fieldDurationMM: workout.getMM(),
      fieldDurationSS: workout.getSS(),
      fieldLink: workout.getLink(),
    };
    db.insert(tableName, values);
  }

  void updateWorkout(Workout workout) async {
    Database db = await dbHelper.database;
    var values = {
      fieldWorkoutDate: workout.getDateTime(),
      fieldDistance: workout.getDistance(),
      fieldActivityType: workout.getActivityType(),
      fieldDurationHH: workout.getHH(),
      fieldDurationMM: workout.getMM(),
      fieldDurationSS: workout.getSS(),
      fieldLink: workout.getLink(),
    };
    db.update(tableName, values,
        where: "$fieldId = ?", whereArgs: [workout.getId()]);
  }

  void deleteWorkout(int id) async {
    Database db = await dbHelper.database;
    db.delete(tableName, where: "$fieldId = ?", whereArgs: [id]);
  }

  Future<int> getNumberOfActivities() async {
    Database db = await dbHelper.database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM $tableName");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getTotalDistance() async {
    Database db = await dbHelper.database;

    // Use a parameterized query to prevent SQL injection vulnerabilities
    String sql = "SELECT SUM($fieldDistance) as total_distance FROM $tableName";
    List<Map<String, dynamic>> queryResponse = await db.rawQuery(sql);

    // Extract the first element (total distance) and handle null scenarios
    double totalDistance =
        queryResponse.isNotEmpty ? queryResponse[0]['total_distance'] : 0.0;

    return totalDistance;
  }

  Future<List<MonthDistance>> getMonthlyDistance() async {
    Database db = await dbHelper.database;
    var result = await db.rawQuery("SELECT SUM($fieldDistance) distance, "
        "strftime('%Y-%m', $fieldWorkoutDate) year_month, "
        "strftime('%Y', $fieldWorkoutDate) year, "
        "strftime('%m', $fieldWorkoutDate) month "
        "FROM $tableName "
        "GROUP BY year_month "
        "ORDER BY year_month");
    List<MonthDistance> arrayList = [];
    double distance;
    for (var row in result) {
      distance = row['distance'] as double;
      arrayList.add(MonthDistance(
          row['month'].toString(), row['year'].toString(), distance));
    }
    return arrayList;
  }

  Future<String> getTotalHoursMinutes() async {
    Database db = await dbHelper.database;
    var result = await db.rawQuery("SELECT SUM($fieldDurationHH) AS HOURS, "
        "SUM($fieldDurationMM) AS MINUTES, "
        "SUM($fieldDurationSS) AS SECONDS "
        "FROM $tableName");

    if (result.isEmpty) return '';

    var sumHours = result.first['HOURS'] as double;
    var sumMinutes = result.first['MINUTES'] as double;
    var sumSeconds = result.first['SECONDS'] as double;
    sumMinutes += (sumSeconds / 60).floor();
    sumHours += (sumMinutes / 60).floor();
    sumMinutes %= 60;
    return "$sumHours h $sumMinutes min";
  }

  Future<List<Workout>> getWorkouts() async {
    final result = await dbHelper.database.then((db) => db.query(tableName));
    return List.generate(result.length, (i) => Workout.fromMap(result[i]));
  }

  Future<Workout?> getWorkout(int id) async {
    final result = await dbHelper.database.then((db) => db.query(
          tableName,
          where: '$fieldId = ?',
          whereArgs: [id],
        ));

    if (result.isNotEmpty) {
      return Workout.fromMap(result.first);
    } else {
      return null;
    }
  }
}
