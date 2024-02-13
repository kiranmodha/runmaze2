import 'package:sqflite/sqflite.dart';

import '../models/city.dart'; // Assuming the City model is in a models directory

class CityTable {
  static const String TABLE_NAME = 'city_master';
  static const String COL_ID = 'row_id';
  static const String COL_NAME = 'city_name';

  final Database db;

  CityTable(this.db);

  Future<void> createTableIfNotExists() async {
    final created = await db.execute(
      'CREATE TABLE IF NOT EXISTS $TABLE_NAME ('
      '$COL_ID INTEGER PRIMARY KEY, '
      '$COL_NAME TEXT'
      ')',
    );
    print('Table created: $created');
  }

  Future<void> deleteAllRecords() async {
    final deletedCount = await db.delete(TABLE_NAME);
    print('Deleted $deletedCount records');
  }

  Future<void> addCity(City city) async {
    final insertedId = await db.insert(
      TABLE_NAME,
      city.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Handle potential conflicts
    );
    print('Inserted row with ID: $insertedId');
  }

  Future<String> getTextFromId(int id) async {
    final maps = await db.query(
      TABLE_NAME,
      columns: [COL_NAME],
      where: '$COL_ID = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first[COL_NAME] as String;
    } else {
      return ''; // Handle case where no city is found
    }
  }

  Future<List<City>> getCities() async {
    final maps = await db.query(TABLE_NAME, orderBy: COL_NAME);
    return List.generate(maps.length, (i) => City.fromMap(maps[i]));
  }
}
