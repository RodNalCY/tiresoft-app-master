import 'package:flutter/material.dart';
import 'package:tiresoft/listInspection/list_inspection_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/scrap/tire_scrap_detail_screen.dart';
import 'dart:convert';

import 'package:tiresoft/widgets/custom_drawer.dart';

class ListTireScrapScreen extends StatefulWidget {
  final String _id_cliente;

  ListTireScrapScreen(this._id_cliente, {Key? key}) : super(key: key);

  @override
  _ListTireScrapScreenState createState() => _ListTireScrapScreenState();
}

class _ListTireScrapScreenState extends State<ListTireScrapScreen> {
  List _listTireScrap = [];
  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  void getScrapList() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/scrap/listaNeumaticoScrap"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final _json_decode = jsonDecode(body);
      final _lista_scrap = _json_decode['success']['resultado'] as List;

      setState(() {
        _listTireScrap = _lista_scrap;
      });
    } else {
      throw Exception("Falló la Conexión");
    }
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
      DataColumn(label: Text('Rm. Final')),
      DataColumn(label: Text('Rm. Límite')),
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
