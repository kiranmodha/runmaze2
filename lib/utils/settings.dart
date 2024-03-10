import 'package:runmaze2/database/hive_database/athlete_hive.dart';
import 'package:runmaze2/database/sqlite_database/athlete_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/sqlite_database/database_helper.dart';
import '../model/athlete.dart';

class Settings with ChangeNotifier {
  int _athleteId = 0;
  int _clientId = 76621;
  String _clientSecret = "5635717f59e4ade74bf85b16eb0ce74555e25125";
  bool _loggedIn = false;
  int _allowDirectStrava = 0;
  double _cityMasterVersion = 0.0;
  double _clubMasterVersion = 0.0;
  double _companyMasterVersion = 0.0;
  int _lastRequestForWorkout = 0;
  int _lastRequestForLeaderboard = 0;
  int _lastRequestForHdcLeaderboard = 0;
  int _gapRequestForWorkout = 3600000;
  int _gapRequestForLeaderboard = 900000;
  int _gapRequestForHdcLeaderboard = 900000;
  double _requiredVersion = 0.0;
  bool _firstStravaConnect = false;
  bool _showHdcLeaderboard = false;
  String _url = "";

  bool _fetchAllWorkouts = false;
  String _userId = "";
  String _password = "";

  late SharedPreferences _prefs;

  Settings() {
    //print('Seq 1');
    //init();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadFromPreferences();
  }

  void notify() {
    ChangeNotifier();
  }

  set athleteId(int value) {
    _athleteId = value;
    _prefs.setInt("id", value);
  }

  set clientId(int value) {
    _clientId = value;
    _prefs.setInt("client_id", value);
  }

  set clientSecret(String value) {
    _clientSecret = value;
    _prefs.setString("client_secret", value);
  }

  set loggedIn(bool value) {
    _loggedIn = value;
    _prefs.setBool("logged", value);
    notifyListeners();
  }

  set allowDirectStrava(int value) {
    _allowDirectStrava = value;
    _prefs.setInt("direct_strava", value);
  }

  set cityMasterVersion(double value) {
    _cityMasterVersion = value;
    _prefs.setDouble("city_master_version", value);
  }

  set clubMasterVersion(double value) {
    _clubMasterVersion = value;
    _prefs.setDouble("club_master_version", value);
  }

  set companyMasterVersion(double value) {
    _companyMasterVersion = value;
    _prefs.setDouble("company_master_version", value);
  }

  set lastRequestForWorkout(int value) {
    _lastRequestForWorkout = value;
    _prefs.setInt("last_request_for_workout", value);
  }

  set lastRequestForLeaderboard(int value) {
    _lastRequestForLeaderboard = value;
    _prefs.setInt("last_request_for_leaderboard", value);
  }

  set lastRequestForHdcLeaderboard(int value) {
    _lastRequestForHdcLeaderboard = value;
    _prefs.setInt("last_request_for_hdc_leaderboard", value);
  }

  set userId(String value) {
    _userId = value;
    _prefs.setString("user_id", value);
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    _prefs.setString("password", value);
  }

  set gapRequestForWorkout(int value) {
    _gapRequestForWorkout = value;
    _prefs.setInt("gap_request_for_workout", value);
  }

  set gapRequestForLeaderboard(int value) {
    _gapRequestForLeaderboard = value;
    _prefs.setInt("gap_request_for_leaderboard", value);
  }

  set gapRequestForHdcLeaderboard(int value) {
    _gapRequestForHdcLeaderboard = value;
    _prefs.setInt("gap_request_for_hdc_leaderboard", value);
  }

  set requiredVersion(double value) {
    _requiredVersion = value;
    _prefs.setDouble("required_version", value);
  }

  set firstStravaConnect(bool value) {
    _firstStravaConnect = value;
    _prefs.setBool("first_strava_connect", value);
  }

  set showHdcLeaderboard(bool value) {
    _showHdcLeaderboard = value;
    _prefs.setBool("show_hdc_leaderboard", value);
  }

