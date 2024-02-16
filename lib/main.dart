import 'package:flutter/material.dart';
import 'package:runmaze2/presentation/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:runmaze2/presentation/home.dart';

// Hello

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wbceffdfjuczhuorcxkf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiY2VmZmRmanVjemh1b3JjeGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1MzgzNzAsImV4cCI6MjAyMzExNDM3MH0.gHSDpIJ9LZO9WaG-2zqKSwna6pXZVs_jwNpq2B-iKPs',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:runmaze2/model/workout.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Supabase.initialize(
//     url: 'https://wbceffdfjuczhuorcxkf.supabase.co',
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiY2VmZmRmanVjemh1b3JjeGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDc1MzgzNzAsImV4cCI6MjAyMzExNDM3MH0.gHSDpIJ9LZO9WaG-2zqKSwna6pXZVs_jwNpq2B-iKPs',
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   final client = Supabase.instance.client;

//   void _incrementCounter() {
//     _getLatestWorkouts();
//     setState(() {
//       _counter++;
//     });
//   }

//   void _getData() async {
//     final data = await client.from("club_master").select();
//     print(data);
//   }

//   void _getLatestWorkouts() async {
//     final response = await client
//         .from('workout')
//         .select()
//         .eq('athlete_id', 33) // added where condition
//         .order('workout_date', ascending: false)
//         .limit(2);

//     Workouts workouts = Workouts.fromMapList(response);
//     print(workouts.workoutList.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
