import 'package:intl/intl.dart';

class StravaAuth {
  // Properties
  late final int athleteId;
  late final String accessToken;
  late final DateTime? expiresAt;
  late final String refreshToken;
  late final int clientId;
  late final String clientSecret;

  // Constructor
  StravaAuth({
    required this.athleteId,
    required this.accessToken,
    this.expiresAt,
    required this.refreshToken,
    required this.clientId,
    required this.clientSecret,
  });

  // Getters
  int get getClientId => clientId;
  set setClientId(int value) => clientId = value;

  String get getClientSecret => clientSecret;
  set setClientSecret(String value) => clientSecret = value;

  int get getAthleteId => athleteId;
  set setAthleteId(int value) => athleteId = value;

  String get getAccessToken => accessToken;
  set setAccessToken(String value) => accessToken = value;

  DateTime? get getExpiresAt => expiresAt;
  set setExpiresAt(DateTime? value) => expiresAt = value;

  String get getRefreshToken => refreshToken;
  set setRefreshToken(String value) => refreshToken = value;

  // isAccessTokenValid method
  bool isAccessTokenValid() {
    if (expiresAt == null) return false; // No expiry information, assume invalid
    return expiresAt!.isAfter(DateTime.now());
  }

  // toJson method
  Map<String, dynamic> toJson() => {
        "athlete_id": athleteId,
        "access_token": accessToken,
        "expires_at": expiresAt?.millisecondsSinceEpoch,
        "refresh_token": refreshToken,
      };

  // Factory constructor from json
  factory StravaAuth.fromJson(Map<String, dynamic> json) => StravaAuth(
        athleteId: json['athlete_id'] as int,
        accessToken: json['access_token'] as String,
        expiresAt: json['expires_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['expires_at'] as int)
            : null,
        refreshToken: json['refresh_token'] as String,
        clientId: json['client_id'] as int,
        clientSecret: json['client_secret'] as String,
      );

  // toString method
  @override
  String toString() {
    return 'StravaAuth{'
        'athleteId: $athleteId, '
        'accessToken: *****, ' // Hide access token
        'expiresAt: $expiresAt, '
        'refreshToken: *****, ' // Hide refresh token
        'clientId: $clientId, '
        'clientSecret: ***'; // Hide client secret
  }


  // fromMap function
  factory StravaAuth.fromMap(Map<String, dynamic> map) {
    return StravaAuth(
      athleteId: map['athlete_id'] as int,
      accessToken: map['access_token'] as String,
      expiresAt: map['expires_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expires_at'] as int)
          : null,
      refreshToken: map['refresh_token'] as String,
      clientId: map['client_id'] as int,
      clientSecret: map['client_secret'] as String,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'athlete_id': athleteId,
      'access_token': accessToken,
      'expires_at': expiresAt?.millisecondsSinceEpoch,
      'refresh_token': refreshToken,
      'client_id': clientId,
      'client_secret': clientSecret,
    };
  }
}
