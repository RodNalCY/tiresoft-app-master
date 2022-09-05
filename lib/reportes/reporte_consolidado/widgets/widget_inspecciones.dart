import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetInspecciones extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetInspecciones(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetInspecciones> createState() => _WidgetInspeccionesState();
}

class _WidgetInspeccionesState extends State<WidgetInspecciones> {
  late bool refreshing = false;

  late Future<List> inspecciones;
  List _inpeccion = [];
  double unityHeight = 35;
  double unityRowHeight = 25;
  late bool exits_data;
  late String txt_title = "Inspecciones";
  final columns = [
    'Pos.',
    'Marca de\n Neumático	',
    'Medida',
    'Modelo',
    'Estado',
    'Diseño de\n Reencauche',
    'Empresa\n Reencauchadora',
    'Serie',
    'Tapa',
    'Inacc.',
    'Malog.',
    'Actual',
    'Recom.',
    'Estado',
    'Orig.',
    '1',
    '2',
    '3',
    'NSD\n Min',
    'Recomendaciones'
  ];

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/reporte_inspecciones"),
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

    _inpeccion = [];
    print('18-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _inpeccion = jsonData['success']['datos'];
      }
      return _inpeccion;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    inspecciones = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      inspecciones = cargarDatos();
      print("18-Se ejecuta");
      refreshing = false;
    } else {
      print("18-No se ejecuta");
      refreshing = true;
    }
    return Center(
      child: FutureBuilder<List>(
        future: inspecciones,
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
                        // headerRowPerformance(),
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
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["posicion"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["marcaneumatico"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              data["medidaneumatico"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              data["modeloneumatico"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["estadoneumatico"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["disenioneumatico"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["razon_social"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["num_serie"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 20.0,
                                          child: Center(
                                            child: Text(
                                              data["valvula"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 20.0,
                                          child: Center(
                                            child: Text(
                                              data["accesibilidad"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 20.0,
                                          child: Center(
                                            child: Text(
                                              data["malogrado"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 30.0,
                                          child: Center(
                                            child: Text(
                                              data["presionactual"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 30.0,
                                          child: Center(
                                            child: Text(
                                              data["presion_recomendada"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 120.0,
                                          child: Center(
                                            child: Text(
                                              data["estadopresion"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["remanente_original"]
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["exterior"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["medio"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["interior"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["nsk_minimo"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 200.0,
                                          child: Center(
                                            child: Text(
                                              data["recomendacion"].toString(),
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
}
