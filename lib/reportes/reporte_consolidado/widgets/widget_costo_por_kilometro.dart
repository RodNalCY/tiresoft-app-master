import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/costo_kilometro.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetCostoPorKilometro extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetCostoPorKilometro(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetCostoPorKilometro> createState() =>
      _WidgetCostoPorKilometroState();
}

class _WidgetCostoPorKilometroState extends State<WidgetCostoPorKilometro> {
  late bool refreshing = false;

  late Future<List<CostoKilometro>> costo_kilometro;
  List<CostoKilometro> _costo_x_kilometro = [];
  List<String> _list_meses_name = [];

  double unityHeight = 35;
  double unityRowHeight = 120.0;

  late bool exits_data;
  late String txt_title = "Indicador Costo por Kilómetro";

  Future<List<CostoKilometro>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/costo_por_kilometro"),
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

    _costo_x_kilometro = [];
    _list_meses_name = [];
    print('16-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print('16-jsonDecode > ${jsonData}');
      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
      } else {
        exits_data = true;

        for (var mes in jsonData['success']['meses']) {
          switch (mes) {
            case "01":
              _list_meses_name.add("Enero");
              break;
            case "02":
              _list_meses_name.add("Febrero");
              break;
            case "03":
              _list_meses_name.add("Marzo");
              break;
            case "04":
              _list_meses_name.add("Abril");
              break;
            case "05":
              _list_meses_name.add("Mayo");
              break;
            case "06":
              _list_meses_name.add("Junio");
              break;
            case "07":
              _list_meses_name.add("Julio");
              break;
            case "08":
              _list_meses_name.add("Agosto");
              break;
            case "09":
              _list_meses_name.add("Setiembre");
              break;
            case "10":
              _list_meses_name.add("Octubre");
              break;
            case "11":
              _list_meses_name.add("Noviembre");
              break;
            case "12":
              _list_meses_name.add("Diciembre");
              break;
          }
        }

        for (var item in jsonData['success']['datos']) {
          _costo_x_kilometro.add(CostoKilometro(
            item["marca"],
            item["modelo"],
            item["medida"],
            item["criterio_superior"],
            item["criterio_inferior"],
            item["indicador_mes_01"] != null ? item["indicador_mes_01"] : "-",
            item["indicador_mes_02"] != null ? item["indicador_mes_02"] : "-",
            item["indicador_mes_03"] != null ? item["indicador_mes_03"] : "-",
            item["indicador_mes_04"] != null ? item["indicador_mes_04"] : "-",
            item["indicador_mes_05"] != null ? item["indicador_mes_05"] : "-",
            item["indicador_mes_06"] != null ? item["indicador_mes_06"] : "-",
            item["indicador_mes_07"] != null ? item["indicador_mes_07"] : "-",
            item["indicador_mes_08"] != null ? item["indicador_mes_08"] : "-",
            item["indicador_mes_09"] != null ? item["indicador_mes_09"] : "-",
            item["indicador_mes_10"] != null ? item["indicador_mes_10"] : "-",
            item["indicador_mes_11"] != null ? item["indicador_mes_11"] : "-",
            item["indicador_mes_12"] != null ? item["indicador_mes_12"] : "-",
          ));
        }
      }

      return _costo_x_kilometro;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    costo_kilometro = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      costo_kilometro = cargarDatos();
      print("16-Se ejecuta");
      refreshing = false;
    } else {
      print("16-No se ejecuta");
      refreshing = true;
    }
    return FutureBuilder<List<CostoKilometro>>(
        future: costo_kilometro,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            return GraphicCard(
              title: txt_title,
              widget: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 50,
                              margin: EdgeInsets.zero,
                              height: 110,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue.shade100),
                                color: Colors.blue.shade200,
                              ),
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                    "KPI",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 50,
                              margin: EdgeInsets.zero,
                              height: 110,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue.shade100),
                                color: Colors.blue.shade200,
                              ),
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                    "COSTO X KILOMETRO",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                colHead(title: 'Marca', widht: 100),
                                colHead(title: 'Modelo (N)', widht: 100),
                                colHead(title: 'Medidas', widht: 100),
                                colHead(title: 'C. de Aceptación', widht: 200),
                                for (var mes in _list_meses_name) ...[
                                  colHead(title: mes.toString(), widht: 100),
                                ]
                              ],
                            ),
                            for (var item in snapshot.data!) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  colRow(
                                    title: item.k_marca,
                                    widht: 100,
                                    color: Colors.transparent,
                                    txtcolor: Colors.black,
                                  ),
                                  colRow(
                                    title: item.k_modelo,
                                    widht: 100,
                                    color: Colors.transparent,
                                    txtcolor: Colors.black,
                                  ),
                                  colRow(
                                    title: item.k_medida,
                                    widht: 100,
                                    color: Colors.transparent,
                                    txtcolor: Colors.black,
                                  ),
                                  colRowCriterio(
                                      objetivo: item.k_objetivo,
                                      deficiente: item.k_deficiente,
                                      widht: 200),
                                  valCriterioMes(
                                    indicador: item.k_ind_01,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_02,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_03,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_04,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_05,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_06,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_07,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_08,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_09,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_10,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_11,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                  valCriterioMes(
                                    indicador: item.k_ind_12,
                                    objetivo: item.k_objetivo,
                                    deficiente: item.k_deficiente,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget valCriterioMes({
    required String indicador,
    required String objetivo,
    required String deficiente,
  }) {
    late Widget _widget;
    late Color _color;

    double d_indicador = 0.0;
    double d_objetivo = 0.0;
    double d_deficiente = 0.0;

    if (indicador != "-") {
      d_indicador = double.parse(indicador);
      d_objetivo = double.parse(objetivo);
      d_deficiente = double.parse(deficiente);
      if (d_indicador < d_objetivo && d_indicador > d_deficiente) {
        _color = Colors.yellow;
      } else if (d_indicador < d_objetivo) {
        _color = Colors.green;
      } else if (d_indicador > d_deficiente) {
        _color = Colors.red;
      }
      _widget = colRow(
          title: indicador, widht: 100, color: _color, txtcolor: Colors.white);
    } else {
      _widget = Container();
    }

    return _widget;
  }

  Container colHead({required String title, required double widht}) {
    return Container(
      width: widht,
      margin: EdgeInsets.zero,
      height: unityHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        color: Colors.blue.shade200,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container colRow(
      {required String title,
      required double widht,
      required Color color,
      required Color txtcolor}) {
    return Container(
      width: widht,
      margin: EdgeInsets.zero,
      height: unityHeight + 3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        color: color,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: txtcolor),
        ),
      ),
    );
  }

  Container colRowCriterio(
      {required String objetivo,
      required String deficiente,
      required double widht}) {
    return Container(
      width: widht,
      margin: EdgeInsets.zero,
      height: unityHeight + 3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        // color: Colors.blue.shade200,
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 26.0, left: 26.0),
              color: Colors.green,
              child: Text(
                "Objetivo < " + objetivo,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 10.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 3.0, left: 3.0),
              color: Colors.yellow,
              child: Text(
                "Tolerable [ " + deficiente + " - " + objetivo + " ]",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 10.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 21.0, left: 21.0),
              color: Colors.red,
              child: Text(
                "Deficiente  > " + deficiente,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 10.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
