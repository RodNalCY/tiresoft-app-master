import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/models/indice_reencauche.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetReencauche extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetReencauche(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetReencauche> createState() => _WidgetReencaucheState();
}

class _WidgetReencaucheState extends State<WidgetReencauche> {
  late bool refreshing = false;

  late Future<List<IndiceReencauche>> indiceReencauche;
  List<IndiceReencauche> _indice_reencauche = [];
  late TooltipBehavior _tooltip_reencauche;
  late bool exits_data;
  late String txt_title = "Índice de reencauche";
  late String total;

  Future<List<IndiceReencauche>> cargarDatos() async {
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

    _indice_reencauche = [];
    print('12-Status Code${response.statusCode}');

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
          _indice_reencauche.add(
            IndiceReencauche(item['description'], item['cantidad'],
                item['porcentaje'] + "%"),
          );
        }
      }
      return _indice_reencauche;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    _tooltip_reencauche = TooltipBehavior(enable: true);
    indiceReencauche = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      indiceReencauche = cargarDatos();
      print("12-Se ejecuta");
      refreshing = false;
    } else {
      print("12-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List<IndiceReencauche>>(
        future: indiceReencauche,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total,
                widget: SfCircularChart(
                  tooltipBehavior: _tooltip_reencauche,
                  legend: Legend(isVisible: true),
                  series: <PieSeries<IndiceReencauche, String>>[
                    PieSeries<IndiceReencauche, String>(
                      radius: '100%',
                      // explode: true,
                      // explodeIndex: 0,
                      dataSource: snapshot.data,
                      xValueMapper: (IndiceReencauche data, _) => data.xData,
                      yValueMapper: (IndiceReencauche data, _) => data.yData,
                      dataLabelMapper: (IndiceReencauche data, _) => data.text,
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
