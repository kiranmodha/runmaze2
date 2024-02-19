import '../../model/athlete.dart';
import '../../model/strava_auth.dart';
import 'database_helper.dart';

import 'package:sqflite/sqflite.dart';

class AthleteTable {
  static const String tableName = 'athlete_master';
  static const String fieldId = 'row_id';
  static const String fieldEmail = 'email';
  static const String fieldPassword = 'password';
  static const String fieldName = 'athlete_name';
  static const String fieldGender = 'gender';
  static const String fieldBirthdate = 'birthdate';
  static const String fieldCity = 'city';
  static const String fieldClub = 'club';
  static const String fieldCompany = 'company';
  static const String fieldStravaAthleteId = 'strava_athlete_id';
  static const String fieldAccessToken = 'access_token';
  static const String fieldExpiresAt = 'expires_at';
  static const String fieldRefreshToken = 'refresh_token';
  static const String fieldClientId = 'client_id';
  static const String fieldClientSecret = 'client_secret';
  static const String fieldRemoteUpdate = 'remote_update';

  final DatabaseHelper dbHelper;

  AthleteTable(this.dbHelper);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
      CREATE TABLE $tableName (
        $fieldId INTEGER PRIMARY KEY,
        $fieldEmail TEXT UNIQUE CHECK (LENGTH($fieldEmail) > 0),
        $fieldPassword TEXT CHECK (LENGTH($fieldPassword) > 0),
        $fieldName TEXT NOT NULL,
        $fieldGender TEXT NOT NULL,
        $fieldBirthdate TEXT NOT NULL,
        $fieldCity INTEGER,
        $fieldClub INTEGER,
        $fieldCompany INTEGER,
        $fieldStravaAthleteId TEXT,
        $fieldAccessToken  TEXT, 
        $fieldExpiresAt TEXT, 
        $fieldRefreshToken  TEXT,
        $fieldClientId  INTEGER, 
        $fieldClientSecret  TEXT,  
        $fieldRemoteUpdate INTEGER
      )
    ''';
    await db.execute(createTableSql);
  }

  Future<void> upgradeTable(Database db, int oldVersion, int newVersion) async {
    // Implement table upgrade logic if needed
    db.execute("DROP TABLE IF EXISTS $tableName");
    // Create table again
    createTable(db);
  }

  Future<void> addAthlete(Athlete athlete) async {
    Database db = await dbHelper.database;
    await db.transaction((txn) async {
      txn.insert(tableName, athlete.toJson());
    });
  }

  Future<void> updateAthlete(Athlete athlete) async {
    Database db = await dbHelper.database;
    await db.transaction((txn) async {
      txn.update(tableName, athlete.toJson(),
          where: '$fieldId = ?', whereArgs: [athlete.rowId]);
    });
  }

  Future<void> updateRemoteUpdateStatus(Database db, Athlete athlete) async {
    // Prepare values for update
    final values = <String, dynamic>{};
    values[fieldRemoteUpdate] =
        athlete.remoteUpdate; // Assuming equivalent property

    // Update the athlete record
    final id = athlete.rowId;
    await db.update(
      tableName,
      values,
      where: '$fieldId = ?',
      whereArgs: [id],
    );
  }

  Future<Athlete?> login(String email, String password) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: '$fieldEmail = ? AND $fieldPassword = ?',
      whereArgs: [email, password],
    );
    if (results.isEmpty) return null;
    return Athlete.fromJson(results[0], includeSensitive: true);
  }

  Future<Athlete?> athleteById(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results =
        await db.query(tableName, where: '$fieldId = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return Athlete.fromJson(results[0], includeSensitive: true);
  }

  Future<StravaAuth?> getStravaAuth(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      columns: [
        fieldStravaAthleteId,
        fieldAccessToken,
        fieldExpiresAt,
        fieldRefreshToken,
        fieldClientId,
        fieldClientSecret,
      ],
      where: '$fieldId = ? AND $fieldStravaAthleteId > 0',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return StravaAuth.fromJson(results[0]);
  }

  Future<void> updateStravaAuth(
      Database db, StravaAuth stravaAuth, int id) async {
    // Prepare values for update
    final values = <String, dynamic>{};
    values[fieldStravaAthleteId] =
        stravaAuth.athleteId; // Assuming equivalent property
    values[fieldAccessToken] = stravaAuth.accessToken;
    values[fieldExpiresAt] = stravaAuth
        .expiresAt; // Ensure proper Dart representation (e.g., DateTime)
    values[fieldRefreshToken] = stravaAuth.refreshToken;
    values[fieldClientId] = stravaAuth.clientId;
    values[fieldClientSecret] = stravaAuth
        .clientSecret; // Consider security implications of storing this

    // Update the athlete record
    await db.update(
      tableName,
      values,
      where: '$fieldId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    Database db = await dbHelper.database;
    await db.delete(tableName);
  }

  Future<void> updateStravaAuthForAthlete(Database db, Athlete athlete) async {
    // Retrieve StravaAuth from Athlete
    final stravaAuth = athlete.stravaAuth;

    // Ensure non-null StravaAuth
    await updateStravaAuth(db, stravaAuth, athlete.rowId);
    }


}
