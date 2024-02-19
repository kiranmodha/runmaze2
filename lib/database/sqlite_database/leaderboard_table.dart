import 'package:runmaze2/model/leaderboard_item.dart';
import 'package:sqflite/sqflite.dart';

class LeaderboardTable {
  static const String tableLeaderboard = 'leaderboard';
  static const String columnId = 'id'; // Primary key column
  static const String columnName = 'name';
  static const String columnNos = 'activity_count';
  static const String columnDistance = 'distance';
  static const String columnDays = 'days';
  static const String columnClub = 'club';
  static const String columnCompany = 'company';
  static const String columnCity = 'city';
  static const String columnPeriod = 'period';
  static const String columnLbType = 'leaderboard_type';
  static const String columnActivityType = 'activity_type';

  final Database db;

  LeaderboardTable(this.db);

  Future<void> createTable() async {
    await db.execute('''
      CREATE TABLE $tableLeaderboard (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnNos INTEGER,
        $columnDistance REAL,
        $columnDays INTEGER,
        $columnClub INTEGER,
        $columnCompany INTEGER,
        $columnCity INTEGER,
        $columnPeriod TEXT,
        $columnLbType TEXT,
        $columnActivityType TEXT
      )
    ''');
  }

  Future<void> upgradeTable(int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $tableLeaderboard');
    await createTable();
  }

  Future<void> deleteAllRecords() async {
    await db.delete(tableLeaderboard, where: 'leaderboard_type = ""');
  }

  Future<void> deleteAllRecordsHDC() async {
    await db.delete(tableLeaderboard, where: 'leaderboard_type = "HDC"');
  }

  Future<void> addLeaderboardItem(LeaderboardItem leaderboardItem) async {
    await db.insert(
      tableLeaderboard,
      leaderboardItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LeaderboardItem>> getLeaderboardItems(
    String period,
    String filter,
  ) async {
    final List<Map<String, dynamic>> maps = await db.query(
      tableLeaderboard,
      where: 'period = ? ${filter.isNotEmpty ? 'AND $filter' : ''}',
      whereArgs: [period],
    );

    return List.generate(maps.length, (i) {
      return LeaderboardItem.fromMap(maps[i]);
    });
  }
}
