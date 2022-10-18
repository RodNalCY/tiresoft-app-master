import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetRemanenteUnidad extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetRemanenteUnidad(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetRemanenteUnidad> createState() => _WidgetRemanenteUnidadState();
}

class _WidgetRemanenteUnidadState extends State<WidgetRemanenteUnidad> {
  // static const DataCell empty = DataCell(SizedBox(width: 0.0, height: 0.0));
  static const DataCell empty = DataCell(Center(
    child: Text("-"),
  ));
  late bool refreshing = false;
  late Future<List> remanente_unidad;
  List _remanentes = [];
  double unityHeight = 35;
  double unityRowHeight = 25;
  late bool exits_data;
  late String txt_title = "Niveles de remanente por unidad";

  // List<String> columns = [
  //   'Vehículo',
  //   'Placa',
  //   '1',
  //   '2',
  //   '3',
  //   '4',
  //   '5',
  //   '6',
  //   '7',
  //   '8',
  //   '9',
  //   '10',
  //   '11',
  //   '12',
  //   '13',
  //   '14',
  //   '15',
  //   '16',
  //   '17',
  //   '18',
  //   '19',
  //   '20',
  //   '21',
  //   '22',
  //   'Total',
  //   'Reencauchar',
  //   'Próx a Reenc'
  // ];

  List<String> columns_dynamic = [];

  late int total_neumaticos;
  late int total_reencauchar;
  late double percent_reencauchar;
  late int total_prox_reencauchar;
  late double percent_prox_reencauchar;

  late int aplicacion_rem_reencauche;
  late int aplicacion_rem_proximo;

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/niveles_remanente_unidad"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget.cliente,
        'month1': widget.mes_inicio,
        'month2': widget.mes_fin,
        'year': widget.anio,
        'proyecto': 'movil',
      }),
    );

    _remanentes = [];
    columns_dynamic = [];
    aplicacion_rem_reencauche = 0;
    aplicacion_rem_proximo = 0;

    total_neumaticos = 0;
    total_reencauchar = 0;
    total_prox_reencauchar = 0;
    percent_reencauchar = 0.0;
    percent_prox_reencauchar = 0.0;
    double r1_temporal = 0.0;
    double r2_temporal = 0.0;

    print('16-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _remanentes = jsonData['success']['datos'];

        for (var data in jsonData['success']['aplicaciones']) {
          r1_temporal = double.parse(data['rem_reencauche'].toString());
          r2_temporal = double.parse(data['rem_proximo'].toString());
        }

        aplicacion_rem_reencauche = r1_temporal.round();
        aplicacion_rem_proximo = r2_temporal.round();

        total_neumaticos = jsonData['success']['resumen']['total_neumaticos'];
        total_reencauchar =
            jsonData['success']['resumen']['total_neumaticos_reencauchar'];
        total_prox_reencauchar =
            jsonData['success']['resumen']['neumaticos_proximos_reencauchar'];

        percent_reencauchar = (total_reencauchar / total_neumaticos) * 100;
        percent_prox_reencauchar =
            (total_prox_reencauchar / total_neumaticos) * 100;

        columns_dynamic.add('Vehículo');
        columns_dynamic.add('Placa');

        for (var element in jsonData['success']['posiciones']) {
          columns_dynamic.add(element.toString());
        }

        columns_dynamic.add('Total');
        columns_dynamic.add('Reencauchar');
        columns_dynamic.add('Próx. a Reenc.');
      }
      return _remanentes;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    remanente_unidad = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      remanente_unidad = cargarDatos();
      print("16-Se ejecuta");
      refreshing = false;
    } else {
      print("16-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List>(
        future: remanente_unidad,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title,
                widget: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerRow(),
                        Container(
                          child: DataTable(
                            dataRowHeight: unityRowHeight,
                            headingRowHeight: unityHeight,
                            columnSpacing: 15.0,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            border:
                                TableBorder.all(color: Colors.blue.shade100),
                            columns: getColumnsTwo(columns_dynamic),
                            rows: [
                              for (var row in snapshot.data!) ...[
                                DataRow(
                                  cells: <DataCell>[
                                    for (var item in row) ...[
                                      nsdDataCell(item)
                                    ],
                                  ],
                                )
                              ],
                            ],
                          ),
                        ),
                        footerRowOne(),
                        footerRowTwo()
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return WidgetNotData(title: txt_title + "\nTotal : 0");
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }

  DataCell nsdDataCell(nsd) {
    if (nsd.runtimeType == int) {
      String str_value = nsd.toString();
      int int_value = int.parse(str_value);
      return DataCell(
        Container(
          color: getNSDColor(int_value),
          padding: EdgeInsets.all(5),
          // width: 28,
          child: Center(
            child: Text(
              int_value.toString(),
              style: TextStyle(
                color: getTextColor(int_value),
              ),
            ),
          ),
        ),
      );
    } else {
      String str_nsd = nsd.toString();
      return DataCell(
        Container(
          color: Colors.transparent,
          // padding: EdgeInsets.all(5),
          // width: 28,
          child: Center(
            child: Text(
              str_nsd,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
  }

  Color getNSDColor(int nsd) {
    Color color;
    if (nsd >= aplicacion_rem_proximo && nsd <= aplicacion_rem_proximo + 1) {
      color = Colors.blue;
    } else if (nsd <= aplicacion_rem_reencauche) {
      color = Colors.yellow;
    } else {
      color = Colors.transparent;
    }
    return color;
  }

  Color getTextColor(int nsd) {
    Color color;
    if (nsd >= aplicacion_rem_proximo && nsd <= aplicacion_rem_proximo + 1) {
      color = Colors.white;
    } else if (nsd <= aplicacion_rem_reencauche) {
      color = Colors.black;
    } else {
      color = Colors.black54;
    }
    return color;
  }

  List<DataColumn> getColumnsTwo(List<String> _columns) {
    // print('_columns > ${_columns}');
    return _columns
        .map(
          (String column) => DataColumn(
            label: Expanded(
              child: Text(
                column,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
        .toList();
  }

  Container headerRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 139,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Equipo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 492,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Posiciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 47,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 221,
            height: unityHeight,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Para Reemplazar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container footerRowOne() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 630,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 47,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                total_neumaticos.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 98,
            height: unityHeight,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                total_reencauchar.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 123,
            height: unityHeight,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                total_prox_reencauchar.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container footerRowTwo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 630,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Porcentaje (%)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 47,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 98,
            height: unityHeight,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                percent_reencauchar.toStringAsFixed(1) + " %",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 123,
            height: unityHeight,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                percent_prox_reencauchar.toStringAsFixed(1) + " %",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
