import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/vehiculo_data.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetGraphicInspecciones extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;
  final String details;

  WidgetGraphicInspecciones(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh,
      required this.details})
      : super(key: key);

  @override
  State<WidgetGraphicInspecciones> createState() =>
      _WidgetGraphicInspeccionesState();
}

class _WidgetGraphicInspeccionesState extends State<WidgetGraphicInspecciones> {
  final scrolling = ScrollController();
  List<Widget> items = [];
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  double unityDataRowHeight = 35;
  double unityHeadRowHeight = 25;
  double unityColumnSpacing = 10;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();

    scrolling.addListener(() {
      if (scrolling.position.maxScrollExtent == scrolling.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrolling.dispose();
    super.dispose();
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;

    const limit = 4;
    final url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/reporte/reporte_inspecciones_paginado");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget.cliente,
        'month1': widget.mes_inicio,
        'month2': widget.mes_fin,
        'year': widget.anio,
        'pagina': page.toString(),
        'perPage': limit.toString(),
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final result = vehiculoDataFromJson(response.body);
      final List<Vehiculo> vehiculos = result.success.datos;

      setState(() {
        page++;
        isLoading = false;

        if (vehiculos.length < limit) {
          hasMore = false;
        }
        items.addAll(vehiculos.map<Widget>((data) {
          final detallito = data.detalle;

          final v_fechita = data.fechaInspeccion;
          final v_km = data.kmInspeccion;
          final v_tipo = data.tipovehiculo;
          final v_marca = data.marcavehiculo;
          final v_placa = data.placa;

          return Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 206,
                      margin: EdgeInsets.zero,
                      height: unityDataRowHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        color: Colors.blue.shade200,
                      ),
                      child: Center(
                        child: Text(
                          'Fecha Inspeccion: ' + v_fechita,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 329,
                      margin: EdgeInsets.zero,
                      height: unityDataRowHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        color: Colors.blue.shade200,
                      ),
                      child: Center(
                        child: Text(
                          'Km. Inspección: ' + v_km,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 210,
                      margin: EdgeInsets.zero,
                      height: unityDataRowHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        color: Colors.blue.shade200,
                      ),
                      child: Center(
                        child: Text(
                          'Tipo: ' + v_tipo,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 294,
                      margin: EdgeInsets.zero,
                      height: unityDataRowHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        color: Colors.blue.shade200,
                      ),
                      child: Center(
                        child: Text(
                          'Marca de vehiculo: ' + v_marca,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 262,
                      margin: EdgeInsets.zero,
                      height: unityDataRowHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        color: Colors.blue.shade200,
                      ),
                      child: Center(
                        child: Text(
                          'Placa de vehiculo: ' + v_placa,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DataTable(
                dataRowHeight: unityDataRowHeight,
                // headingRowHeight: unityHeadRowHeight,
                columnSpacing: unityColumnSpacing,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.blue.shade200),
                border: TableBorder.all(color: Colors.blue.shade100),
                columns: getColumns(columns),
                rows: [
                  for (var item in detallito) ...[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.posicion,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextMarca(text: item.marcaneumatico),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.medidaneumatico,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextModelo(text: item.modeloneumatico),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.estadoneumatico,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextDisenio(text: item.disenioneumatico),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextEmpresa(text: item.razonSocial),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.numSerie,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.valvula,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.accesibilidad,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.malogrado,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.presionactual,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.presionRecomendada,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextPresion(text: item.estadopresion),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.remanenteOriginal,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.interior,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.medio,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                item.exterior,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextNSKMin(text: item.nskMinimo),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            child: Center(
                              child: Text(
                                subTextRecomendacion(text: item.recomendacion),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ],
          );
        }).toList());
      });

      print('vehiculos.length : ${vehiculos.length}');
      print('limit : $limit');
      print('items : ${items.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.details),
        centerTitle: true,
        backgroundColor: Color(0xff212F3D),
        elevation: 0.0,
      ),
      body: Container(
        // width: double.infinity,
        // height: double.infinity,
        color: Color.fromARGB(255, 227, 235, 243),
        child: ListView.builder(
            controller: scrolling,
            // padding: const EdgeInsets.all(8.0),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index < items.length) {
                final itemWidget = items[index];
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: itemWidget,
                );
              } else {
                return Center(
                  child: hasMore
                      ? LinearProgressIndicator(
                          color: Colors.blueAccent,
                          backgroundColor: Colors.white,
                          minHeight: 5,
                        )
                      : Container(
                          color: Colors.red.shade400,
                          width: double.infinity,
                          child: const Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: const Text(
                                "Upps ... NO HAY MAS REGISTROS",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                );
              }
            }),
      ),
    );
  }

  String subTextNSKMin({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length < 5) {
      texto = text + " ";
    } else {
      texto = text;
    }

    return texto;
  }

  String subTextRecomendacion({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length > 14) {
      texto = text.substring(0, 11) + '...';
    } else {
      texto = text;
    }

    return texto;
  }

  String subTextModelo({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length > 5) {
      texto = text.substring(0, 5);
      ;
    } else {
      texto = text;
    }

    return texto;
  }

  String subTextDisenio({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length < 3) {
      texto = text + ' ';
    } else {
      texto = text;
    }

    return texto;
  }

  String subTextPresion({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length > 9) {
      texto = text.substring(0, 9);
    } else {
      texto = text;
    }

    return texto;
  }

  String subTextEmpresa({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length > 8) {
      texto = text.substring(0, 7) + "...";
    } else {
      texto = text;
    }

    return texto;
  }

  String subTextMarca({required String text}) {
    String texto = "";
    // print('texto ${text.length}');
    if (text.length > 8) {
      texto = text.substring(0, 6) + "...";
    } else if (text.length <= 5) {
      texto = text + "...";
    } else {
      texto = text;
    }

    return texto;
  }

  List<DataColumn> getColumns(List<String> _columns) {
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
}
