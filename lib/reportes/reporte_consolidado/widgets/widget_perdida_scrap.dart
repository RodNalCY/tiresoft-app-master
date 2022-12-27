import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tiresoft/reportes/reporte_consolidado/graphic_card.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/perdida_scrap.dart';
import 'dart:convert';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_not_data.dart';

class WidgetPerdidaScrap extends StatefulWidget {
  final String cliente;
  final String mes_inicio;
  final String mes_fin;
  final String anio;
  final bool refresh;

  WidgetPerdidaScrap(
      {Key? key,
      required this.cliente,
      required this.anio,
      required this.mes_inicio,
      required this.mes_fin,
      required this.refresh})
      : super(key: key);

  @override
  State<WidgetPerdidaScrap> createState() => _WidgetPerdidaScrapState();
}

class _WidgetPerdidaScrapState extends State<WidgetPerdidaScrap> {
  late bool refreshing = false;
  double unityHeight = 35;
  double unityRowHeight = 25;
  late bool exits_data;
  late String txt_title = "Perdidas Scrap";

  late String total_scraps;
  late Future<List<PerdidaScrap>> perdidas_scraps;
  List<PerdidaScrap> _scraps = <PerdidaScrap>[];
  late PerdidaScrapDataSource perdidaScrapDataSource;
  Future<List<PerdidaScrap>> cargarDatos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/reporte/perdidas_por_scrap"),
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

    _scraps = [];
    total_scraps = "";
    int conteo_total = 0;
    print('17-Status Code${response.statusCode}');

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['success']['datos'].length == 0) {
        exits_data = false;
        total_scraps = "0";
        conteo_total = 0;
      } else {
        exits_data = true;
        conteo_total = 0;

        int int_costo_perdido = 0;
        for (var item in jsonData['success']['datos']) {
          double _costo = double.parse(item["costo"]);
          double _costo_perdido = double.parse(item["costo_perdido"]);
          conteo_total++;

          _scraps.add(PerdidaScrap(
            item["num_serie"],
            item["serie_cliente"],
            item["marca"],
            item["modelo"],
            item["medida"],
            item["condicion"],
            item["fecha_scrap"],
            item["motivo"],
            item["remanente_original"],
            item["remanente_final"],
            item["remanente_limite"],
            _costo,
            _costo_perdido,
          ));
        }

        total_scraps = conteo_total.toString();
      }
      perdidaScrapDataSource = PerdidaScrapDataSource(_scraps);
      return _scraps;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  void initState() {
    refreshing = false;
    perdidas_scraps = cargarDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (refreshing && widget.refresh) {
      perdidas_scraps = cargarDatos();
      print("17-Se ejecuta");
      refreshing = false;
    } else {
      print("17-No se ejecuta");
      refreshing = true;
    }

    return Center(
      child: FutureBuilder<List>(
        future: perdidas_scraps,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text("$error"));
          } else if (snapshot.hasData) {
            if (exits_data) {
              return GraphicCard(
                title: txt_title + "\nTotal : " + total_scraps,
                widget: Container(
                  // color: Colors.brown,
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: SfDataGrid(
                    headerRowHeight: 30,
                    rowHeight: 30,
                    columnWidthMode: ColumnWidthMode.auto,
                    shrinkWrapRows: true,
                    verticalScrollPhysics: NeverScrollableScrollPhysics(),
                    // // allowSorting: true,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    source: perdidaScrapDataSource,
                    tableSummaryRows: [
                      GridTableSummaryRow(
                        showSummaryInRow: false,
                        titleColumnSpan: 11,
                        title: 'Total General',
                        color: Colors.blue.shade200,
                        columns: [
                          GridSummaryColumn(
                            name: 'Costo',
                            columnName: 'costo',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'CostoPerdida',
                            columnName: 'costo_perdida',
                            summaryType: GridSummaryType.sum,
                          )
                        ],
                        position: GridTableSummaryRowPosition.bottom,
                      )
                    ],
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'serie',
                        minimumWidth: 100,
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Núm. Serie',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'serie_cliente',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Serie de Cliente',
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
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Modelo',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'medida',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Medida',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'condicion',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Condición',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'fecha',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Fecha Scrap',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'motivo',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Motivo',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'r_original',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'R. Original',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'r_final',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'R. Final',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'r_limite',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'R. Límite',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'costo',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Costo',
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'costo_perdida',
                        label: Container(
                          color: Colors.blue.shade200,
                          alignment: Alignment.center,
                          child: Text(
                            'Costo de Pérdida',
                          ),
                        ),
                      ),
                    ],

                    // stackedHeaderRows: <StackedHeaderRow>[
                    //   StackedHeaderRow(cells: [
                    //     StackedHeaderCell(
                    //       columnNames: [
                    //         'tipo',
                    //         'marca',
                    //         'modelo',
                    //         'total_equipos'
                    //       ],
                    //       child: Container(
                    //         color: Colors.blue.shade200,
                    //         child: Center(
                    //           child: Text('Equipo'),
                    //         ),
                    //       ),
                    //     ),
                    //     StackedHeaderCell(
                    //       columnNames: ['delantero', 'posterior', 'total'],
                    //       child: Container(
                    //         color: Colors.blue.shade200,
                    //         child: Center(
                    //           child: Text('Neumático'),
                    //         ),
                    //       ),
                    //     )
                    //   ])
                    // ],
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

class PerdidaScrapDataSource extends DataGridSource {
  PerdidaScrapDataSource(List<PerdidaScrap> equipos) {
    dataGridRows = equipos
        .map<DataGridRow>(
          (data) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'serie',
                value: data.serie,
              ),
              DataGridCell<String>(
                columnName: 'serie_cliente',
                value: data.serie_cliente,
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
                columnName: 'medida',
                value: data.medida,
              ),
              DataGridCell<String>(
                columnName: 'condicion',
                value: data.condicion,
              ),
              DataGridCell<String>(
                columnName: 'fecha',
                value: data.fecha,
              ),
              DataGridCell<String>(
                columnName: 'motivo',
                value: data.motivo,
              ),
              DataGridCell<String>(
                columnName: 'r_original',
                value: data.r_original,
              ),
              DataGridCell<String>(
                columnName: 'r_final',
                value: data.r_final,
              ),
              DataGridCell<String>(
                columnName: 'r_limite',
                value: data.r_limite,
              ),
              DataGridCell<double>(
                columnName: 'costo',
                value: data.costo,
              ),
              DataGridCell<double>(
                columnName: 'costo_perdida',
                value: data.costo_perdida,
              ),
            ],
          ),
        )
        .toList();
  }
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      // padding: EdgeInsets.all(15.0),
      child: Center(
        child: Text(
          summaryValue,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          if (dataGridCell.columnName == 'costo' ||
              dataGridCell.columnName == 'costo_perdida') {
            return Container(
              color: Colors.blue.shade200,
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value.toString(),
              ),
            );
          }
        },
      ).toList(),
    );
  }
}
