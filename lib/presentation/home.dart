// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/database/hive_database/workout_hive.dart';
import 'package:runmaze2/utils/settings.dart';
import 'package:http/http.dart' as http;
import 'package:runmaze2/model/workout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;
  late Settings _settings;
  String username = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initSettings();
    });
  }

  Future<void> _initSettings() async {
    _settings = Provider.of<Settings>(context, listen: false);
    username = _settings.userId;
    await getOptionsFromServer();
    //   await fetchWorkoutsFromRemoteServer();
    setState(() {
      _initialized = true;
    });
  }

  Future<void> getOptionsFromServer() async {
    var uri = Uri.parse('https://runmaze2.000webhostapp.com/api/options/read/');
    var requestBody = <String, String>{
      'athlete_id': _settings.athleteId.toString()
    };
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      _settings.loadFromJson(jsonDecode(respStr));
    } else {
      // Handle any errors
    }
    // checkMasterDataVersions();
  }

  Future<void> fetchWorkoutsFromRemoteServer() async {
    var uri = Uri.parse('https://runmaze2.000webhostapp.com/api/workout/read/');
    var requestBody = <String, String>{
      'athlete_id': _settings.athleteId.toString()
    };
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      var responseMap = jsonDecode(respStr);
      String status = responseMap["status"];
      if (status == "success") {
        List<Map<String, dynamic>> workoutMapList =
            responseMap["workout"].cast<Map<String, dynamic>>();
        for (var workoutMap in workoutMapList) {
          workoutMap['athlete_id'] = _settings.athleteId;
          workoutMap['remote_update'] = 2;
        }
        List<Workout> workouts =
            Workouts.fromMapList(workoutMapList).workoutList;
        WorkoutHive workoutHive = WorkoutHive();
        workoutHive.addWorkouts(workouts);
      }
    } else {
      // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // Show a loading indicator or placeholder widget while initializing
      return const CircularProgressIndicator();
    } else {
      // return Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Home'),
      //   ),
      //   body: Center(
      //     child: Text('Welcome $username'),
      //   ),
      // );
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Welcome $username'),
              const SizedBox(height: 24.0),
              const Card(
                child: RecentActivitiesFragment(),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class RecentActivitiesFragment extends StatelessWidget {
  const RecentActivitiesFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.purple[
                200]!), // Assuming color_purple_200 translates to Colors.purple[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("HDC LEADERBOARD"),
          const SizedBox(height: 16.0), // Margin between headers
          _buildHeader("RECENT ACTIVITIES"),
          const SizedBox(height: 16.0), // Margin between headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("SHOW MORE"),
              //_buildActivityItem("ride", "9.04 km", "01:07:46", "6:35 min/km", "Yesterday"),
            ],
          ),
          const SizedBox(height: 16.0), // Margin between activities
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("SHOW MORE"),
              //_buildActivityItem("run", "14.20 km", "01:25:46", "7:05 min/km", "Sun, 30/12/21"),
            ],
          ),
          const SizedBox(height: 16.0), // Margin after activities
          _buildButton("ADD AN ACTIVITY MANUALLY"),
          const SizedBox(height: 24.0), // Margin after button
          _buildButton("LEADERBOARD"),
        ],
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.purple[
            200], // Assuming color_purple_200 translates to Colors.purple[200]
      ),
    );
  }

  Widget _buildActivityItem(String image, String distance, String duration,
      String pace, String date) {
    return Row(
      children: [
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
      ],
    );
  }

  Widget _buildButton(String text) {
    return TextButton(
      onPressed: () {}, // Add functionality for button press

      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        backgroundColor: Colors.grey[200],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.0,
          color: Color.fromARGB(255, 37, 29, 39),
        ),
      ),
    );
  }
}
