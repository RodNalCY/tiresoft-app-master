import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetResumenRetiro extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetResumenRetiro(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetResumenRetiro> createState() => _WidgetResumenRetiroState();
}

class _WidgetResumenRetiroState extends State<WidgetResumenRetiro> {
  late Future<List> neumaticos_resumen_retiro;
  List _resumen_retiro = [];
  double unityHeight = 35;
  double unityRowHeight = 25;

  late bool exits_data;
  late String txt_title = "Resumen de neumáticos en retiro";

  final columns = [
    'Vehículo',
    'POS',
    'Marca',
    'Medidas',
    'Modelo',
    'Estado',
    'Serie',
    'Interior',
    'Exterior',
    'NSD',
    'Recomendación'
  ];

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/resumen_neumaticos_retiro"),
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

    _resumen_retiro = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _resumen_retiro = jsonData['success']['datos'];
      }
      return _resumen_retiro;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    neumaticos_resumen_retiro = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    neumaticos_resumen_retiro = cargarDatos();

    return Center(
      child: FutureBuilder<List>(
        future: neumaticos_resumen_retiro,
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
                        Container(
                          child: DataTable(
                            // dataRowHeight: unityRowHeight,
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
                                          width: 100.0,
                                          child: Text(
                                            data["placa"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 20.0,
                                          child: Text(
                                            data["posicion"].toString(),
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
                                          width: 100,
                                          child: Text(
                                            data["medida"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Text(
                                            data["modelo"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 10.0,
                                          child: Text(
                                            data["estado"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Text(
                                            data["num_serie"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Text(
                                            data["interior"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Text(
                                            data["exterior"].toString(),
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
                                          width: 100.0,
                                          child: Text(
                                            data["recomendacion"].toString(),
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
