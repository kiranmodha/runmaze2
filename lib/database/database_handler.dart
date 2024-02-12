import 'package:flutter_application_1/model/workout.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static const String DATABASE_NAME = "runmaze.db";
  static const int DATABASE_VERSION = 2;

  late WorkoutTable workoutTable ;
  late StravaAuthTable stravaAuthTable ;

  DatabaseHandler() {
    workoutTable = WorkoutTable(this);
    stravaAuthTable = StravaAuthTable(this);
  }

  Future<Database> db() async {
    return openDatabase(
      DATABASE_NAME,
      version: DATABASE_VERSION,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
  }

  
  void onCreate(Database db, int version) {
    workoutTable.createTable(db);
    stravaAuthTable.createTable(db);

  }
  
   void onUpgrade(Database db, int oldVersion, int newVersion) {
    workoutTable.upgradeTable(db, oldVersion, newVersion);
  }
}

class WorkoutTable {
  static const String TABLE_WORKOUT = "workout";
  static const String COL_WORKOUT_DATE = "workout_date";
  static const String COL_ID = "id";
  static const String COL_DISTANCE = "distance";
  static const String COL_ACTIVITY_TYPE = "activity_type";
  static const String COL_DURATION_HH = "duration_hh";
  static const String COL_DURATION_MM = "duration_mm";
  static const String COL_DURATION_SS = "duration_ss";
  static const String COL_LINK = "link";

  final DatabaseHandler dbHandler;

  WorkoutTable(this.dbHandler);

  void createTable(Database db) {
    String CREATE_WORKOUT_TABLE = "CREATE TABLE $TABLE_WORKOUT ("
        "$COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$COL_WORKOUT_DATE TEXT, "
        "$COL_ACTIVITY_TYPE TEXT, "
        "$COL_DISTANCE REAL, "
        "$COL_DURATION_HH INTEGER, "
        "$COL_DURATION_MM INTEGER, "
        "$COL_DURATION_SS INTEGER, "
        "$COL_LINK TEXT)";
    db.execute(CREATE_WORKOUT_TABLE);
  }

  void upgradeTable(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $TABLE_WORKOUT");
    createTable(db);
  }

  void addWorkout(Workout workout) async {
    Database db = await dbHandler.db();
    var values = {
      COL_WORKOUT_DATE: workout.getDateTime(),
      COL_DISTANCE: workout.getDistance(),
      COL_ACTIVITY_TYPE: workout.getActivityType(),
      COL_DURATION_HH: workout.getHH(),
      COL_DURATION_MM: workout.getMM(),
      COL_DURATION_SS: workout.getSS(),
      COL_LINK: workout.getLink(),
    };
    db.insert(TABLE_WORKOUT, values);
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
    db.update(TABLE_WORKOUT, values,
        where: "$COL_ID = ?", whereArgs: [workout.getId()]);
  }

  void deleteWorkout(int id) async {
    Database db = await dbHandler.database;
    db.delete(TABLE_WORKOUT, where: "$COL_ID = ?", whereArgs: [id]);
  }

  Future<int> getNumberOfActivities() async {
    Database db = await dbHandler.database;
    var result = await db.rawQuery("SELECT COUNT(*) FROM $TABLE_WORKOUT");
    return Sqflite.firstIntValue(result);
  }

  Future<double> getTotalDistance() async {
    Database db = await dbHandler.database;
    var result = await db.rawQuery("SELECT SUM($COL_DISTANCE) FROM $TABLE_WORKOUT");
    return Sqflite.firstDoubleValue(result);
  }

  Future<List<MonthDistance>> getMonthlyDistance() async {
    Database db = await dbHandler.database;
    var result = await db.rawQuery(
        "SELECT SUM($COL_DISTANCE) distance, "
        "strftime('%Y-%m', $COL_WORKOUT_DATE) year_month, "
        "strftime('%Y', $COL_WORKOUT_DATE) year, "
        "strftime('%m', $COL_WORKOUT_DATE) month "
        "FROM $TABLE_WORKOUT "
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
    var result = await db.rawQuery(
        "SELECT SUM($COL_DURATION_HH) AS HOURS, "
        "SUM($COL_DURATION_MM) AS MINUTES, "
        "SUM($COL_DURATION_SS) AS SECONDS "
        "FROM $TABLE_WORKOUT");
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
    var result = await db.query(TABLE_WORKOUT);
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
    var result = await db.query(TABLE_WORKOUT,
        where: "$COL_ID = ?", whereArgs: [id]);
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

  class MonthDistance {
    String Month;
    String Year;
    double Distance;

    MonthDistance(this.Month, this.Year, this.Distance);
  }
}

class StravaAuthTable {
  static final String TABLE_STRAVA_AUTH = "strava_auth";
  static final String COL_ATHLETE_ID = "athlete_id";
  static final String COL_ACCESS_TOKEN = "access_token";
  static final String COL_EXPIRES_AT = "expires_at";
  static final String COL_REFRESH_TOKEN = "refresh_token";

  final DatabaseHandler dbHandler;

  StravaAuthTable(this.dbHandler);

  void createTable(Database db) {
    String CREATE_STRAVA_AUTH_TABLE = "CREATE TABLE $TABLE_STRAVA_AUTH ("
        "$COL_ATHLETE_ID INTEGER PRIMARY KEY, "
        "$COL_ACCESS_TOKEN TEXT, "
        "$COL_EXPIRES_AT INTEGER, "
        "$COL_REFRESH_TOKEN TEXT)";
    db.execute(CREATE_STRAVA_AUTH_TABLE);
  }

  void upgradeTable(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $TABLE_STRAVA_AUTH");
    createTable(db);
  }

  void addOrUpdateStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHandler.database;
    var result = await db.query(TABLE_STRAVA_AUTH,
        where: "$COL_ATHLETE_ID = ?", whereArgs: [stravaAuth.getAthlete_id()]);
    if (result.isNotEmpty) {
      updateStravaAuth(stravaAuth);
    } else {
      addStravaAuth(stravaAuth);
    }
  }

  void addStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHandler.database;
    var values = {
      COL_ATHLETE_ID: stravaAuth.getAthlete_id(),
      COL_ACCESS_TOKEN: stravaAuth.getAccess_token(),
      COL_EXPIRES_AT: stravaAuth.getExpires_at(),
      COL_REFRESH_TOKEN: stravaAuth.getRefresh_token(),
    };
    db.insert(TABLE_STRAVA_AUTH, values);
  }

  void updateStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHandler.database;
    var values = {
      COL_ACCESS_TOKEN: stravaAuth.getAccess_token(),
      COL_EXPIRES_AT: stravaAuth.getExpires_at(),
      COL_REFRESH_TOKEN: stravaAuth.getRefresh_token(),
    };
    db.update(TABLE_STRAVA_AUTH, values,
        where: "$COL_ATHLETE_ID = ?", whereArgs: [stravaAuth.getAthlete_id()]);
  }

  Future<StravaAuth> getStravaAuth() async {
    Database db = await dbHandler.database;
    var result = await db.query(TABLE_STRAVA_AUTH);
    if (result.isNotEmpty) {
      var row = result.first;
      StravaAuth stravaAuth = StravaAuth();
      stravaAuth.setAthlete_id(row[COL_ATHLETE_ID]);
      stravaAuth.setAccess_token(row[COL_ACCESS_TOKEN]);
      stravaAuth.setExpires_at(row[COL_EXPIRES_AT]);
      stravaAuth.setRefresh_token(row[COL_REFRESH_TOKEN]);
      return stravaAuth;
    }
    return null;
  }
}


