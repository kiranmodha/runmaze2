import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = 'http://your_api_url';
  late SharedPreferences _prefs ;


  AuthService()
  {
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> login(String username, String password) async {
    // final response = await http.post(
    //   Uri.parse('$baseUrl/login'),
    //   body: jsonEncode({'username': username, 'password': password}),
    //   headers: {'Content-Type': 'application/json'},
    // );

    final response = await Supabase.instance.client
        .from('athlete_master')
        .select()
        .eq('email', username)
        .eq('password', password);

    // if (response.statusCode == 200) {
    //   // Login successful
    //   final responseData = jsonDecode(response.body);
    //   final authToken =
    //       responseData['token']; // Assuming your API returns a token
    //   await _prefs.setString('authToken', authToken);
    //   return true;
    // } else {
    //   // Login failed
    //   return false;
    // }

    if (response.isNotEmpty) {
      return true;
    }
    return false;
  }

  // Future<bool> _login(
  //     BuildContext context, String username, String password) async {
  //   final response = await Supabase.instance.client
  //       .from('athlete_master')
  //       .select()
  //       .eq('email', username)
  //       .eq('password', password);

  //   if (response.isNotEmpty) {
  //     return true;
  //   }
  //   return false;
  // }

  Future<bool> isLoggedIn() async {
    if (_prefs == null) {
      return false;
    }
    final authToken = _prefs.getString('authToken');
    return authToken != null;
  }

  Future<void> logout() async {
    await _prefs.remove('authToken');
  }
}
