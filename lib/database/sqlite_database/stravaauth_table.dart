import 'package:runmaze2/database/sqlite_database/database_helper.dart';
import 'package:runmaze2/model/strava_auth.dart';
import 'package:sqflite/sqflite.dart';

class StravaAuthTable {
  static const String tableName = "strava_auth";
  static const String fieldAthleteId = "athlete_id";
  static const String fieldAccessToken = "access_token";
  static const String fieldExpiresAt = "expires_at";
  static const String fieldRefreshToken = "refresh_token";

  final DatabaseHelper dbHelper;

  StravaAuthTable(this.dbHelper);

  void createTable(Database db) {
    String createTableSql = "CREATE TABLE $tableName ("
        "$fieldAthleteId INTEGER PRIMARY KEY, "
        "$fieldAccessToken TEXT, "
        "$fieldExpiresAt INTEGER, "
        "$fieldRefreshToken TEXT)";
    db.execute(createTableSql);
  }

  void upgradeTable(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $tableName");
    createTable(db);
  }

  void addOrUpdateStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHelper.database;
    var result = await db.query(tableName,
        where: "$fieldAthleteId = ?", whereArgs: [stravaAuth.getAthleteId]);
    if (result.isNotEmpty) {
      updateStravaAuth(stravaAuth);
    } else {
      addStravaAuth(stravaAuth);
    }
  }

  void addStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHelper.database;
    var values = {
      fieldAthleteId: stravaAuth.getAthleteId,
      fieldAccessToken: stravaAuth.getAccessToken,
      fieldExpiresAt: stravaAuth.getExpiresAt,
      fieldRefreshToken: stravaAuth.getRefreshToken,
    };
    db.insert(tableName, values);
  }

  void updateStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHelper.database;
    var values = {
      fieldAccessToken: stravaAuth.getAccessToken,
      fieldExpiresAt: stravaAuth.getExpiresAt,
      fieldRefreshToken: stravaAuth.getRefreshToken,
    };
    db.update(tableName, values,
        where: "$fieldAthleteId = ?", whereArgs: [stravaAuth.getAthleteId]);
  }

  // Future<StravaAuth> getStravaAuth() async {
  //   Database db = await dbHelper.database;
  //   var result = await db.query(tableName);
  //   if (result.isNotEmpty) {
  //     var row = result.first;
  //     StravaAuth stravaAuth = StravaAuth();
  //     stravaAuth.setAthlete_id(row[fieldAthleteId]);
  //     stravaAuth.setAccess_token(row[fieldAccessToken]);
  //     stravaAuth.setExpires_at(row[fieldExpiresAt]);
  //     stravaAuth.setRefresh_token(row[fieldRefreshToken]);
  //     return stravaAuth;
  //   }
  //   return null;
  // }


    Future<StravaAuth?> getStravaAuth(int id) async {
    final result = await dbHelper.database.then((db) => db.query(
          tableName,
          where: '$fieldAthleteId = ?',
          whereArgs: [id],
        ));

    if (result.isNotEmpty) {
      return StravaAuth.fromMap(result.first);
    } else {
      return null;
    }
  }
}
