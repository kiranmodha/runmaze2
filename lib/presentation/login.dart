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
          title: Text('Login'),
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
              SizedBox(height:20),
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text.trim();
                  String password = _passwordController.text.trim();
                  settings.login(username, password).then((loggedIn) {
                    if (loggedIn) {
                      settings.userId = username;
                      settings.loggedIn = true;
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


// Widget loginScreen(BuildContext context) {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();

//   return Consumer<Settings>(builder: (context, settings, child) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Theme.of(context).colorScheme.inversePrimary,
//           ),
//           child: Column(
//             children: <Widget>[
//               TextField(
//                 controller: usernameController,
//                 decoration: InputDecoration(labelText: 'Username'),
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   final username = usernameController.text;
//                   final password = passwordController.text;
//                   _login(context, username, password).then((success) {
//                     if (success) {
//                       settings.userId = username;
//                       settings.loggedIn = true;
//                       settings.notify();
//                     }
//                   });
//                 },
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   });
// }

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

// class LoginScreen extends StatelessWidget {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Settings>(builder: (context, settings, child) {
//       if (settings.loggedIn) {
//         // User is already logged in, navigate to home page
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.pushReplacementNamed(context, '/home');
//         });
//         return Container(); // Return empty container while navigating
//       } else {
//         return Scaffold(
//           body: Center(
//             child: Container(
//               height: 300,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Theme.of(context).colorScheme.inversePrimary,
//               ),
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     controller: usernameController,
//                     decoration: InputDecoration(labelText: 'Username'),
//                   ),
//                   TextField(
//                     controller: passwordController,
//                     decoration: InputDecoration(labelText: 'Password'),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(settings.userId),
//                   ElevatedButton(
//                     onPressed: () {
//                       final username = usernameController.text;
//                       final password = passwordController.text;
//                       _login(context, username, password).then((success) {
//                         if (success) {
//                           settings.userId = username;
//                           settings.loggedIn = true;
//                           Navigator.pushReplacementNamed(context, '/home');
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Login failed')));
//                         }
//                       });
//                     },
//                     child: const Text('Login'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   Future<bool> _login(
//       BuildContext context, String username, String password) async {
//     final response = await Supabase.instance.client
//         .from('athlete_master')
//         .select()
//         .eq('email', username)
//         .eq('password', password);
//     print(response);
//     if (response.isNotEmpty) {
//       return true;
//     }
//     return false;
//   }
// }



// class LoginPage2 extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     AuthService authService = Provider.of<AuthService>(context, listen: false);
//     authService.initPrefs(); // Initialize SharedPreferences
//
//     return FutureBuilder<bool>(
//       future: authService.isLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else {
//           final isLoggedIn = snapshot.data;
//           if (isLoggedIn!) {
//             // User is already logged in, navigate to home page
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               Navigator.pushReplacementNamed(context, '/home');
//             });
//             return Container(); // Return empty container while navigating
//           } else {
//             // User is not logged in, show login form
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('Login'),
//               ),
//               body: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextField(
//                       controller: _usernameController,
//                       decoration: const InputDecoration(labelText: 'Username'),
//                     ),
//                     TextField(
//                       controller: _passwordController,
//                       decoration: const InputDecoration(labelText: 'Password'),
//                       obscureText: true,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         String username = _usernameController.text.trim();
//                         String password = _passwordController.text.trim();
//                         authService.login(username, password).then((loggedIn) {
//                           if (loggedIn) {
//                             Navigator.pushReplacementNamed(context, '/home');
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Login failed')));
//                           }
//                         });
//                       },
//                       child: const Text('Login'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         }
//       },
//     );
//   }
// }
