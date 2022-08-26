import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetEquiposInspeccionados extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetEquiposInspeccionados(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetEquiposInspeccionados> createState() =>
      _WidgetEquiposInspeccionadosState();
}

class _WidgetEquiposInspeccionadosState
    extends State<WidgetEquiposInspeccionados> {
  late Future<List> equipos_inspeccionados;
  List _equipos = [];
  double unityHeight = 35;
  double unityRowHeight = 25;
  late bool exits_data;
  late String txt_title = "Equipos Inspeccionados";
  final columns = [
    'Tipo',
    'Marca',
    'Modelo',
    'Delantero',
    'Posterior',
    'Total'
  ];

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/equipos_inspeccionados"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget.cliente,
        'month1': widget.mes_inicio,
        'month2': widget.mes_fin,
        'year': widget.anio,
      }),
    );

    _equipos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _equipos = jsonData['success']['datos'];
      }
      return _equipos;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    equipos_inspeccionados = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    equipos_inspeccionados = cargarDatos();

    return Center(
      child: FutureBuilder<List>(
        future: equipos_inspeccionados,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            txt_title,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        headerRowOne(),
                        Container(
                          child: DataTable(
                            dataRowHeight: unityRowHeight,
                            headingRowHeight: unityHeight,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            border:
                                TableBorder.all(color: Colors.blue.shade100),
                            columns: getColumnsTwo(columns),
                            rows: snapshot.data!
                                .map(
                                  (data) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Container(
                                          width: 70.0,
                                          child: Text(
                                            data["nomtipo"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Text(
                                            data["marca"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 160,
                                          child: Text(
                                            data["modelo"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100,
                                          child: Text(
                                            data["medidaDelanteros"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Text(
                                            data["medidaPosteriores"]
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 20.0,
                                          child: Text(
                                            data["total_neumaticos"].toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
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

  List<DataColumn> getColumnsTwo(List<String> columns) {
    return columns
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

  Container headerRowOne() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 494,
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
            width: 396,
            height: unityHeight,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Neumático',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
