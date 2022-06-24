import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tiresoft/inspeccion/list_inspeccion.dart';
import 'package:tiresoft/inspection/record_inspection_header.dart';
import 'package:tiresoft/login/login_screen.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/header_drawer_page.dart';
import 'package:tiresoft/navigation/models/navigation_item_model.dart';
import 'package:tiresoft/navigation/provider/navigation_change_provider.dart';
import 'package:tiresoft/neumaticos/list_neumaticos.dart';
import 'package:tiresoft/scrap/list_scrap.dart';
import 'package:tiresoft/scrap/record_scrap_screen.dart';
import 'package:tiresoft/scrap/scrap_register_home.dart';
import 'package:tiresoft/vehiculos/list_vehiculos.dart';

class Home extends StatefulWidget {
  String _global_cliente_id;
  String _global_cliente_name;
  List<User> _user;
  Home(this._global_cliente_id, this._user, this._global_cliente_name,
      {Key? key})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return buildPagesApp();
  }

  Widget buildPagesApp() {
    // widget._global_cliente_id = "5";
    print("> id: " + widget._global_cliente_id);
    print("> Name: " + widget._global_cliente_name);
    print("> User:");
    for (var element in widget._user) {
      print(element.u_firma);
    }

    final provider = Provider.of<NavigationChangeProvider>(context);
    final navigationItem = provider.navigationItemModel;
    switch (navigationItem) {
      case NavigationItemModel.header:
        return HeaderDrawerPage(widget._user, widget._global_cliente_name);
      case NavigationItemModel.registro_inspeccion:
        return RecordInspectionHeader(widget._global_cliente_id, widget._user,
            widget._global_cliente_name);
      case NavigationItemModel.reporte_inspeccion:
        return ListInspeccion(widget._global_cliente_id, widget._user,
            widget._global_cliente_name);
      case NavigationItemModel.reporte_vehiculo:
        return ListVehiculos(widget._global_cliente_id, widget._user,
            widget._global_cliente_name);
      case NavigationItemModel.reporte_neumatico:
        return ListNeumaticos(widget._global_cliente_id, widget._user,
            widget._global_cliente_name);
      case NavigationItemModel.register_scrap_home:
        // return RecordScrapScreen(widget._global_cliente_id, widget._user,
        //     widget._global_cliente_name);
        return ScrapRegisterHome(widget._global_cliente_id, widget._user,
            widget._global_cliente_name);
      case NavigationItemModel.reporte_scrap:
        return ListScrap(widget._global_cliente_id, widget._user,
            widget._global_cliente_name);
      case NavigationItemModel.login:
        return LoginScreen();
      case NavigationItemModel.salir:
        return closeApp();
    }
  }

  Widget closeApp() {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Container(
        color: Colors.white,
        child: Container(
          color: Color(0xff212F3D),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 6.0,
                  backgroundColor: Colors.blueGrey[100],
                ),
                SizedBox(height: 20.0),
                Text(
                  "...Cerrando...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      exit(0);
    }
  }
}
