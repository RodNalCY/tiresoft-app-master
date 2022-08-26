import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/models/presion_inflado.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetPresionInflado extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetPresionInflado(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetPresionInflado> createState() => _WidgetPresionInfladoState();
}

class _WidgetPresionInfladoState extends State<WidgetPresionInflado> {
  late Future<List<PresionInflado>> presion_inflado;
  late TooltipBehavior _tooltip_presion;
  late bool exits_data;
  late String txt_title = "Presión de inflado de neumáticos";
  late String total;

  Future<List<PresionInflado>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/presion_inflado_neumaticos"),
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

    List<PresionInflado> _presion = [];

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
          _presion.add(
            PresionInflado(item['descripcion_corta'], item['cantidad'],
                item['porcentaje'] + "%"),
          );
        }
      }
      return _presion;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    _tooltip_presion = TooltipBehavior(enable: true);
    presion_inflado = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    presion_inflado = cargarDatos();
    return Center(
      child: FutureBuilder<List<PresionInflado>>(
        future: presion_inflado,
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
                child: SfCircularChart(
                  title: ChartTitle(text: txt_title + "\nTotal : " + total),
                  tooltipBehavior: _tooltip_presion,
                  legend: Legend(isVisible: true),
                  series: <PieSeries<PresionInflado, String>>[
                    PieSeries<PresionInflado, String>(
                      radius: '100%',
                      // explode: true,
                      // explodeIndex: 0,
                      dataSource: snapshot.data,
                      xValueMapper: (PresionInflado data, _) => data.xData,
                      yValueMapper: (PresionInflado data, _) => data.yData,
                      dataLabelMapper: (PresionInflado data, _) => data.text,
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
