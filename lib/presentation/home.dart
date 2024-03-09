// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';

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
  String username = "";

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    _settings = Provider.of<Settings>(context);
   // _settings = Provider.of<Settings>(context, listen: false);
   // await _settings.init();
    username = _settings.userId;
    getOptionsFromServer();
    setState(() {
      _initialized = true;
    });
  }

  Future<void> getOptionsFromServer() async {
    var client = http.Client();
    String serverUrl = 'https://runmaze2.000webhostapp.com/api/options/read/';
    var request = http.Request('POST', Uri.parse(serverUrl));
    request.body = json.encode({'athlete_id': _settings.athleteId.toString()});
    var response = await client.send(request);
    final body = await response.stream.bytesToString();
    _settings = Settings.fromJson(json.decode(body));
    _settings.saveAll();
    client.close();
    print(_settings);
    // checkMasterDataVersions();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // Show a loading indicator or placeholder widget while initializing
      return const CircularProgressIndicator();
    } else {
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
}
