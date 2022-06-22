import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:tiresoft/inspection/models/vehicle.dart';
import 'package:tiresoft/inspection/record_inspection_detail.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiresoft/inspection/record_inspection_header.dart';
import 'package:tiresoft/login/customer_selection_screen.dart';
import 'package:tiresoft/login/models/cliente.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tiresoft/login/models/user.dart';

class LoginScreen extends StatefulWidget {
  final String title = 'Registration';

  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // obtain shared preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _userEmail = "";
  bool _obscureText = true;
  String? selectedLetter;
  int? selectedId;
  final format = DateFormat("yyyy-MM-dd");
  var vehicles = [];
  final List<String> letters = [];
  List<Cliente> _cliente = [];
  List<User> _user = [];

  var data;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // Toggles the password show status

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //_pageController = PageController();
    _emailController.text = "rcabello@gestorestecnologicos.com";
    // _passwordController.text = "123456";
    setState(() {});
  }

  Future<String> login() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/login/authenticateSimplified"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      final SharedPreferences prefs = await _prefs;
      prefs.setInt('role', jsonData['success']['role']);
      prefs.setInt('userId', jsonData['success']['userId']);
      print(jsonData['success']['nombres']);

      _user.add(User(
          jsonData['success']['userId'],
          jsonData['success']['nombres'],
          jsonData['success']['apellidos'],
          jsonData['success']['email'],
          jsonData['success']['telefono'],
          jsonData['success']['role'].toString(),
          jsonData['success']['role_name'].toString(),
          "assets/persona.png",
          jsonData['success']['img_firma'],
          jsonData['success']['created_at']));

      for (var item in jsonData['success']['clientes']) {
        _cliente.add(Cliente(item["id"], item["ruc"], item["razon_social"]));
      }
      onSuccess();
      return 'succcess';
    } else {
      onError();
      return 'error';
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeScaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
            child: SingleChildScrollView(
          child: Stack(clipBehavior: Clip.none, children: <Widget>[
            // IMAGEN DE FONDO DEL LOGIN CON FACEBOOK GOOGLE

            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo-1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              height: 610,
              margin: EdgeInsets.fromLTRB(10, 100, 10, 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Image(
                        image: new AssetImage('assets/ic_logo.png'),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                          child: Text(
                              "Por favor ingrese la siguiente sus credenciales.",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xff2874A6)))),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _passwordController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35.0),
                    ),
                    Center(
                      child: RaisedButton(
                        padding: EdgeInsets.only(right: 45.0, left: 45.0),
                        child: isLoading
                            ? Transform.scale(
                                scale: 0.6,
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 5.0),
                              )
                            : Text("Login"),
                        color: Color(0xff212F3D),
                        textColor: Colors.white,
                        onPressed: () async => {
                          setState(() {
                            isLoading = true;
                          }),
                          login().then((value) async => {
                                if (value == "succcess")
                                  {
                                    // print("SUCCESS LOGIN"),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerSelectionScreen(
                                                  _user, _cliente)),
                                    ),
                                    setState(() {
                                      isLoading = false;
                                    })
                                  }
                                else
                                  {
                                    await Future.delayed(Duration(seconds: 1)),
                                    setState(() {
                                      isLoading = false;
                                    })
                                  }
                              })
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered))
                                      return Colors.blue.withOpacity(0.04);
                                    if (states
                                            .contains(MaterialState.focused) ||
                                        states.contains(MaterialState.pressed))
                                      return Colors.blue.withOpacity(0.12);
                                    return null; // Defer to the widget's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                recoveryPassword();
                              },
                              child: Text('¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                      color: Color(0xff2874A6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0)))),
                    )
                  ],
                ),
              ),
            ),
          ]),
        )));
  }

  void recoveryPassword() async {
    const String _url = 'https://tiresoft.pe/login/index';
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login exitoso")),
    );
  }

  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Credenciales Incorrectas")),
    );
  }
}

//keytool -exportcert -alias androiddebugkey -keystore "C:\Users\ACER-OPTANE\keystores\upload-keysores.jks" | "C:\openssl\bin\openssl" sha1 -binary | "C:\openssl\bin\openssl" base64
//keytool -exportcert -alias androiddebugkey -keystore "C:\Usuarios\ACER-OPTANE\.android\debug.keystore" | "C:\openssl\bin\openssl" sha1 -binary | "C:\openssl\bin\openssl" base64

//keytool -exportcert -alias YOUR_RELEASE_KEY_ALIAS -keystore YOUR_RELEASE_KEY_PATH | openssl sha1 -binary | openssl base64