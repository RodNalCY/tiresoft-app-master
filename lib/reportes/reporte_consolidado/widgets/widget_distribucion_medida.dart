import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/distribucion_medida.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetDistribucionMedida extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetDistribucionMedida(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetDistribucionMedida> createState() =>
      _WidgetDistribucionMedidaState();
}

class _WidgetDistribucionMedidaState extends State<WidgetDistribucionMedida> {
  late Future<List<DistribucionMedida>> distribucionMedida;
  late TooltipBehavior _tooltip_rueda;
  late bool exits_data;
  late String txt_title = "Distribución de Medidas de Neumáticos";
  late String total;

  Future<List<DistribucionMedida>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/medidas_neumaticos"),
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

    List<DistribucionMedida> _distribucion_medida = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print(jsonData);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total = "0";
      } else {
        exits_data = true;
        total = jsonData['success']['total'].toString();
        for (var item in jsonData['success']['datos']) {
          _distribucion_medida.add(
            DistribucionMedida(item['descripcion'], item['count_medida'],
                item['porcentaje'] + "%"),
          );
        }
      }
      return _distribucion_medida;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    _tooltip_rueda = TooltipBehavior(enable: true);
    distribucionMedida = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    distribucionMedida = cargarDatos();
    return Center(
      child: FutureBuilder<List<DistribucionMedida>>(
        future: distribucionMedida,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total,
                widget: SfCircularChart(
                  tooltipBehavior: _tooltip_rueda,
                  legend: Legend(isVisible: true),
                  series: <PieSeries<DistribucionMedida, String>>[
                    PieSeries<DistribucionMedida, String>(
                      radius: '100%',
                      // explode: true,
                      // explodeIndex: 0,
                      dataSource: snapshot.data,
                      xValueMapper: (DistribucionMedida data, _) => data.xData,
                      yValueMapper: (DistribucionMedida data, _) => data.yData,
                      dataLabelMapper: (DistribucionMedida data, _) =>
                          data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              );
            } else {
              return WidgetNotData(title: txt_title + "\nTotal : " + total);
            }
          } else {
            // return Container(
            //   margin: EdgeInsets.all(10.0),
            //   child: const SizedBox(
            //     child: CircularProgressIndicator(
            //       strokeWidth: 1.0,
            //     ),
            //     height: 30.0,
            //     width: 30.0,
            //   ),
            // );
            return Container();
          }
        },
      ),
    );
  }
}
