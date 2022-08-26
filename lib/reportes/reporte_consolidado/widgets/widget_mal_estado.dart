import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WidgetMalEstado extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetMalEstado(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetMalEstado> createState() => _WidgetMalEstadoState();
}

class _WidgetMalEstadoState extends State<WidgetMalEstado> {
  late Future<List> neumaticos_mal_estado;
  List _mal_estado = [];
  double unityHeight = 35;
  double unityRowHeight = 25;

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
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      _mal_estado = jsonData['success']['datos'];
      // print(_mal_estado);
      return _mal_estado;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    neumaticos_mal_estado = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    neumaticos_mal_estado = cargarDatos();

    return Center(
      child: FutureBuilder<List>(
        future: neumaticos_mal_estado,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            return Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Resumen de neumáticos en mal Estado",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          child: DataTable(
                            // dataRowHeight: unityRowHeight * 2.5,
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
                                          width: 80.0,
                                          child: Text(
                                            data["placa"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Text(
                                            data["neumatico_posicion"]
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 80,
                                          child: Text(
                                            data["eje"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100,
                                          child: Text(
                                            data["marca"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Text(
                                            data["medida"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Text(
                                            "-",
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
                                          width: 80.0,
                                          child: Text(
                                            data["disenio"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 80.0,
                                          child: Text(
                                            data["serieneumatico"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Text(
                                            data["nsd"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 200.0,
                                          child: Text(
                                            data["observaciones"].toString(),
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
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(10.0),
              child: const SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
                height: 30.0,
                width: 30.0,
              ),
            );
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
