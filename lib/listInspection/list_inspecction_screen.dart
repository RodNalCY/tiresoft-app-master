import 'package:flutter/material.dart';
import 'package:tiresoft/listInspection/list_inspection_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/widgets/custom_drawer.dart';

class ListInspectionScreen extends StatefulWidget {
  @override
  _ListInspectionScreenState createState() => _ListInspectionScreenState();
}

class _ListInspectionScreenState extends State<ListInspectionScreen> {
  List _myInspections = [];
  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  var url = Uri.parse(
      "https://tiresoft2.lab-elsol.com/api/inspecciones/getAllInspectionsMinified");

  void getInspections() async {
    var graphResponse = await http.get(url);
    final myInspections = json.decode(graphResponse.body) as List;

    setState(() {
      _myInspections = myInspections;
    });
  }

  @override
  void initState() {
    super.initState();
    getInspections();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(""),
          elevation: 0.0,
          backgroundColor: Color(0xff212F3D),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: _createDataTable())),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Text('ID'),
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              _myInspections.sort(
                  (a, b) => b['identificador'].compareTo(a['identificador']));
            } else {
              _myInspections.sort(
                  (a, b) => a['identificador'].compareTo(b['identificador']));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(label: Text('Fecha Inspeccion')),
      DataColumn(label: Text('Km Inspeccion')),
      DataColumn(label: Text('Placa'))
    ];
  }

  List<DataRow> _createRows() {
    return _myInspections
        .map((inspection) => DataRow(cells: [
              DataCell(IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListInspectionDetailScreen(
                            inspectionId: inspection['identificador'])),
                  )
                },
              )),
              DataCell(Text(inspection['fecha_inspeccion'])),
              DataCell(Text(inspection['km_inspeccion'])),
              DataCell(Text(inspection['placa']))
            ]))
        .toList();
  }
}
