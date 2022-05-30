import 'package:flutter/material.dart';
import 'package:tiresoft/listInspection/tire_detail_screen.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListInspectionDetailScreen extends StatefulWidget {
  final int inspectionId;

  const ListInspectionDetailScreen({
    Key? key,
    required this.inspectionId,
  }) : super(key: key);
  @override
  _ListInspectionDetailScreenState createState() =>
      _ListInspectionDetailScreenState();
}

class _ListInspectionDetailScreenState
    extends State<ListInspectionDetailScreen> {
  List _myInspections = [];

  void getInspections() async {
    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/inspecciones/getAllInspectionsMinifiedPerIdentifier/" +
            widget.inspectionId.toString());

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

  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de la inspección'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
        label: const Text('Opciones'),
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              _myInspections.sort((a, b) => b['id'].compareTo(a['id']));
            } else {
              _myInspections.sort((a, b) => a['id'].compareTo(b['id']));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(label: const Text('Posicion')),
      DataColumn(label: const Text('Serie neumático'))
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
                        builder: (context) => TireDetailScreen(
                            numSerie: inspection['serie_neumatico'].toString(),
                            inspectionId: inspection['id'])),
                  )
                },
              )),
              DataCell(Text(inspection['posicion'].toString())),
              DataCell(Text(inspection['serie_neumatico'].toString())),
            ]))
        .toList();
  }
}
