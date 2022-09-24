import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiresoft/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 4000),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity * 0.1,
        child: Container(
          color: Color(0xff17202A),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              SizedBox(
                height: 153,
              ),
              Image.asset(
                'assets/ic_tiresoft_splash.png',
                width: 166,
              ),
              Spacer(),
              SpinKitSpinningLines(
                color: Colors.blueGrey,
                size: 50.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "© tiresoft.pe",
                style: TextStyle(
                  fontSize: 11.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
