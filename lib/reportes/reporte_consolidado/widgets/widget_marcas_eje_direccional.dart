import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/models/marcas_eje_direccional.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetMarcaEjeDireccional extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;

  WidgetMarcaEjeDireccional(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin})
      : super(key: key);

  @override
  State<WidgetMarcaEjeDireccional> createState() =>
      _WidgetMarcaEjeDireccionalState();
}

class _WidgetMarcaEjeDireccionalState extends State<WidgetMarcaEjeDireccional> {
  late Future<List<MarcasEjeDireccional>> marcaEjeDireccional;
  late TooltipBehavior _tooltip;
  late bool exits_data;
  late String txt_title = "Distribución de Marcas por eje direccional";

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

    List<MarcasEjeDireccional> _marca_eje_direccional = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;
        for (var item in jsonData['success']['datos']) {
          _marca_eje_direccional.add(
            MarcasEjeDireccional(item['desc_marca'], item['cantidad_marca'],
                item['porcentaje'] + "%"),
          );
        }
      }

      return _marca_eje_direccional;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    marcaEjeDireccional = cargarDatos();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    marcaEjeDireccional = cargarDatos();
    return Center(
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: FutureBuilder<List<MarcasEjeDireccional>>(
          future: marcaEjeDireccional,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(child: Text("$error"));
            } else if (snapshot.hasData) {
              if (exits_data) {
                return SfCartesianChart(
                  title: ChartTitle(text: txt_title),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 120, interval: 10),
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
                );
              } else {
                return WidgetNotData(title: txt_title);
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