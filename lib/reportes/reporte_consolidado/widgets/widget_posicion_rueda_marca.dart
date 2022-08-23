import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/models/posicion_rueda_marca.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetPosicionRuedaMarca extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetPosicionRuedaMarca(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetPosicionRuedaMarca> createState() =>
      _WidgetPosicionRuedaMarcaState();
}

class _WidgetPosicionRuedaMarcaState extends State<WidgetPosicionRuedaMarca> {
  late Future<List<PosicionRuedaMarca>> posicion_rueda_marca;
  late TooltipBehavior _tooltip_rueda;
  late bool exits_data;
  late String txt_title = "Posición de rueda según marca";
  late String total;

  Future<List<PosicionRuedaMarca>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/posicion_rueda_segun_marca"),
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

    List<PosicionRuedaMarca> _posicion_marca = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total = "0";
      } else {
        exits_data = true;
        total = jsonData['success']['total'].toString();
        for (var item in jsonData['success']['datos']) {
          _posicion_marca.add(
            PosicionRuedaMarca(item['desc_marca'], item['cantidad_marca'],
                item['porcentaje'] + "%"),
          );
        }
      }
      return _posicion_marca;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    _tooltip_rueda = TooltipBehavior(enable: true);
    posicion_rueda_marca = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    posicion_rueda_marca = cargarDatos();
    // print("FECHA SELECCIONADA");
    // print('ANIO: ${widget.anio}');
    // print('F IN: ${widget.mes_inicio}');
    // print('F FN: ${widget.mes_fin}');

    return Center(
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: FutureBuilder<List<PosicionRuedaMarca>>(
          future: posicion_rueda_marca,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text("$error"));
            } else if (snapshot.hasData) {
              if (exits_data) {
                return SfCircularChart(
                  title: ChartTitle(text: txt_title + "\nTotal : " + total),
                  tooltipBehavior: _tooltip_rueda,
                  legend: Legend(isVisible: true),
                  series: <PieSeries<PosicionRuedaMarca, String>>[
                    PieSeries<PosicionRuedaMarca, String>(
                      radius: '100%',
                      // explode: true,
                      // explodeIndex: 0,
                      dataSource: snapshot.data,
                      xValueMapper: (PosicionRuedaMarca data, _) => data.xData,
                      yValueMapper: (PosicionRuedaMarca data, _) => data.yData,
                      dataLabelMapper: (PosicionRuedaMarca data, _) =>
                          data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                );
              } else {
                return WidgetNotData(title: txt_title + "\nTotal : " + total);
              }
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
      ),
    );
  }
}
