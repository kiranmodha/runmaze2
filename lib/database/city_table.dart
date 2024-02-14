import 'package:runmaze2/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../model/city.dart'; // Assuming the City model is in a models directory

class CityTable {
  static const String TABLE_NAME = 'city_master';
  static const String COL_ID = 'row_id';
  static const String COL_NAME = 'city_name';

  final DatabaseHelper dbHelper;

  CityTable(this.dbHelper);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
       CREATE TABLE $TABLE_NAME (
           $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
           $COL_NAME TEXT
        )
        ''';
    await db.execute(createTableSql);
  }

  Future<void> createTableIfNotExists() async {
    String createTableSql = '''
      CREATE TABLE IF NOT EXISTS $TABLE_NAME ( 
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        $COL_NAME TEXT
        )
        ''';
    await dbHelper.database.then((db) => db.execute(createTableSql));
  }

  Future<void> deleteAllRecords() async {
    final deletedCount =
        await dbHelper.database.then((db) => db.delete(TABLE_NAME));
    //print('Deleted $deletedCount records');
  }

  Future<void> addCity(City city) async {
    final insertedId = await dbHelper.database.then((db) => db.insert(
          TABLE_NAME,
          city.toMap(),
          conflictAlgorithm:
              ConflictAlgorithm.replace, // Handle potential conflicts
        ));
    //print('Inserted row with ID: $insertedId');
  }

  Future<String> getTextFromId(int id) async {
    final maps = await dbHelper.database.then((db) => db.query(
          TABLE_NAME,
          columns: [COL_NAME],
          where: '$COL_ID = ?',
          whereArgs: [id],
        ));

    if (maps.isNotEmpty) {
      return maps.first[COL_NAME] as String;
    } else {
      return ''; // Handle case where no city is found
    }
  }

  Future<List<City>> getCities() async {
    final maps = await dbHelper.database
        .then((db) => db.query(TABLE_NAME, orderBy: COL_NAME));
    return List.generate(maps.length, (i) => City.fromMap(maps[i]));
  }
}
