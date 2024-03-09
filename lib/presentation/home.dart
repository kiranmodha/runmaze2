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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initSettings();
    });
  }

  Future<void> _initSettings() async {
    //_settings = Provider.of<Settings>(context);
    _settings = Provider.of<Settings>(context, listen: false);
    // await _settings.init();
    username = _settings.userId;
    getOptionsFromServer();
    setState(() {
      _initialized = true;
    });
  }

  Future<void> getOptionsFromServer() async {
    Map<String, String> requestBody = {
      'athlete_id': _settings.athleteId.toString()
    };
    var uri = Uri.parse('https://runmaze2.000webhostapp.com/api/options/read/');
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(requestBody);
    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      _settings = Settings.fromJson(jsonDecode(respStr));
      //    _settings.saveAll();
      print(_settings);
    } else {
      // Handle any errors
      print(response.statusCode);
    }
    //print(_settings);
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
