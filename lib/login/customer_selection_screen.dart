import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tiresoft/inspection/record_inspection_header.dart';

class CustomerSelectionScreen extends StatefulWidget {
  final String title = 'Seleccionar cliente';

  State<StatefulWidget> createState() => _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _slugDatabase = "CONCREMAX";

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // Toggles the password show status

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setState(() {});
  }

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
                    Center(
                        child: Text("Por favor seleccione un cliente",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff2874A6)))),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: DropdownButton<String>(
                          value: _slugDatabase.toString(),
                          items: <String>['CONCREMAX', 'CONCRETERAS']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: Color(0xff2874A6),
                                      fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          onChanged: (_val) {
                            setState(() {
                              _slugDatabase = _val.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                    ),
                    Center(
                      child: FlatButton(
                          padding: EdgeInsets.only(right: 45.0, left: 45.0),
                          child: Text('Seleccionar'),
                          color: Color(0xff212F3D),
                          textColor: Colors.white,
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RecordInspectionHeader(
                                            slugDatabase: _slugDatabase,
                                          )),
                                )
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        )));
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
