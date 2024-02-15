// This code assumes you are using Null Safety (Dart 2.12+)

class LeaderboardItem {
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

  const LeaderboardItem({
    required this.serialNo,
    required this.dayReported,
    required this.name,
    required this.activityCount,
    required this.distance,
    required this.clubId,
    required this.companyId,
    required this.cityId,
    required this.period,
    required this.activityType,
    required this.leaderboardType,
  });

  // No need for getters and setters in Dart since fields are mutable by default
}

// Example usage:
final item = LeaderboardItem(
  serialNo: 1,
  dayReported: 1,
  name: "John Doe",
  activityCount: 10,
  distance: 5.2,
  clubId: 123,
  companyId: 456,
  cityId: 789,
  period: "Week",
  activityType: "Running",
  leaderboardType: "Global",
);
