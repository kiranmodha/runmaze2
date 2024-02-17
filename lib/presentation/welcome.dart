import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmaze2/presentation/home.dart';
import 'package:runmaze2/utils/settings.dart';
import 'package:runmaze2/presentation/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      if (settings.loggedIn) {
        return const Home();
      } else if (settings.loggedIn == false) {
        return  LoginScreen();
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
  //  => Scaffold(
  //       body: StreamBuilder(
  //         stream: FirebaseAuth.instance.authStateChanges(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return buildLoading();
  //           } else if (snapshot.hasError) {
  //             return const Center(child: Text('Something went wrong'));
  //           } else if (snapshot.hasData) {
  //             return const Home(); // If user is signed in already, show home screen
  //           } else {
  //             return const WelcomeScreen(); // If user is not signed in, show sign in screen
  //           }
  //         },
  //       ),
  //     );

  // Widget buildLoading() => const Center(child: CircularProgressIndicator());
}
