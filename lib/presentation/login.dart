import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/utils/settings.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    if (settings.loggedIn) {
      // User is already logged in, navigate to home page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
      return Container(); // Return empty container while navigating
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text.trim();
                  String password = _passwordController.text.trim();
                  settings.loginFromLocalDatabse(username, password).then((loggedIn) {
                    if (loggedIn) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login failed')));
                    }
                  });
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
