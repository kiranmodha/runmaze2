// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:runmaze2/database/hive_database/workout_hive.dart';
import 'package:runmaze2/model/workout.dart';

class RecentActivitiesFragment extends StatefulWidget {
  const RecentActivitiesFragment({super.key});

  @override
  _RecentActivitiesPageState createState() => _RecentActivitiesPageState();
}

class _RecentActivitiesPageState extends State<RecentActivitiesFragment> {
  bool _initialized = false;
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _recentActivitiesFragment();
  }

  Widget _recentActivitiesFragment() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Container(
        //margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple[200]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader("RECENT ACTIVITIES"),
                _buildButton("SHOW MORE"),
              ],
            ),
            const SizedBox(height: 16.0),
            for (Workout workout in _workouts)
              _buildActivityItem(
                  workout.activity_type,
                  workout.duration_hh.toString(),
                  workout.distance.toString(),
                  workout.getPace(),
                  workout.getDateTime().toString()),
            _buildActivityItem(
                "ride", "9.04 km", "01:07:46", "6:35 min/km", "Yesterday"),
            const SizedBox(height: 16.0),
            _buildActivityItem(
                "run", "14.20 km", "01:25:46", "7:05 min/km", "Sun, 30/12/21"),
            const SizedBox(height: 8.0),
            _buildButton("ADD AN ACTIVY MANUALLY"),
            const SizedBox(height: 8.0),
            _buildButton("LEAERBOARD"),
          ],
        ),
      ),
    );
  }

  Future<void> loadActivities() async {
    WorkoutHive workoutHive = WorkoutHive();
    _workouts = await workoutHive.getRecentWorkouts();
    setState(() {
      _initialized = true;
    });
    //for (Workout workout in workouts) {}
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
    );
  }

  Widget _buildButton(String text) {
    return TextButton(
      onPressed: () {}, // Add functionality for button press

      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.purple[200]!),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.0, color: Colors.purple),
      ),
    );
  }

  Widget _buildActivityItem(String image, String distance, String duration,
      String pace, String date) {
    return Row(children: [
      Image.asset(
        "assets/images/$image.png", // Assuming image resources are in assets folder
        width: 32.0,
        height: 32.0,
      ),
      const SizedBox(width: 16.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(distance),
          const SizedBox(height: 4.0),
          Text(duration),
        ],
      ),
      const Spacer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(pace),
          const SizedBox(height: 4.0),
          Text(date),
        ],
      ),
    ]);
  }
}
