import 'package:runmaze2/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../model/company.dart'; // Assuming the City model is in a models directory

class CompanyTable {
  static const String tableName = 'company_master';
  static const String fieldId = 'row_id';
  static const String fieldCompanyName = 'company_name';

  final DatabaseHelper dbHelper;

  CompanyTable(this.dbHelper);

  static Future<void> createTable(Database db) async {
    String createTableSql = '''
       CREATE TABLE $tableName (
           $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
           $fieldCompanyName TEXT
        )
        ''';
    await db.execute(createTableSql);
  }

  Future<void> createTableIfNotExists() async {
    String createTableSql = '''
      CREATE TABLE IF NOT EXISTS $tableName ( 
        $fieldId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $fieldCompanyName TEXT
        )
        ''';
    await dbHelper.database.then((db) => db.execute(createTableSql));
  }

  Future<void> deleteAllRecords() async {
    final deletedCount =
        await dbHelper.database.then((db) => db.delete(tableName));
    //print('Deleted $deletedCount records');
  }

  Future<void> addCompany(Company company) async {
    final insertedId = await dbHelper.database.then((db) => db.insert(
          tableName,
          company.toMap(),
          conflictAlgorithm:
              ConflictAlgorithm.replace, // Handle potential conflicts
        ));
    //print('Inserted row with ID: $insertedId');
  }

  Future<String> getTextFromId(int id) async {
    final maps = await dbHelper.database.then((db) => db.query(
          tableName,
          columns: [fieldCompanyName],
          where: '$fieldId = ?',
          whereArgs: [id],
        ));

    if (maps.isNotEmpty) {
      return maps.first[fieldCompanyName] as String;
    } else {
      return ''; // Handle case where no company is found
    }
  }

  Future<List<Company>> getCompanies() async {
    final maps = await dbHelper.database
        .then((db) => db.query(tableName, orderBy: fieldCompanyName));
    return List.generate(maps.length, (i) => Company.fromMap(maps[i]));
  }
}