  set fetchAllWorkouts(bool value) {
    _fetchAllWorkouts = value;
    _prefs.setBool("fetch_all_workouts", value);
  }

  set url(String value) {
    _url = value;
    _prefs.setString("url", value);
  }

  String get userId {
    return _userId;
  }

  int get athleteId {
    return _athleteId;
  }

  int get clientId {
    return _clientId;
  }

  String get clientSecret {
    return _clientSecret;
  }

  bool get loggedIn {
    return _loggedIn;
  }

  int get allowDirectStrava {
    return _allowDirectStrava;
  }

  double get cityMasterVersion {
    return _cityMasterVersion;
  }

  double get clubMasterVersion {
    return _clubMasterVersion;
  }

  int get gapRequestForWorkout {
    return _gapRequestForWorkout;
  }

  int get gapRequestForLeaderboard {
    return _gapRequestForLeaderboard;
  }

  int get gapRequestForHdcLeaderboard {
    return _gapRequestForHdcLeaderboard;
  }

  double get requiredVersion {
    return _requiredVersion;
  }

  bool get firstStravaConnect {
    return _firstStravaConnect;
  }

  bool get showHdcLeaderboard {
    return _showHdcLeaderboard;
  }

  bool get fetchAllWorkouts {
    return _fetchAllWorkouts;
  }

  String get url {
    return _url;
  }

  @override
  String toString() {
    return 'Settings{'
        'cityMasterVersion: $_cityMasterVersion, '
        'clubMasterVersion: $_clubMasterVersion, '
        'gapRequestForWorkout: $_gapRequestForWorkout, '
        'gapRequestForLeaderboard: $_gapRequestForLeaderboard, '
        'gapRequestForHdcLeaderboard: $_gapRequestForHdcLeaderboard, '
        'requiredVersion: $_requiredVersion, '
        'firstStravaConnect: $_firstStravaConnect, '
        'showHdcLeaderboard: $_showHdcLeaderboard, '
        'fetchAllWorkouts: $_fetchAllWorkouts, '
        'url: $_url}';
  }

  Future<void> loadFromPreferences() async {
    _athleteId = _prefs.getInt("id") ?? 0;
    _clientId = _prefs.getInt("client_id") ?? 76621;
    _clientSecret = _prefs.getString("client_secret") ??
        "5635717f59e4ade74bf85b16eb0ce74555e25125";
    _loggedIn = _prefs.getBool("logged") ?? false;
    print('Seq 2');
    print('loggedIn: $_loggedIn');
    _allowDirectStrava = _prefs.getInt("direct_strava") ?? 0;
    _cityMasterVersion = _prefs.getDouble("city_master_version") ?? 0.0;
    _clubMasterVersion = _prefs.getDouble("club_master_version") ?? 0.0;
    _companyMasterVersion = _prefs.getDouble("company_master_version") ?? 0.0;
    _lastRequestForWorkout = _prefs.getInt("last_request_for_workout") ?? 0;
    _lastRequestForLeaderboard =
        _prefs.getInt("last_request_for_leaderboard") ?? 0;
    _lastRequestForHdcLeaderboard =
        _prefs.getInt("last_request_for_hdc_leaderboard") ?? 0;
    _userId = _prefs.getString("user_id") ?? "";
    _password = _prefs.getString("password") ?? "";
    _gapRequestForWorkout = _prefs.getInt("gap_request_for_workout") ?? 3600000;
    _gapRequestForLeaderboard =
        _prefs.getInt("gap_request_for_leaderboard") ?? 900000;
    _gapRequestForHdcLeaderboard =
        _prefs.getInt("gap_request_for_hdc_leaderboard") ?? 900000;
    _fetchAllWorkouts = _prefs.getBool("fetch_all_workouts") ?? false;
    _firstStravaConnect = _prefs.getBool("first_strava_connect") ?? false;
    _showHdcLeaderboard = _prefs.getBool("show_hdc_leaderboard") ?? true;
    _url = _prefs.getString("url") ?? "";
  }

