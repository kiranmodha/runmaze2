// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/utils/settings.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;
  late Settings _settings;

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    String username = settings.userId;
    int athleteid = settings.athleteId;
    getOptionsFromServer();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text('Welcome $username'),
      ),
    );
  }
}
