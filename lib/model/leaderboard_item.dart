// This code assumes you are using Null Safety (Dart 2.12+)

class LeaderboardItem {
  final int id;
  final int serialNo;
  final String name;
  final int activityCount;
  final int dayReported;
  final double distance; // Use double instead of Float
  final int clubId;
  final int companyId;
  final int cityId;
  final String period;
  final String activityType;
  final String leaderboardType;

  const LeaderboardItem(
    this.id,
    this.serialNo,
    this.dayReported,
    this.name,
    this.activityCount,
    this.distance,
    this.clubId,
    this.companyId,
    this.cityId,
    this.period,
    this.activityType,
    this.leaderboardType,
  );

  // No need for getters and setters in Dart since fields are mutable by default

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'activity_count': activityCount,
      'distance': distance,
      'days': dayReported,
      'club': clubId,
      'company': companyId,
      'city': cityId,
      'period': period,
      'activity_type': activityType,
      'leaderboard_type': leaderboardType
    };
  }

  factory LeaderboardItem.fromMap(Map<String, dynamic> map) {
    return LeaderboardItem(
      map['id'],
      map['serial_no'],
      map['days'],
      map['name'],
      map['activity_count'],
      map['distance'],
      map['club'],
      map['company'],
      map['city'],
      map['period'],
      map['activity_type'],
      map['leaderboard_type'],
    );
  }
}

