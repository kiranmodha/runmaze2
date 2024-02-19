import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/utils/settings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _initialized = false;
  late Settings _settings;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    _settings = Provider.of<Settings>(context, listen: false);
    await _settings.init();
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // Show a loading indicator or placeholder widget while initializing
      return CircularProgressIndicator();
    }

    if (_settings.loggedIn) {
      // User is already logged in, navigate to home page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
      return Container(); // Return empty container while navigating
    } else {
      // Show login form if user is not logged in
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
                  _settings
                      .loginFromLocalDb(username, password)
                      .then((loggedIn) {
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

//
// class LoginPage extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Future<Widget> build(BuildContext context) async {
//     Settings settings = Provider.of<Settings>(context);
//     settings.init();
//     if (settings.loggedIn) {
//       // User is already logged in, navigate to home page
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacementNamed(context, '/home');
//       });
//       return Container(); // Return empty container while navigating
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Login'),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(labelText: 'Username'),
//               ),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   String username = _usernameController.text.trim();
//                   String password = _passwordController.text.trim();
//                   settings.loginFromLocalDb(username, password).then((loggedIn) {
//                     if (loggedIn) {
//                       Navigator.pushReplacementNamed(context, '/home');
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Login failed')));
//                     }
//                   });
//                 },
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }

//-----
// class YourWidget extends StatefulWidget {
//   @override
//   _YourWidgetState createState() => _YourWidgetState();
// }

// class _YourWidgetState extends State<YourWidget> {
//   bool _initialized = false;
//   late Settings _settings;
//
//   @override
//   void initState() {
//     super.initState();
//     _initSettings();
//   }
//
//   Future<void> _initSettings() async {
//     _settings = Provider.of<Settings>(context, listen: false);
//     await _settings.init();
//     setState(() {
//       _initialized = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_initialized) {
//       // Show a loading indicator or placeholder widget while initializing
//       return CircularProgressIndicator();
//     }
//
//     if (_settings.loggedIn) {
//       // Return your widget tree if user is logged in
//       return YourLoggedInWidget();
//     } else {
//       // Return your widget tree if user is not logged in
//       return YourLoggedOutWidget();
//     }
//   }
// }
