

import 'package:runmaze2/database/athlete_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:runmaze2/database/workout_table.dart';

class DatabaseHelper {
  static const databaseName = 'runmaze.db';
  static const databaseVersion = 4;

  static Database? _database;

  DatabaseHelper._internal();

  static DatabaseHelper instance = DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

   // Following code is used temporarily to create tables if they don't exist
   // _database!.execute("DROP TABLE IF EXISTS athlete");
   // _database!.execute("DROP TABLE IF EXISTS athlete_master");
   // await AthleteTable.createTable(_database!);


    return _database!;
  }

  Future _onCreate(Database db, int version) async {

    await WorkoutTable.createTable(db);
    await AthleteTable.createTable(db);

    // Create other tables (stravaAuth, athlete, version, etc.) using a similar approach

    await createTempDayTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion == 1 && newVersion == 2) {
    //   await createTempDayTable(db);
    // }

    // if (newVersion == 4) {
    //   // Handle leaderboard table upgrade here
    //   leaderboardTable.upgradeTable(db, oldVersion, newVersion);
    // }
  }

  Future createTempDayTable(Database db) async {
    await db.execute('''
      CREATE TABLE days (
        day INTEGER PRIMARY KEY
      )
    ''');

    for (int i = 1; i <= 31; i++) {
      await db.insert('days', {'day': i});
    }
  }

  // Define other table-related methods as needed
}


// import 'package:flutter_application_1/database/stravaauth_table.dart';
// import 'package:flutter_application_1/database/workout_table.dart';
// import 'package:flutter_application_1/model/workout.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static const String DATABASE_NAME = "runmaze.db";
//   static const int DATABASE_VERSION = 2;

//   Database? _database;

//   Future<Database> get database async {
//     _database ??= await _initialize(); //If _database is null then initialize it
//     return _database!;
//   }

//   Future<String> get fullPath async {
//     final path = await getDatabasesPath();
//     return join(path, DATABASE_NAME);
//   }

//   Future<Database> _initialize() async {
//     final path = await fullPath;
//     var database = await openDatabase(
//       path,
//       version: DATABASE_VERSION,
//       onCreate: onCreate,
//       singleInstance: true,
//     );
//     return database;
//   }

//   late WorkoutTable workoutTable;
//   late StravaAuthTable stravaAuthTable;

//   DatabaseHelper() {
//     workoutTable = WorkoutTable(this);
//     stravaAuthTable = StravaAuthTable(this);
//   }

//   Future<Database> db() async {
//     return openDatabase(
//       DATABASE_NAME,
//       version: DATABASE_VERSION,
//       onCreate: onCreate,
//       onUpgrade: onUpgrade,
//     );
//   }

//   void onCreate(Database db, int version) {
//     workoutTable.createTable(db);
//     stravaAuthTable.createTable(db);
//   }

//   void onUpgrade(Database db, int oldVersion, int newVersion) {
//     workoutTable.upgradeTable(db, oldVersion, newVersion);
//   }
// }