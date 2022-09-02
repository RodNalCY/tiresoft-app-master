import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetRemanenteMedida extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetRemanenteMedida(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetRemanenteMedida> createState() => _WidgetRemanenteMedidaState();
}

class _WidgetRemanenteMedidaState extends State<WidgetRemanenteMedida> {
  // static const DataCell empty = DataCell(Text("-"));
  late bool refreshing = false;
  late Future<List> remanentes_medidas;
  List _remanentes = [];
  double unityHeight = 35;
  double unityRowHeight = 25;
  late bool exits_data;
  late String txt_title = "Niveles de remanente por medida";
  List _list_totales = [];

  late String aplicacion_name;
  late int aplicacion_reencauche;
  late int aplicacion_proximo;

  late int total_reencauchar;
  late double percent_reencauchar;
  late int total_proximos;
  late double percent_proximos;
  late int total_operativos;
  late double percent_operativos;
  late int total_general;
  late Set medida_detalles;

  List<String> columns = [
    'Tipo',
    'Medida',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    'Total',
  ];
  List<String> columns_details = [
    'Aplicación',
    'Reenc.',
    'Próx. Reenc.',
    'Operativo',
    'Total',
    'Porcentaje',
  ];

  Future<List> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/niveles_remanente_medida"),
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

    _remanentes = [];
    _list_totales = [];
    int total_suma = 0;
    int resultado = 0;
    aplicacion_name = "";
    aplicacion_reencauche = 0;
    aplicacion_proximo = 0;
    double r1_temporal = 0.0;
    double r2_temporal = 0.0;
    medida_detalles = {};

    print('17-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        _remanentes = jsonData['success']['datos'];
        _list_totales = jsonData['success']['totales'];

        total_suma = _list_totales.length;

        if (total_suma < 25) {
          resultado = 25 - total_suma;
          for (var i = 0; i < resultado; i++) {
            _list_totales.add("-");
          }
        }

        for (var data in jsonData['success']['resumen']['aplicacion']) {
          aplicacion_name = data['aplicacion'].toString();
          r1_temporal = double.parse(data['rem_reencauche'].toString());
          r2_temporal = double.parse(data['rem_proximo'].toString());
        }
        aplicacion_reencauche = r1_temporal.round();
        aplicacion_proximo = r2_temporal.round();

        total_reencauchar =
            jsonData['success']['resumen']['neumaticos_reencauchar'];
        total_proximos =
            jsonData['success']['resumen']['neumaticos_proximo_reencauchar'];
        total_operativos =
            jsonData['success']['resumen']['neumaticos_operativos'];
        total_general = jsonData['success']['resumen']['total_general'];

        percent_reencauchar = ((total_reencauchar / total_general) * 100);
        percent_proximos = ((total_proximos / total_general) * 100);
        percent_operativos = ((total_operativos / total_general) * 100);

        medida_detalles = {
          {
            'aplicacion': 'Total',
            'reencauche': total_reencauchar.toString(),
            'proximo': total_proximos.toString(),
            'operativo': total_operativos.toString(),
            'total': total_general.toString(),
            'porcentaje': '100%',
          },
          {
            'aplicacion': 'Porcentaje',
            'reencauche': percent_reencauchar.toStringAsFixed(1) + " %",
            'proximo': percent_proximos.toStringAsFixed(1) + " %",
            'operativo': percent_operativos.toStringAsFixed(1) + " %",
            'total': total_general.toString(),
            'porcentaje': '100%',
          },
        };
        // print(medida_detalles);
      }
      return _remanentes;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    remanentes_medidas = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      remanentes_medidas = cargarDatos();
      print("17-Se ejecuta");
      refreshing = false;
      print("NUEVO OBJETO");
      print(medida_detalles);
    } else {
      print("17-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List>(
        future: remanentes_medidas,
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
                        headerRowMain(),
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
                                        Center(
                                          child: Container(
                                            width: 50.0,
                                            child: Text(
                                              data["tipovehiculo"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Container(
                                            width: 100.0,
                                            child: Text(
                                              data["medida"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      data["totalneumaticos_nsk_minimo_1"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_1"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_2"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_2"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_3"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_3"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_4"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_4"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_5"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_5"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_6"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_6"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_7"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_7"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_8"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_8"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_9"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_9"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_10"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_10"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_11"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_11"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_12"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_12"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_13"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_13"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_14"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_14"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_15"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_15"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_16"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_16"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_17"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_17"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_18"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_18"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_19"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_19"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_20"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_20"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_21"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_21"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_22"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_22"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_23"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_23"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_24"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_24"])
                                          : dataEmpty(),
                                      data["totalneumaticos_nsk_minimo_25"] !=
                                              null
                                          ? nsdDataCell(data[
                                              "totalneumaticos_nsk_minimo_25"])
                                          : dataEmpty(),
                                      DataCell(
                                        Container(
                                          width: 50.0,
                                          child: Center(
                                            child: Text(
                                              data["total_vehiculo_medidas"]
                                                  .toString(),
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
                        footerRowTotal(),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: DataTable(
                            dataRowHeight: unityRowHeight,
                            headingRowHeight: unityHeight,
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            border:
                                TableBorder.all(color: Colors.blue.shade100),
                            columns: getColumnsTwo(columns_details),
                            rows: medida_detalles
                                .map(
                                  (data) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["aplicacion"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["reencauche"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["proximo"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["operativo"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["total"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 100.0,
                                          child: Center(
                                            child: Text(
                                              data["porcentaje"].toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        )
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

  DataCell dataEmpty() {
    return DataCell(
      Container(
        padding: EdgeInsets.all(5),
        width: 28,
        child: Center(
          child: Text(
            '-',
          ),
        ),
      ),
    );
  }

  DataCell nsdDataCell(nsd) {
    String str_nsd = nsd.toString();
    return DataCell(
      Container(
        padding: EdgeInsets.all(5),
        width: 28,
        child: Center(
          child: Text(
            str_nsd.toString(),
          ),
        ),
      ),
    );
  }

  Container footerRowTotal() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 258,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (var i = 0; i < _list_totales.length; i++) ...[
            totalRow(_list_totales[i]),
          ],
          Container(
            width: 103,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                total_general.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget totalRow(numero) {
    return Container(
      width: 84,
      margin: EdgeInsets.zero,
      height: unityHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        color: Colors.blue.shade200,
      ),
      child: Center(
        child: Text(
          numero.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container headerRowMain() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 258,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'Aplicación: ' + aplicacion_name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 2202,
            margin: EdgeInsets.zero,
            height: unityHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade200,
            ),
            child: Center(
              child: Text(
                'PROFUNDIDAD DE BANDA DE RODAMIENTO EN MILÍMETROS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataColumn> getColumnsTwo(List<String> columns) {
    return columns
        .map(
          (String column) => DataColumn(
            label: Expanded(
              child: Container(
                child: Text(
                  column,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
