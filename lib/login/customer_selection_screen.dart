import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/home.dart';
import 'dart:convert';
import 'package:tiresoft/inspection/record_inspection_header.dart';
import 'package:tiresoft/login/models/cliente.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';

class CustomerSelectionScreen extends StatefulWidget {
  final String title = 'Seleccionar cliente';
  List<Cliente> _cliente;
  List<User> _user;

  CustomerSelectionScreen(this._user, this._cliente, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _global_id_cliente = "";

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // Toggles the password show status

  Map<String, String> listarClienteMap = {};
  String _dropdownFirsValue = "";

  void cargarMapClientes() {
    // print("cargarMapClientes()");
    for (var item in widget._cliente) {
      listarClienteMap[item.c_id.toString()] = item.c_razon_social;
    }
    _dropdownFirsValue =
        listarClienteMap[widget._cliente[0].c_id.toString()].toString();
  }

  String obtenerIdCliente() {
    var usdKey = listarClienteMap.keys.firstWhere(
        (K) => listarClienteMap[K] == _dropdownFirsValue,
        orElse: () => "");
    return usdKey;
  }

  @override
  void initState() {
    cargarMapClientes();
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setState(() {});
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
    _global_id_cliente = obtenerIdCliente();
    // print("Cod: " + _global_id_cliente);

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
                  image: AssetImage('assets/fondo-login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              height: 470,
              margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(left: 15.0, right: 15.0, top: 50.0),
                      decoration: BoxDecoration(
                          color: Color(0xff212F3D),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Image(
                        image: new AssetImage('assets/ic_logo.png'),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    Center(
                        child: Text("Por favor seleccione un cliente",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff2874A6)))),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                          child: DropdownButton<String>(
                        value: _dropdownFirsValue,
                        icon: const Icon(Icons.unfold_more,
                            color: Color(0xff2874A6)),
                        elevation: 16,
                        style: const TextStyle(
                            color: Color(0xff2874A6),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                        underline: Container(
                          height: 1,
                          color: Color(0xff2874A6),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownFirsValue = newValue!;
                          });
                        },
                        items: listarClienteMap.values
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(right: 45.0, left: 45.0),
                          onPrimary: Colors.white,
                          primary: Color(0xff212F3D),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                        onPressed: () async {
                          // print("Send Id: " + _global_id_cliente),
                          // print("Send NAME: " + _dropdownFirsValue),
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(_global_id_cliente,
                                    widget._user, _dropdownFirsValue)),
                          );
                        },
                        child: Text('Seleccionar'),
                      ),
                    ),
                    // Center(
                    //   child: FlatButton(
                    //       padding: EdgeInsets.only(right: 45.0, left: 45.0),
                    //       child: Text('Seleccionar'),
                    //       color: Color(0xff212F3D),
                    //       textColor: Colors.white,
                    //       onPressed: () => {
                    //             // print("Send Id: " + _global_id_cliente),
                    //             // print("Send NAME: " + _dropdownFirsValue),
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => Home(
                    //                       _global_id_cliente,
                    //                       widget._user,
                    //                       _dropdownFirsValue)),
                    //             )
                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //       builder: (context) =>
                    //             //           RecordInspectionHeader(
                    //             //             _global_id_cliente,
                    //             //           )),
                    //             // )

                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //       builder: (context) => CustomDrawer(
                    //             //             _global_id_cliente,
                    //             //           )),
                    //             // )
                    //           }),
                    // ),
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
