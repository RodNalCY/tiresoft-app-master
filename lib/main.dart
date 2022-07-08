import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tiresoft/login/login_screen.dart';
import 'package:tiresoft/navigation/provider/navigation_change_provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.top]);

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarBrightness: Brightness.light));

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));

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
    print("1-Method initState()");
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    print("3-Method deactivate()");
  }

  @override
  void dispose() {
    super.dispose();
    print("4-Method dispose()");
  }

  @override
  Widget build(BuildContext context) {
    print("2-Method build()");
    return LoginScreen();
  }
}
