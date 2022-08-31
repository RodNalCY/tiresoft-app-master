import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/models/indice_reencauchabilidad.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetReencauchabilidad extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetReencauchabilidad(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetReencauchabilidad> createState() =>
      _WidgetReencauchabilidadState();
}

class _WidgetReencauchabilidadState extends State<WidgetReencauchabilidad> {
  late bool refreshing = false;

  late Future<List<IndiceReencauchabilidad>> indiceReencauchabilidad;
  List<IndiceReencauchabilidad> _indice_reencauchabilidad = [];
  late TooltipBehavior _tooltip_reencauchabilidad;
  late bool exits_data;
  late String txt_title = "Índice de reencauchabilidad";
  late String total;

  Future<List<IndiceReencauchabilidad>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/indice_reencauche_reencauchabilidad"),
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

    _indice_reencauchabilidad = [];
    print('11-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total = "0";
      } else {
        exits_data = true;
        total = jsonData['success']['indice_reencauchabilidad'].toString();
        double doub_indice_reencauchabilidad =
            double.parse(jsonData['success']['indice_reencauchabilidad']);
        int int_indice_reencauchabilidad =
            doub_indice_reencauchabilidad.toInt();

        _indice_reencauchabilidad.add(
          IndiceReencauchabilidad(
            'Reencauchabilidad',
            doub_indice_reencauchabilidad,
            jsonData['success']['indice_reencauchabilidad'],
          ),
        );
      }
      return _indice_reencauchabilidad;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    _tooltip_reencauchabilidad = TooltipBehavior(enable: true);
    indiceReencauchabilidad = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      indiceReencauchabilidad = cargarDatos();
      print("11-Se ejecuta");
      refreshing = false;
    } else {
      print("11-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List<IndiceReencauchabilidad>>(
        future: indiceReencauchabilidad,
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
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 2.5, interval: 0.5),
                  tooltipBehavior: _tooltip_reencauchabilidad,
                  series: <ChartSeries<IndiceReencauchabilidad, String>>[
                    ColumnSeries<IndiceReencauchabilidad, String>(
                      borderWidth: 1,
                      borderColor: Colors.blue,
                      dataSource: snapshot.data!,
                      xValueMapper: (IndiceReencauchabilidad data, _) =>
                          data.xData,
                      yValueMapper: (IndiceReencauchabilidad data, _) =>
                          data.yData,
                      dataLabelMapper: (IndiceReencauchabilidad data, _) =>
                          data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      name: 'Reencauchabilidad',
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
