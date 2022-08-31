import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/models/marcas_eje_direccional.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetMarcaEjeDireccional extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetMarcaEjeDireccional(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetMarcaEjeDireccional> createState() =>
      _WidgetMarcaEjeDireccionalState();
}

class _WidgetMarcaEjeDireccionalState extends State<WidgetMarcaEjeDireccional> {
  late bool refreshing = false;

  late Future<List<MarcasEjeDireccional>> marcaEjeDireccional;
  List<MarcasEjeDireccional> _marca_eje_direccional = [];
  late TooltipBehavior _tooltip;
  late bool exits_data;
  late String txt_title = "Distribución de Marcas por eje direccional";
  late String total;
  late int int_max_value = 0;
  late double double_max_value;

  Future<List<MarcasEjeDireccional>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/distribucion_marcas_segun_eje"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget.cliente,
        'month1': widget.mes_inicio,
        'month2': widget.mes_fin,
        'year': widget.anio,
        'eje': '1',
      }),
    );

    _marca_eje_direccional = [];
    print('8-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total = "0";
      } else {
        exits_data = true;
        total = jsonData['success']['total'].toString();
        int_max_value = 0;

        for (var item in jsonData['success']['datos']) {
          if (int_max_value < item['cantidad_marca']) {
            int_max_value = item['cantidad_marca'];
          }

          _marca_eje_direccional.add(
            MarcasEjeDireccional(item['desc_marca'], item['cantidad_marca'],
                item['porcentaje'] + "%"),
          );
        }
        int_max_value += 15;
        String str_max_value = int_max_value.toString();
        double_max_value = double.parse(str_max_value);
      }

      // print(double_max_value);
      return _marca_eje_direccional;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    marcaEjeDireccional = cargarDatos();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      marcaEjeDireccional = cargarDatos();
      print("8-Se ejecuta");
      refreshing = false;
    } else {
      print("8-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List<MarcasEjeDireccional>>(
        future: marcaEjeDireccional,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total,
                widget: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                      minimum: 0, maximum: double_max_value, interval: 10),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<MarcasEjeDireccional, String>>[
                    ColumnSeries<MarcasEjeDireccional, String>(
                      borderWidth: 1,
                      borderColor: Colors.blue,
                      dataSource: snapshot.data!,
                      xValueMapper: (MarcasEjeDireccional data, _) =>
                          data.xData,
                      yValueMapper: (MarcasEjeDireccional data, _) =>
                          data.yData,
                      dataLabelMapper: (MarcasEjeDireccional data, _) =>
                          data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      name: 'Marca',
                      color: Color.fromRGBO(8, 142, 255, 1),
                    )
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
