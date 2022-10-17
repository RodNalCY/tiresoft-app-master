import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetServicioReencauche extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetServicioReencauche(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetServicioReencauche> createState() =>
      _WidgetServicioReencaucheState();
}

class _WidgetServicioReencaucheState extends State<WidgetServicioReencauche> {
  late bool refreshing = false;

  late Future<List> servicio_reencauche;
  List _reencauches = [];
  double unityHeight = 35;
  double unityRowHeight = 25;

  late bool exits_data;
  late String txt_title = "Neumáticos para servicio de reencauche";
  late String total_data;
  final columns = [
    'Vehículo',
    'POS',
    'Marca',
    'Medidas',
    'Modelo',
    'Estado',
    'Serie',
    'Interior',
    'Medio',
    'Exterior',
    'NSD',
    'Observaciones'
  ];

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/resumen_neumaticos_servicio_reencauche"),
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

    _reencauches = [];
    total_data = "";
    int sumar = 0;
    print('15-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _reencauches = jsonData['success']['datos'];
        sumar = (jsonData['success']['resumen']['proximosreencauchar'] +
            jsonData['success']['resumen']['reuncauchar']);
        total_data = sumar.toString();
      }
      return _reencauches;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    servicio_reencauche = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      servicio_reencauche = cargarDatos();
      print("15-Se ejecuta");
      refreshing = false;
    } else {
      print("15-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List>(
        future: servicio_reencauche,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total_data,
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
                            columnSpacing: 10,
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
                                        Text(
                                          data["placa"].toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            data["posicion"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          data["marca"].toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          data["medida"].toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          data["modelo"].toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            data["estado"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          data["num_serie"].toString(),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            data["interior"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            data["medio"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            data["exterior"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            data["nsd"].toString(),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          data["recomendacion"].toString(),
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
