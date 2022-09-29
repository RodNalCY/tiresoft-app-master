import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetMalEstado extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetMalEstado(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetMalEstado> createState() => _WidgetMalEstadoState();
}

class _WidgetMalEstadoState extends State<WidgetMalEstado> {
  late bool refreshing = false;

  late Future<List> neumaticos_mal_estado;
  List _mal_estado = [];
  double unityHeight = 35;
  double unityRowHeight = 120.0;

  late bool exits_data;
  late String txt_title = "Resumen de neumáticos en mal Estado";

  final columns = [
    'Placa',
    'Posición',
    'Eje',
    'Marca',
    'Medida',
    'Modelo',
    'Estado',
    'Diseño',
    'Serie',
    'NSD',
    'Observaciones',
    'Imagen',
  ];

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/resumen_neumaticos_mal_estado"),
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

    _mal_estado = [];
    print('5-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print('5-jsonDecode > ${jsonData}');
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _mal_estado = jsonData['success']['datos'];
      }
      return _mal_estado;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    neumaticos_mal_estado = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      neumaticos_mal_estado = cargarDatos();
      print("5-Se ejecuta");
      refreshing = false;
    } else {
      print("5-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List>(
        future: neumaticos_mal_estado,
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
                        Container(
                          child: DataTable(
                            dataRowHeight: unityRowHeight,
                            headingRowHeight: unityHeight,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            border:
                                TableBorder.all(color: Colors.blue.shade100),
                            columns: getHeadersColumns(columns),
                            rows: snapshot.data!
                                .map(
                                  (data) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Container(
                                          // width: 80.0,
                                          child: Center(
                                            child: Text(
                                              data["placa"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 20.0,
                                          child: Center(
                                            child: Text(
                                              data["neumatico_posicion"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 80,
                                          child: Center(
                                            child: Text(
                                              data["eje"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 100,
                                          child: Center(
                                            child: Text(
                                              data["marca"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["medida"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["modelo"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 200.0,
                                          child: Text(
                                            data["estado"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 80.0,
                                          child: Center(
                                            child: Text(
                                              data["disenio"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 80.0,
                                          child: Center(
                                            child: Text(
                                              data["serieneumatico"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["nsd"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          // width: 200.0,
                                          child: Center(
                                            child: Text(
                                              data["observaciones"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: EdgeInsets.all(5.0),
                                            width: 200.0,
                                            height: 400.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://tiresoft2.lab-elsol.com/" +
                                                        data["ruta1"]
                                                            .toString(),
                                                  ),
                                                  fit: BoxFit.cover),
                                            ),
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

  List<DataColumn> getHeadersColumns(List<String> columns) {
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
}
