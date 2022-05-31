import 'package:flutter/material.dart';
import 'package:tiresoft/inspection/record_inspection_header.dart';
import 'package:tiresoft/listInspection/list_inspecction_screen.dart';
import 'package:tiresoft/neumaticos/list_neumaticos.dart';
import 'package:tiresoft/scrap/list_tire_scrap_screen.dart';
import 'package:tiresoft/scrap/record_scrap_screen.dart';
import 'package:tiresoft/vehiculos/list_vehiculos.dart';

class CustomDrawer extends StatelessWidget {
  final String _g_id_cliente = "5";

  // const CustomDrawer(this._g_id_cliente, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/tiresoft-background.jpg'))),
              child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500))),
              ])),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.control_point),
              title: const Text('Registrar Inspección'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecordInspectionHeader(
                            slugDatabase: 'tenant2',
                          )),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: const Text('Reporte Inspección'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ListInspectionScreen(_g_id_cliente)),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.toys),
              title: const Text('Reporte Vehiculos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListVehiculos(_g_id_cliente)),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.data_saver_off),
              title: const Text('Reporte Neumáticos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListNeumaticos(_g_id_cliente)),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.control_point),
              title: const Text('Asignar Neumatico a Scrap'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecordScrapScreen(
                            slugDatabase: 'tenant2',
                          )),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: const Text('Neumaticos en Scrap'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListTireScrapScreen(_g_id_cliente)),
                );
              },
            ),
          ),
          Expanded(child: Container()),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            width: double.infinity,
            color: Color(0xff212F3D),
            child: ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: const Text('Cerrar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      ),
    );
  }
}
