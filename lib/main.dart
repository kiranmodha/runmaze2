import 'package:flutter/material.dart';
import 'package:runmaze2/presentation/home.dart';
import 'package:runmaze2/presentation/login.dart';
import 'package:runmaze2/presentation/welcome.dart';
import 'package:runmaze2/services/authservie.dart';
import 'package:runmaze2/utils/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wbceffdfjuczhuorcxkf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiY2VmZmRmanVjemh1b3JjeGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1MzgzNzAsImV4cCI6MjAyMzExNDM3MH0.gHSDpIJ9LZO9WaG-2zqKSwna6pXZVs_jwNpq2B-iKPs',
  );

  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => Settings(),
  //     child: const MyApp(),
  //   ),
  // );
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => Settings(),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Runmaze 2',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         ),
//         home: const WelcomeScreen(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'auth_service.dart';
// import 'login_page.dart';
// import 'home_page.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}
