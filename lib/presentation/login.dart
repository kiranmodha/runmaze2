import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final supabase =
      SupabaseClient('https://wbceffdfjuczhuorcxkf.supabase.co', 'anonKey');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    final response = await supabase.auth.signIn(
      email: _usernameController.text,
      password: _passwordController.text,
    );

    if (response.error != null) {
      // Show error message
      print('Error: ${response.error!.message}');
    } else if (response.data != null) {
      // Save login data to settings
      print('User ID: ${response.data!.user!.id}');
      // You can now store the user ID or other information in your app settings
      // For example, using the shared_preferences package
    }
  }
}
