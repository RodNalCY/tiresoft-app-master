import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiresoft/inspeccion/list_inspeccion.dart';
import 'package:tiresoft/inspection/record_inspection_header.dart';
import 'package:tiresoft/login/login_screen.dart';
import 'package:tiresoft/navigation/header_drawer_page.dart';
import 'package:tiresoft/navigation/models/navigation_item_model.dart';
import 'package:tiresoft/navigation/provider/navigation_change_provider.dart';
import 'package:tiresoft/neumaticos/list_neumaticos.dart';
import 'package:tiresoft/scrap/list_scrap.dart';
import 'package:tiresoft/scrap/record_scrap_screen.dart';
import 'package:tiresoft/vehiculos/list_vehiculos.dart';

class Home extends StatefulWidget {
  String _global_cliente_id;
  Home(this._global_cliente_id, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return buildPagesApp();
  }

  Widget buildPagesApp() {
    // widget._global_cliente_id = "5";
    print(">id: " + widget._global_cliente_id);
    final provider = Provider.of<NavigationChangeProvider>(context);
    final navigationItem = provider.navigationItemModel;
    switch (navigationItem) {
      case NavigationItemModel.header:
        return HeaderDrawerPage();
      case NavigationItemModel.registro_inspeccion:
        return RecordInspectionHeader(widget._global_cliente_id);
      case NavigationItemModel.reporte_inspeccion:
        return ListInspeccion(widget._global_cliente_id);
      case NavigationItemModel.reporte_vehiculo:
        return ListVehiculos(widget._global_cliente_id);
      case NavigationItemModel.reporte_neumatico:
        return ListNeumaticos(widget._global_cliente_id);
      case NavigationItemModel.asignar_neumatico_scrap:
        return RecordScrapScreen(widget._global_cliente_id);
      case NavigationItemModel.reporte_scrap:
        return ListScrap(widget._global_cliente_id);
      case NavigationItemModel.login:
        return LoginScreen();
      case NavigationItemModel.salir:
        return LoginScreen();
    }
  }
}
