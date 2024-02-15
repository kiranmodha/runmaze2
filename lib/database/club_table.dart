import 'package:runmaze2/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../model/club.dart'; // Assuming the City model is in a models directory

class ClubTable {
  static const String tableName = 'club_master';
  static const String fieldId = 'row_id';
  static const String fieldClubName = 'club_name';

  final DatabaseHelper dbHelper;

  ClubTable(this.dbHelper);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
       CREATE TABLE $tableName (
           $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
           $fieldClubName TEXT
        )
        ''';
    await db.execute(createTableSql);
  }

  Future<void> createTableIfNotExists() async {
    String createTableSql = '''
      CREATE TABLE IF NOT EXISTS $tableName ( 
        $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $fieldClubName TEXT
        )
        ''';
    await dbHelper.database.then((db) => db.execute(createTableSql));
  }

  Future<void> deleteAllRecords() async {
    final deletedCount =
        await dbHelper.database.then((db) => db.delete(tableName));
    //print('Deleted $deletedCount records');
  }

  Future<void> addClub(Club club) async {
    final insertedId = await dbHelper.database.then((db) => db.insert(
          tableName,
          club.toMap(),
          conflictAlgorithm:
              ConflictAlgorithm.replace, // Handle potential conflicts
        ));
    //print('Inserted row with ID: $insertedId');
  }

  Future<String> getTextFromId(int id) async {
    final maps = await dbHelper.database.then((db) => db.query(
          tableName,
          columns: [fieldClubName],
          where: '$fieldId = ?',
          whereArgs: [id],
        ));

    if (maps.isNotEmpty) {
      return maps.first[fieldClubName] as String;
    } else {
      return ''; // Handle case where no company is found
    }
  }

  Future<List<Club>> getCompanies() async {
    final maps = await dbHelper.database
        .then((db) => db.query(tableName, orderBy: fieldClubName));
    return List.generate(maps.length, (i) => Club.fromMap(maps[i]));
  }
}
