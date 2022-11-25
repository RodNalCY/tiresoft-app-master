import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/equipo.dart';
import 'dart:convert';

import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetEquiposInspeccionados extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetEquiposInspeccionados(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetEquiposInspeccionados> createState() =>
      _WidgetEquiposInspeccionadosState();
}

class _WidgetEquiposInspeccionadosState
    extends State<WidgetEquiposInspeccionados> {
  late bool refreshing = false;
  double unityHeight = 35;
  double unityRowHeight = 25;
  late bool exits_data;
  late String txt_title = "Equipos Inspeccionados";
  late String total_equipos;
  late Future<List<Equipo>> equipos_inspeccionados;
  List<Equipo> _equipos = <Equipo>[];
  late EquiposDataSource equiposDataSource;

  Future<List<Equipo>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/equipos_inspeccionados"),
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

    _equipos = [];
    total_equipos = "";
    print('3-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total_equipos = "0";
      } else {
        exits_data = true;
        total_equipos =
            jsonData['success']['total_equipos_inspeccionados'].toString();
        for (var item in jsonData['success']['datos']) {
          _equipos.add(Equipo(
            item["nomtipo"],
            item["marca"],
            item["modelo"],
            item["medidaDelanteros"],
            item["medidaPosteriores"],
            item["total_neumaticos"],
          ));
        }
      }
      equiposDataSource = EquiposDataSource(_equipos);
      return _equipos;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    refreshing = false;
    equipos_inspeccionados = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      equipos_inspeccionados = cargarDatos();
      print("3-Se ejecuta");
      refreshing = false;
    } else {
      print("3-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List>(
        future: equipos_inspeccionados,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total_equipos,
                widget: Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SfDataGrid(
                      headerRowHeight: 30,
                      rowHeight: 30,
                      columnWidthMode: ColumnWidthMode.auto,
                      // allowSorting: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      source: equiposDataSource,
                      columns: [
                        GridColumn(
                          columnName: 'tipo',
                          label: Container(
                            color: Colors.blue.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Tipo',
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'marca',
                          label: Container(
                            color: Colors.blue.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Marca',
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'modelo',
                          minimumWidth: 130,
                          label: Container(
                            color: Colors.blue.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Modelo',
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'delantero',
                          label: Container(
                            color: Colors.blue.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Delanteros',
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'posterior',
                          label: Container(
                            color: Colors.blue.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Posteriores',
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'total',
                          label: Container(
                            color: Colors.blue.shade200,
                            alignment: Alignment.center,
                            child: Text(
                              'Total',
                            ),
                          ),
                        )
                      ],
                      stackedHeaderRows: <StackedHeaderRow>[
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: ['tipo', 'marca', 'modelo'],
                            child: Container(
                              color: Colors.blue.shade200,
                              child: Center(
                                child: Text('Equipo'),
                              ),
                            ),
                          ),
                          StackedHeaderCell(
                            columnNames: ['delantero', 'posterior', 'total'],
                            child: Container(
                              color: Colors.blue.shade200,
                              child: Center(
                                child: Text('Neumático'),
                              ),
                            ),
                          )
                        ])
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
}

class EquiposDataSource extends DataGridSource {
  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  EquiposDataSource(List<Equipo> equipos) {
    dataGridRows = equipos
        .map<DataGridRow>(
          (data) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'tipo',
                value: data.tipo,
              ),
              DataGridCell<String>(
                columnName: 'marca',
                value: data.marca,
              ),
              DataGridCell<String>(
                columnName: 'modelo',
                value: data.modelo,
              ),
              DataGridCell<String>(
                columnName: 'delantero',
                value: data.delantero,
              ),
              DataGridCell<String>(
                columnName: 'posterior',
                value: data.posterior,
              ),
              DataGridCell<int>(
                columnName: 'total',
                value: data.total,
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              dataGridCell.value.toString(),
            ),
          );
        },
      ).toList(),
    );
  }
}
