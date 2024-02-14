// import 'package:sqflite/sqflite.dart';

 import '../model/athlete.dart';
 import '../model/strava_auth.dart';
 import 'database_helper.dart';


// class AthleteTable {
//   static const String TABLE_NAME = 'athlete';
//   static const String COL_ID = 'id';
//   static const String COL_EMAIL = 'email';
//   static const String COL_PASSWORD = 'password';
//   static const String COL_NAME = 'athlete_name';
//   static const String COL_GENDER = 'gender';
//   static const String COL_BIRTHDATE = 'birthdate';
//   static const String COL_CITY = 'city';
//   static const String COL_CLUB = 'club';
//   static const String COL_COMPANY = 'company';
//   static const String COL_STRAVA_ATHLETE_ID = 'strava_athlete_id';
//   static const String COL_ACCESS_TOKEN = 'access_token';
//   static const String COL_EXPIRES_AT = 'expires_at';
//   static const String COL_REFRESH_TOKEN = 'refresh_token';
//   static const String COL_CLIENT_ID = 'client_id';
//   static const String COL_CLIENT_SECRET = 'client_secret';
//   static const String COL_REMOTE_UPDATE = 'remote_update';

//   final Database db;

//   AthleteTable(this.db);

//   Future<void> createTableIfNotExists() async {
//     final created = await db.execute('CREATE TABLE IF NOT EXISTS $TABLE_NAME ('
//         '$COL_ID INTEGER PRIMARY KEY, '
//         '$COL_EMAIL TEXT, '
//         '$COL_PASSWORD TEXT, '
//         '$COL_NAME TEXT, '
//         '$COL_GENDER TEXT, '
//         '$COL_BIRTHDATE TEXT, '
//         '$COL_CITY INTEGER, '
//         '$COL_CLUB INTEGER, '
//         '$COL_COMPANY INTEGER, '
//         '$COL_STRAVA_ATHLETE_ID INTEGER, '
//         '$COL_ACCESS_TOKEN TEXT, '
//         '$COL_EXPIRES_AT INTEGER, '
//         '$COL_REFRESH_TOKEN TEXT, '
//         '$COL_CLIENT_ID INTEGER, '
//         '$COL_CLIENT_SECRET TEXT, '
//         '$COL_REMOTE_UPDATE INTEGER )');
//   }

//   Future<void> deleteAllRecords() async {
//     final deletedCount = await db.delete(TABLE_NAME);
//     print('Deleted $deletedCount records');
//   }

//   Future<void> addAthlete(Athlete athlete) async {
//     final insertedId = await db.insert(
//       TABLE_NAME,
//       athlete.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print('Inserted row with ID: $insertedId');
//   }

//   Future<Athlete?> login(String email, String password) async {
//     final maps = await db.query(
//       TABLE_NAME,
//       where: '$COL_EMAIL = ? AND $COL_PASSWORD = ?',
//       whereArgs: [email, password],
//     );

//     if (maps.isNotEmpty) {
//       return Athlete.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }

//   Future<Athlete?> athleteByID(int id) async {
//     final maps = await db.query(
//       TABLE_NAME,
//       where: '$COL_ID = ?',
//       whereArgs: [id],
//     );

//     if (maps.isNotEmpty) {
//       return Athlete.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }


//   // ... other methods (similarly translated)
// }


import 'package:sqflite/sqflite.dart';

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

  final DatabaseHelper dbHelper;

  AthleteTable(this.dbHelper);

  Future<void> createTable(Database db) async {
    String createTableSql = '''
      CREATE TABLE $TABLE_NAME (
        $COL_ID INTEGER PRIMARY KEY,
        $COL_EMAIL TEXT UNIQUE CHECK (LENGTH($COL_EMAIL) > 0),
        $COL_PASSWORD TEXT CHECK (LENGTH($COL_PASSWORD) > 0),
        $COL_NAME TEXT NOT NULL,
        $COL_GENDER TEXT NOT NULL,
        $COL_BIRTHDATE TEXT NOT NULL,
        $COL_CITY INTEGER,
        $COL_CLUB INTEGER,
        $COL_COMPANY INTEGER,
        $COL_REMOTE_UPDATE INTEGER,
        // Store only athlete ID from StravaAuth to avoid sensitive data leakage
        $COL_STRAVA_ATHLETE_ID INTEGER
      )
    ''';
    await db.execute(createTableSql);
  }

  Future<void> upgradeTable(Database db, int oldVersion, int newVersion) async {
    // Implement table upgrade logic if needed
  }

  Future<void> addAthlete(Athlete athlete) async {
    Database db = await dbHelper.database;
    await db.transaction((txn) async {
      txn.insert(TABLE_NAME, athlete.toJson(excludeSensitive: true));
    });
  }

  Future<void> updateAthlete(Athlete athlete) async {
    Database db = await dbHelper.database;
    await db.transaction((txn) async {
      txn.update(TABLE_NAME, athlete.toJson(excludeSensitive: true),
          where: '$COL_ID = ?', whereArgs: [athlete.id]);
    });
  }

  Future<Athlete?> login(String email, String password) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      TABLE_NAME,
      where: '$COL_EMAIL = ? AND $COL_PASSWORD = ?',
      whereArgs: [email, password],
    );
    if (results.isEmpty) return null;
    return Athlete.fromJson(results[0], includeSensitive: true);
  }

  Future<Athlete?> getById(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results =
        await db.query(TABLE_NAME, where: '$COL_ID = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return Athlete.fromJson(results[0], includeSensitive: true);
  }

  Future<StravaAuth?> getStravaAuth(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> results = await db.query(
      TABLE_NAME,
      columns: [
        COL_STRAVA_ATHLETE_ID,
      ],
      where: '$COL_ID = ? AND $COL_STRAVA_ATHLETE_ID > 0',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return StravaAuth.fromJson(results[0]);
  }

  Future<void> deleteAll() async {
    Database db = await dbHelper.database;
    await db.delete(TABLE_NAME);
  }

  // Other methods as needed...
}

