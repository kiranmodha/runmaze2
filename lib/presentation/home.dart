import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/utils/settings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    String username = settings.userId;
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
