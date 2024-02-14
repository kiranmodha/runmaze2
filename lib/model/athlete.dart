import 'dart:convert';
import 'strava_auth.dart';

class Athlete {
  // Properties
  final int id;
  final String name;
  final String email;
  final String password;
  final String gender;
  final String birthdate;
  final int city;
  final int club;
  final int company;
  final StravaAuth stravaAuth;
  final int remoteUpdate;

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
    required this.stravaAuth,
    required this.remoteUpdate,
  });

  // Getters
  int getId() => id;
  String getName() => name;
  String getEmail() => email;
  String getPassword() => password;
  String getGender() => gender;
  String getBirthdate() => birthdate;
  int getCity() => city;
  int getClub() => club;
  int getCompany() => company;
  StravaAuth getStravaAuth() => stravaAuth;
  int getRemoteUpdate() => remoteUpdate;

  // toJson method
  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": name,
  //       "email": email,
  //       "password": password,
  //       "gender": gender,
  //       "birthdate": birthdate,
  //       "city": city,
  //       "club": club,
  //       "company": company,
  //       "strava_athlete_id": stravaAuth.athleteId,
  //       "access_token": stravaAuth.accessToken,
  //       "expires_at": stravaAuth.expiresAt,
  //       "refresh_token": stravaAuth.refreshToken,
  //     };

// Modified toJson method to include excludeSensitive flag
Map<String, dynamic> toJson({bool excludeSensitive = false}) {
  if (excludeSensitive) {
    return {
      "id": id,
      "name": name,
      "gender": gender,
      "birthdate": birthdate,
      "city": city,
      "club": club,
      "company": company,
      "strava_athlete_id": stravaAuth.athleteId,
      "access_token": stravaAuth.accessToken,
      "expires_at": stravaAuth.expiresAt,
      "refresh_token": stravaAuth.refreshToken,
    };
  } else {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "gender": gender,
      "birthdate": birthdate,
      "city": city,
      "club": club,
      "company": company,
      "strava_athlete_id": stravaAuth.athleteId,
      "access_token": stravaAuth.accessToken,
      "expires_at": stravaAuth.expiresAt,
      "refresh_token": stravaAuth.refreshToken,
    };
  }
}


  // toString method
  @override
  String toString() {
    return 'Athlete{'
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'password: $password, '
        'gender: $gender, '
        'birthdate: $birthdate, '
        'city: $city, '
        'club: $club, '
        'company: $company, '
        'stravaAuth: $stravaAuth, '
        'remoteUpdate: $remoteUpdate}';
  }

  // Factory constructor from json
  // factory Athlete.fromJson(Map<String, dynamic> json) => Athlete(
  //       id: json['id'] as int,
  //       name: json['name'] as String,
  //       email: json['email'] as String,
  //       password: json['password'] as String,
  //       gender: json['gender'] as String,
  //       birthdate: json['birthdate'] as String,
  //       city: json['city'] as int,
  //       club: json['club'] as int,
  //       company: json['company'] as int,
  //       stravaAuth: StravaAuth.fromJson(json['strava_auth'] as Map<String, dynamic>),
  //       remoteUpdate: json['remote_update'] as int,
  //     );

// Factory constructor from json
  factory Athlete.fromJson(Map<String, dynamic> json, {bool includeSensitive = false}) => Athlete(
        id: json['id'] as int,
        name: json['name'] as String,
        email: includeSensitive ? json['email'] as String :"******",
        password: includeSensitive ? json['password'] as String : "******",
        gender: json['gender'] as String,
        birthdate: json['birthdate'] as String,
        city: json['city'] as int,
        club: json['club'] as int,
        company: json['company'] as int,
        stravaAuth: StravaAuth.fromJson(json['strava_auth'] as Map<String, dynamic>),
        remoteUpdate: json['remote_update'] as int,
      );



// Function to create an Athlete object from a map
factory Athlete.fromMap(Map<String, dynamic> map) {
  return Athlete(
    id: map['id'] as int,
    name: map['name'] as String,
    email: map['email'] as String,
    password: map['password'] as String,
    gender: map['gender'] as String,
    birthdate: map['birthdate'] as String,
    city: map['city'] as int,
    club: map['club'] as int,
    company: map['company'] as int,
    stravaAuth: StravaAuth.fromMap(map['strava_auth'] as Map<String, dynamic>),
    remoteUpdate: map['remote_update'] as int,
  );
}


Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'birthdate': birthdate,
      'city': city,
      'club': club,
      'company': company,
      'strava_auth': stravaAuth.toMap(),
      'remote_update': remoteUpdate,
    };
  }

}

// Assuming StravaAuth class definition elsewhere

