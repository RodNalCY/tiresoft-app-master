import 'package:flutter/material.dart';
import 'package:tiresoft/listInspection/list_inspection_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/scrap/tire_scrap_detail_screen.dart';
import 'dart:convert';

import 'package:tiresoft/widgets/custom_drawer.dart';

class ListTireScrapScreen extends StatefulWidget {
  @override
  _ListTireScrapScreenState createState() => _ListTireScrapScreenState();
}

class _ListTireScrapScreenState extends State<ListTireScrapScreen> {
  List _listTireScrap = [];
  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  var url = Uri.parse(
      "https://tiresoft2.lab-elsol.com/api/scrap/neumaticosRetiroScrap");

  void getScrapList() async {
    var graphResponse = await http.get(url);
    final myInspections = json.decode(graphResponse.body) as List;

    setState(() {
      _listTireScrap = myInspections;
    });
  }

  @override
  void initState() {
    super.initState();
    getScrapList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color(0xff212F3D),
          elevation: 0.0,
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
              _listTireScrap.sort(
                  (a, b) => b['identificador'].compareTo(a['identificador']));
            } else {
              _listTireScrap.sort(
                  (a, b) => a['identificador'].compareTo(b['identificador']));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(label: Text('Serie')),
      DataColumn(label: Text('Fecha Retiro')),
      DataColumn(label: Text('Rem Final')),
      DataColumn(label: Text('Rem Lim')),
    ];
  }

  List<DataRow> _createRows() {
    return _listTireScrap
        .map((scrap) => DataRow(cells: [
              DataCell(IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TireScrapDetailScreen(neumaticoId: scrap['id'])),
                  )
                },
              )),
              DataCell(Text(scrap['num_serie'])),
              DataCell(Text(scrap['fecha_retiro'] ?? '-')),
              DataCell(Text(scrap['remanente_final'] ?? '-')),
              DataCell(Text(scrap['remanente_limite'] ?? '-'))
            ]))
        .toList();
  }
}
