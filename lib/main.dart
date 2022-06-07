import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiresoft/inspection/record_inspection_header.dart';
import 'package:tiresoft/listInspection/list_inspecction_screen.dart';
import 'package:tiresoft/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner:
    false;

    return MaterialApp(
      title: 'Tiresoft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: const Color.fromARGB(255, 204, 204, 204)),
      home: LoginScreen(),
    );
  }
}

class ValidationSessionScreen extends StatefulWidget {
  const ValidationSessionScreen({Key? key}) : super(key: key);

  @override
  ValidationSessionScreenState createState() => ValidationSessionScreenState();
}

class ValidationSessionScreenState extends State<ValidationSessionScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;
  int userId = 0;
  String _global_id_cliente = "5";

  Future<void> _getDataSession() async {
    final SharedPreferences prefs = await _prefs;
    print('chequeame ${prefs.getInt('userId')}');
    if (prefs.getInt('userId') != 'null') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecordInspectionHeader(_global_id_cliente)),
      );
    }

    // setState(() {
    //   userId = (prefs.getInt('userId') ?? 0);
    // });
  }

  @override
  void initState() {
    _getDataSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LinearProgressIndicator());
  }
}
