import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/models/inflado_neumatico.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetInfladoNeumatico extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetInfladoNeumatico(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetInfladoNeumatico> createState() => _WidgetInfladoNeumaticoState();
}

class _WidgetInfladoNeumaticoState extends State<WidgetInfladoNeumatico> {
  late bool refreshing = false;

  late Future<List<InfladoNeumatico>> inflado_neumatico;
  List<InfladoNeumatico> _inflado = [];
  late TooltipBehavior _tooltip_inflado;
  late bool exits_data;
  late String txt_title = "Inflado de neumáticos";
  late String total;

  Future<List<InfladoNeumatico>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/inflado_neumaticos"),
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

    _inflado = [];
    print('4-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total = "0";
      } else {
        exits_data = true;
        total = jsonData['success']['totaldatos'].toString();
        for (var item in jsonData['success']['datos']) {
          _inflado.add(
            InfladoNeumatico(item['descripcion'], item['cantidad'],
                item['porcentaje'] + "%"),
          );
        }
      }
      return _inflado;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    _tooltip_inflado = TooltipBehavior(enable: true);
    inflado_neumatico = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      inflado_neumatico = cargarDatos();
      print("4-Se ejecuta");
      refreshing = false;
    } else {
      print("4-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List<InfladoNeumatico>>(
        future: inflado_neumatico,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total,
                widget: SfCircularChart(
                  tooltipBehavior: _tooltip_inflado,
                  legend: Legend(isVisible: true),
                  series: <PieSeries<InfladoNeumatico, String>>[
                    PieSeries<InfladoNeumatico, String>(
                      radius: '100%',
                      // explode: true,
                      // explodeIndex: 0,
                      dataSource: snapshot.data,
                      xValueMapper: (InfladoNeumatico data, _) => data.xData,
                      yValueMapper: (InfladoNeumatico data, _) => data.yData,
                      dataLabelMapper: (InfladoNeumatico data, _) => data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              );
            } else {
              return WidgetNotData(title: txt_title + "\nTotal : " + total);
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
