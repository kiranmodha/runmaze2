import 'package:runmaze2/model/strava_auth.dart';

import 'package:hive/hive.dart';

part 'athlete.g.dart';

@HiveType(typeId: 0)
class Athlete {

  @HiveField(0)
  final int id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String email;
  
  @HiveField(3)
  String password;
  
  @HiveField(4)
  String gender;
  
  @HiveField(5)
  String birthdate;
  
  @HiveField(6)
  int city;
  
  @HiveField(7)
  int club;
  
  @HiveField(8)
  int company;
  
  @HiveField(9)
  String stravaAthleteId;
  
  @HiveField(10)
  String accessToken;
  
  @HiveField(11)
  String expiresAt;
  
  @HiveField(12)
  String refreshToken;
  
  @HiveField(13)
  int clientId;
  
  @HiveField(14)
  String clientSecret;
  
  @HiveField(15)
  int remoteUpdate;
  
  @HiveField(16)

  // Constructor
  Athlete({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.birthdate,
    required this.city,
    required this.club,
    required this.company,
    required this.stravaAthleteId,
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
    required this.clientId,
    required this.clientSecret,
    required this.remoteUpdate,
  });

  StravaAuth get stravaAuth {
    return StravaAuth(
      athleteId: stravaAthleteId,
      accessToken: accessToken,
      expiresAt: expiresAt,
      refreshToken: refreshToken,
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "row_id": id,
      "athlete_name": name,
      "email": email,
      "password": password,
      "gender": gender,
      "birthdate": birthdate,
      "city": city,
      "club": club,
      "company": company,
      "strava_athlete_id": stravaAthleteId,
      "access_token": accessToken,
      "expires_at": expiresAt,
      "refresh_token": refreshToken,
      "client_id": clientId,
      "client_secret": clientSecret,
      "remote_update": remoteUpdate,
    };
  }

  // toString method
  @override
  String toString() {
    return 'Athlete{'
        'row_id: $id, '
        'athlete_name: $name, '
        'email: $email, '
        'password: $password, '
        'gender: $gender, '
        'birthdate: $birthdate, '
        'city: $city, '
        'club: $club, '
        'company: $company, '
        'strava_athlete_id: $stravaAthleteId, '
        'accessToken: $accessToken, '
        'expiresAt: $expiresAt, '
        'refreshToken: $refreshToken, '
        'clientId: $clientId, '
        'clientSecret: $clientSecret, '
        'remoteUpdate: $remoteUpdate}';
  }

// Factory constructor from json
  factory Athlete.fromJson(Map<String, dynamic> json,
          {bool includeSensitive = false}) =>
      Athlete(
        id: json['row_id'] as int,
        name: json['athlete_name'] as String,
        email: includeSensitive ? json['email'] as String : "******",
        password: includeSensitive ? json['password'] as String : "******",
        gender: json['gender'] as String,
        birthdate: json['birthdate'] as String,
        city: json['city'] as int,
        club: json['club'] as int,
        company: json['company'] as int,
        stravaAthleteId: json['strava_athlete_id'] as String,
        accessToken: json['access_token'] as String,
        expiresAt: json['expires_at'] as String,
        refreshToken: json['refresh_token'] as String,
        clientId: json['client_id'] as int,
        clientSecret: json['client_secret'] as String,
        remoteUpdate: json['remote_update'] as int,
      );

// Function to create an Athlete object from a map
  factory Athlete.fromMap(Map<String, dynamic> map) {
    return Athlete(
      id: map['row_id'] as int,
      name: map['athlete_name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      gender: map['gender'] as String,
      birthdate: map['birthdate'] as String,
      city: map['city'] as int,
      club: map['club'] as int,
      company: map['company'] as int,
      stravaAthleteId: map['strava_athlete_id'] as String,
      accessToken: map['access_token'] as String,
      expiresAt: map['expires_at'] as String,
      refreshToken: map['refresh_token'] as String,
      clientId: map['client_id'] as int,
      clientSecret: map['client_secret'] as String,
      remoteUpdate: map['remote_update'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'row_id': id,
      'athlete_name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'birthdate': birthdate,
      'city': city,
      'club': club,
      'company': company,
      'strava_athlete_id': stravaAthleteId,
      'access_token': accessToken,
      'expires_at': expiresAt,
      'refresh_token': refreshToken,
      'client_id': clientId,
      'client_secret': clientSecret,
      'remote_update': remoteUpdate,
    };
  }
}