  Future<void> saveAll() async {
    await _prefs.setBool("logged", _loggedIn);
    await _prefs.setInt("id", _athleteId);
    await _prefs.setInt("client_id", _clientId);
    await _prefs.setString("client_secret", _clientSecret);
    await _prefs.setInt("direct_strava", _allowDirectStrava);
    await _prefs.setDouble("city_master_version",
        _cityMasterVersion); // Use double for consistency
    await _prefs.setDouble("club_master_version", _clubMasterVersion);
    await _prefs.setDouble("company_master_version", _companyMasterVersion);
    await _prefs.setInt("last_request_for_workout", _lastRequestForWorkout);
    await _prefs.setInt(
        "last_request_for_leaderboard", _lastRequestForLeaderboard);
    await _prefs.setInt(
        "last_request_for_hdc_leaderboard", _lastRequestForHdcLeaderboard);
    await _prefs.setString("user_id", _userId);
    await _prefs.setString("password", _password);
    await _prefs.setInt("gap_request_for_workout", _gapRequestForWorkout);
    await _prefs.setInt(
        "gap_request_for_leaderboard", _gapRequestForLeaderboard);
    await _prefs.setInt(
        "gap_request_for_hdc_leaderboard", _gapRequestForHdcLeaderboard);
    await _prefs.setBool("fetch_all_workouts", _fetchAllWorkouts);
    await _prefs.setBool("first_strava_connect", _firstStravaConnect);
    await _prefs.setBool("show_hdc_leaderboard", _showHdcLeaderboard);
    await _prefs.setString("url", _url);
  }

  Future<bool> loginFromServerDb(String username, String password) async {
    final response = await Supabase.instance.client
        .from('athlete_master')
        .select()
        .eq('email', username)
        .eq('password', password);

    if (response.isNotEmpty) {
      print('Login successful from remote database');
      Athlete athlete = Athlete.fromMap(response[0]);
      AthleteHive athleteHive = AthleteHive();
      athleteHive.addAthlete(athlete);
      return true;
    }

    return false;
  }

  loadFromJson(Map<String, dynamic> json) {
    clientId  = json['client_id'] as int;
    clientSecret = json['client_secret'] as String;
    allowDirectStrava  = json['direct_strava'] as int;
    cityMasterVersion = json['city_master_version'] as double;
    clubMasterVersion = json['club_master_version'] as double;
    companyMasterVersion = json['company_master_version'] as double;
    gapRequestForWorkout = json['gap_workout_request'] as int;
    gapRequestForLeaderboard = json['gap_leaderboard_request'] as int;
    gapRequestForHdcLeaderboard =
        json['gap_hdc_leaderboard_request'] as int;
    showHdcLeaderboard = json['show_hdc_leaderboard'] as bool;
    //requiredVersion = json['app_version'] as double;
    requiredVersion = double.parse(json["app_version"].toString());
    url = json['url'] as String;
  }

  // Future<bool> loginFromLocalDb(String username, String password) async {
  //   AthleteTable athleteTable = AthleteTable(DatabaseHelper.instance);
  //   Athlete? athlete = await athleteTable.login(username, password);
  //   if (athlete != null) {
  //     userId = username;
  //     loggedIn = true;
  //     athleteId = athlete.id;
  //     password = password;
  //     print('Login successful from local database');
  //     return true;
  //   } else {
  //     return await loginFromServerDb(username, password);
  //   }
  // }

  Future<bool> loginFromLocalDb(String username, String password) async {
    AthleteHive athleteHive = AthleteHive();
    Athlete? athlete = await athleteHive.login(username, password);

    if (athlete != null) {
      userId = username;
      loggedIn = true;
      athleteId = athlete.rowId;
      password = password;
      print('Login successful from local database');
      return true;
    } else {
      return await loginFromServerDb(username, password);
    }
  }

  Future<void> logout() async {
    loggedIn = false;
    athleteId = 0;
    userId = "";
    password = "";
  }
}
