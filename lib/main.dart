import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiresoft/login/login_screen.dart';
import 'package:tiresoft/navigation/provider/navigation_change_provider.dart';

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

    return ChangeNotifierProvider(
      create: (context) => NavigationChangeProvider(),
      child: MaterialApp(
        title: 'Tiresoft',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: const Color.fromARGB(255, 204, 204, 204)),
        home: const ValidationSessionScreen(),
      ),
    );
  }
}

class ValidationSessionScreen extends StatefulWidget {
  const ValidationSessionScreen({Key? key}) : super(key: key);

  @override
  State<ValidationSessionScreen> createState() =>
      _ValidationSessionScreenState();
}

class _ValidationSessionScreenState extends State<ValidationSessionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
