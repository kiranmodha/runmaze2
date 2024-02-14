class StravaAuthTable {
  static final String TABLE_STRAVA_AUTH = "strava_auth";
  static final String COL_ATHLETE_ID = "athlete_id";
  static final String COL_ACCESS_TOKEN = "access_token";
  static final String COL_EXPIRES_AT = "expires_at";
  static final String COL_REFRESH_TOKEN = "refresh_token";

  final DatabaseHelper dbHandler;

  StravaAuthTable(this.dbHandler);

  void createTable(Database db) {
    String CREATE_STRAVA_AUTH_TABLE = "CREATE TABLE $TABLE_STRAVA_AUTH ("
        "$COL_ATHLETE_ID INTEGER PRIMARY KEY, "
        "$COL_ACCESS_TOKEN TEXT, "
        "$COL_EXPIRES_AT INTEGER, "
        "$COL_REFRESH_TOKEN TEXT)";
    db.execute(CREATE_STRAVA_AUTH_TABLE);
  }

  void upgradeTable(Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS $TABLE_STRAVA_AUTH");
    createTable(db);
  }

  void addOrUpdateStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHandler.database;
    var result = await db.query(TABLE_STRAVA_AUTH,
        where: "$COL_ATHLETE_ID = ?", whereArgs: [stravaAuth.getAthlete_id()]);
    if (result.isNotEmpty) {
      updateStravaAuth(stravaAuth);
    } else {
      addStravaAuth(stravaAuth);
    }
  }

  void addStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHandler.database;
    var values = {
      COL_ATHLETE_ID: stravaAuth.getAthlete_id(),
      COL_ACCESS_TOKEN: stravaAuth.getAccess_token(),
      COL_EXPIRES_AT: stravaAuth.getExpires_at(),
      COL_REFRESH_TOKEN: stravaAuth.getRefresh_token(),
    };
    db.insert(TABLE_STRAVA_AUTH, values);
  }

  void updateStravaAuth(StravaAuth stravaAuth) async {
    Database db = await dbHandler.database;
    var values = {
      COL_ACCESS_TOKEN: stravaAuth.getAccess_token(),
      COL_EXPIRES_AT: stravaAuth.getExpires_at(),
      COL_REFRESH_TOKEN: stravaAuth.getRefresh_token(),
    };
    db.update(TABLE_STRAVA_AUTH, values,
        where: "$COL_ATHLETE_ID = ?", whereArgs: [stravaAuth.getAthlete_id()]);
  }

  Future<StravaAuth> getStravaAuth() async {
    Database db = await dbHandler.database;
    var result = await db.query(TABLE_STRAVA_AUTH);
    if (result.isNotEmpty) {
      var row = result.first;
      StravaAuth stravaAuth = StravaAuth();
      stravaAuth.setAthlete_id(row[COL_ATHLETE_ID]);
      stravaAuth.setAccess_token(row[COL_ACCESS_TOKEN]);
      stravaAuth.setExpires_at(row[COL_EXPIRES_AT]);
      stravaAuth.setRefresh_token(row[COL_REFRESH_TOKEN]);
      return stravaAuth;
    }
    return null;
  }
}
