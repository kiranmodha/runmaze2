import 'package:runmaze2/database/sqlite_database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/city.dart'; // Assuming the City model is in a models directory

class CityTable {
  static const String tableName = 'city_master';
  static const String fieldId = 'row_id';
  static const String fieldCityName = 'city_name';

  final DatabaseHelper dbHelper;

  CityTable(this.dbHelper);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
       CREATE TABLE $tableName (
           $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
           $fieldCityName TEXT
        )
        ''';
    await db.execute(createTableSql);
  }

  Future<void> createTableIfNotExists() async {
    String createTableSql = '''
      CREATE TABLE IF NOT EXISTS $tableName ( 
        $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $fieldCityName TEXT
        )
        ''';
    await dbHelper.database.then((db) => db.execute(createTableSql));
  }

  Future<void> deleteAllRecords() async {
    final deletedCount =
        await dbHelper.database.then((db) => db.delete(tableName));
    //print('Deleted $deletedCount records');
  }

  Future<void> addCity(City city) async {
    final insertedId = await dbHelper.database.then((db) => db.insert(
          tableName,
          city.toMap(),
          conflictAlgorithm:
              ConflictAlgorithm.replace, // Handle potential conflicts
        ));
    //print('Inserted row with ID: $insertedId');
  }

  Future<String> getTextFromId(int id) async {
    final maps = await dbHelper.database.then((db) => db.query(
          tableName,
          columns: [fieldCityName],
          where: '$fieldId = ?',
          whereArgs: [id],
        ));

    if (maps.isNotEmpty) {
      return maps.first[fieldCityName] as String;
    } else {
      return ''; // Handle case where no city is found
    }
  }

  Future<List<City>> getCities() async {
    final maps = await dbHelper.database
        .then((db) => db.query(tableName, orderBy: fieldCityName));
    return List.generate(maps.length, (i) => City.fromMap(maps[i]));
  }
}
