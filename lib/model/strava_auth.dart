import 'package:intl/intl.dart';

class StravaAuth {
  // Properties
  late final String athleteId;
  late final String accessToken;
  late final String expiresAt;
  late final String refreshToken;
  late final int clientId;
  late final String clientSecret;

  // Constructor
  StravaAuth({
    required this.athleteId,
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
    required this.clientId,
    required this.clientSecret,
  });

  // Getters
  int get getClientId => clientId;
  set setClientId(int value) => clientId = value;

  String get getClientSecret => clientSecret;
  set setClientSecret(String value) => clientSecret = value;

  String get getAthleteId => athleteId;
  set setAthleteId(String value) => athleteId = value;

  String get getAccessToken => accessToken;
  set setAccessToken(String value) => accessToken = value;

  String get getExpiresAt => expiresAt;
  set setExpiresAt(String value) => expiresAt = value;

  String get getRefreshToken => refreshToken;
  set setRefreshToken(String value) => refreshToken = value;

  // isAccessTokenValid method
  bool isAccessTokenValid() {
    if (expiresAt == null) return false; // No expiry information, assume invalid
    ///TODO check if token is expired - Convert expiresAt from Text to DateTime
    ///DateTime.fromMillisecondsSinceEpoch(json['expires_at'] as int)
    ///expiresAt.millisecondsSinceEpoch   >> from datetime to int
    ///It is stored as milliseconds since epoch (1970-01-01T00:00:00Z) as string value
    ///First convert it to int and then to DateTime
    //return expiresAt!.isAfter(DateTime.now());
    return false;
  }

  // toJson method
  Map<String, dynamic> toJson() => {
        "strava_athlete_id": athleteId,
        "access_token": accessToken,
        "expires_at": expiresAt,
        "refresh_token": refreshToken,
        "client_id": clientId,
        "client_secret": clientSecret,
      };

  // Factory constructor from json
  factory StravaAuth.fromJson(Map<String, dynamic> json) => StravaAuth(
        athleteId: json['strava_athlete_id'] as String,
        accessToken: json['access_token'] as String,
        expiresAt: json['expires_at'] as String,
        refreshToken: json['refresh_token'] as String,
        clientId: json['client_id'] as int,
        clientSecret: json['client_secret'] as String,
      );

  // toString method
  @override
  String toString() {
    return 'StravaAuth{'
        'strava_athlete_id: $athleteId, '
        'accessToken: *****, ' // Hide access token
        'expiresAt: $expiresAt, '
        'refreshToken: *****, ' // Hide refresh token
        'clientId: $clientId, '
        'clientSecret: ***'; // Hide client secret
  }


  // fromMap function
  factory StravaAuth.fromMap(Map<String, dynamic> map) {
    return StravaAuth(
      athleteId: map['strava_athlete_id'] as String,
      accessToken: map['access_token'] as String,
      expiresAt: map['expires_at'] as String,
      refreshToken: map['refresh_token'] as String,
      clientId: map['client_id'] as int,
      clientSecret: map['client_secret'] as String,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'strava_athlete_id': athleteId,
      'access_token': accessToken,
      'expires_at': expiresAt,
      'refresh_token': refreshToken,
      'client_id': clientId,
      'client_secret': clientSecret,
    };
  }
}
