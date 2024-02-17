import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/utils/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return Scaffold(
        body: Center(
          child: Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Text(settings.userId),
                ElevatedButton(
                  onPressed: () {
                    final username = usernameController.text;
                    final password = passwordController.text;
                    _login(context, username, password).then((success) {
                      if (success) {
                        settings.userId = username;
                        settings.loggedIn = true;
                        settings.notify();
                        print(username);
                      
                      }
                    });
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<bool> _login(
      BuildContext context, String username, String password) async {
    final response = await Supabase.instance.client
        .from('athlete_master')
        .select()
        .eq('email', username)
        .eq('password', password);
    print(response);
    if (response.isNotEmpty) {
      return true;
    }
    return false;
  }
}
