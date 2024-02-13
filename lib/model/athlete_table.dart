import 'package:sqflite/sqflite.dart';

import '../models/athlete.dart';
import '../models/strava_auth.dart';

class AthleteTable {
  static const String TABLE_NAME = 'athlete';
  static const String COL_ID = 'id';
  static const String COL_EMAIL = 'email';
  static const String COL_PASSWORD = 'password';
  static const String COL_NAME = 'athlete_name';
  static const String COL_GENDER = 'gender';
  static const String COL_BIRTHDATE = 'birthdate';
  static const String COL_CITY = 'city';
  static const String COL_CLUB = 'club';
  static const String COL_COMPANY = 'company';
  static const String COL_STRAVA_ATHLETE_ID = 'strava_athlete_id';
  static const String COL_ACCESS_TOKEN = 'access_token';
  static const String COL_EXPIRES_AT = 'expires_at';
  static const String COL_REFRESH_TOKEN = 'refresh_token';
  static const String COL_CLIENT_ID = 'client_id';
  static const String COL_CLIENT_SECRET = 'client_secret';
  static const String COL_REMOTE_UPDATE = 'remote_update';

  final Database db;

  AthleteTable(this.db);

  Future<void> createTableIfNotExists() async {
    final created = await db.execute('CREATE TABLE IF NOT EXISTS $TABLE_NAME ('
        '$COL_ID INTEGER PRIMARY KEY, '
        '$COL_EMAIL TEXT, '
        '$COL_PASSWORD TEXT, '
        '$COL_NAME TEXT, '
        '$COL_GENDER TEXT, '
        '$COL_BIRTHDATE TEXT, '
        '$COL_CITY INTEGER, '
        '$COL_CLUB INTEGER, '
        '$COL_COMPANY INTEGER, '
        '$COL_STRAVA_ATHLETE_ID INTEGER, '
        '$COL_ACCESS_TOKEN TEXT, '
        '$COL_EXPIRES_AT INTEGER, '
        '$COL_REFRESH_TOKEN TEXT, '
        '$COL_CLIENT_ID INTEGER, '
        '$COL_CLIENT_SECRET TEXT, '
        '$COL_REMOTE_UPDATE INTEGER )');
    print('Table created: $created');
  }

  Future<void> deleteAllRecords() async {
    final deletedCount = await db.delete(TABLE_NAME);
    print('Deleted $deletedCount records');
  }

  Future<void> addAthlete(Athlete athlete) async {
    final insertedId = await db.insert(
      TABLE_NAME,
      athlete.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Inserted row with ID: $insertedId');
  }

  Future<Athlete?> login(String email, String password) async {
    final maps = await db.query(
      TABLE_NAME,
      where: '$COL_EMAIL = ? AND $COL_PASSWORD = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return Athlete.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Athlete?> athleteByID(int id) async {
    final maps = await db.query(
      TABLE_NAME,
      where: '$COL_ID = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Athlete.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // ... other methods (similarly translated)
}
