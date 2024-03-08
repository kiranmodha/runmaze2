import 'package:runmaze2/model/masterdata_version.dart';
import 'package:sqflite/sqflite.dart';

class VersionTable {
  static const String tableName = 'master_data_versions';
  static const String fieldMasterData = 'master_data';
  static const String fieldVersionNumber = 'version_number';

  final Database db;

  VersionTable(this.db);

  Future<void> createTable() async {
    await db.execute('''
      CREATE TABLE $tableName (
        $fieldMasterData TEXT PRIMARY KEY,
        $fieldVersionNumber REAL
      )
    ''');

    // Optionally add default data after table creation
    // await addDefaultData();
  }

  Future<void> upgradeTable(int oldVersion, int newVersion) async {
    // Drop the table if already exists
    await db.execute('DROP TABLE IF EXISTS $tableName');
    // Create table again
    await createTable();
  }

  Future<void> addOrUpdateMasterDataVersion(
      MasterDataVersion masterDataVersion) async {
    final exists = await hasVersion(masterDataVersion.masterData);
    if (exists) {
      await updateVersion(masterDataVersion);
    } else {
      await addVersion(masterDataVersion);
    }
  }

  Future<bool> hasVersion(String masterData) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $tableName WHERE $fieldMasterData = ?',
      [masterData],
    );
    var recCount = result.first[0] as int;
    return recCount > 0;
  }

  Future<void> addVersion(MasterDataVersion masterDataVersion) async {
    await db.insert(
      tableName,
      masterDataVersion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateVersion(MasterDataVersion masterDataVersion) async {
    await db.update(
      tableName,
      masterDataVersion.toMap(),
      where: '$fieldMasterData = ?',
      whereArgs: [masterDataVersion.masterData],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MasterDataVersion?> getVersion(String data) async {
    final maps = await db.query(
      tableName,
      where: '$fieldMasterData = ?',
      whereArgs: [data],
    );
    return maps.isEmpty ? null : MasterDataVersion.fromMap(maps.first);
  }

  Future<void> addDefaultData() async {
    // Use transactions for batch insertion
    await db.transaction((txn) async {
      for (final data in ['city', 'club', 'company']) {
        final values = <String, dynamic>{
          fieldMasterData: data,
          fieldVersionNumber: 0,
        };
        await txn.insert(tableName, values,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }






}
