import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:runmaze2/model/athlete.dart';
import 'package:runmaze2/presentation/home.dart';
import 'package:runmaze2/presentation/login.dart';
import 'package:runmaze2/utils/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up Hive Database
  await Hive.initFlutter();
  Hive.registerAdapter(AthleteAdapter());
  // ignore: unused_local_variable
  var athleteBox = await Hive.openBox<Athlete>('athletes');

  // Set up Supabase
  await Supabase.initialize(
    url: 'https://wbceffdfjuczhuorcxkf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiY2VmZmRmanVjemh1b3JjeGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1MzgzNzAsImV4cCI6MjAyMzExNDM3MH0.gHSDpIJ9LZO9WaG-2zqKSwna6pXZVs_jwNpq2B-iKPs',
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => Settings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // create: (context) => AuthService(),
      create: (context) => Settings(),
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
