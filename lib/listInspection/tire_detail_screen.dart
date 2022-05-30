import 'package:flutter/material.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TireDetailScreen extends StatefulWidget {
  final int inspectionId;
  final String numSerie;
  const TireDetailScreen({
    Key? key,
    required this.numSerie,
    required this.inspectionId,
  }) : super(key: key);
  @override
  _TireDetailScreenState createState() => _TireDetailScreenState();
}

class _TireDetailScreenState extends State<TireDetailScreen> {
  Map _myInspections = new Map();

  void getInspections() async {
    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/inspecciones/getOneInspeccionSimplified/" +
            widget.inspectionId.toString());

    var graphResponse = await http.get(url);
    final myInspections = json.decode(graphResponse.body);

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
          title: const Text('Detalle de la inspeccion al neumatico'),
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

  Widget _createDataTable() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _customRow('Serie:', _myInspections['serie'].toString()),
          _customRow('Marca:', _myInspections['marca'].toString()),
          _customRow('Modelo:', _myInspections['modelo'].toString()),
          _customRow('Medida:', _myInspections['medida'].toString()),
          _customRow('Eje:', _myInspections['eje'].toString()),
          _customRow('Condicion:', _myInspections['condicion'].toString()),
          _customRow('Cantidad reencauches:',
              _myInspections['cantidad_reencauche'].toString()),
          _customRow('Presión:', _myInspections['presion'].toString()),
          _customRow('Tapa de piston:', _myInspections['valvula'].toString()),
          _customRow('Estado:', _myInspections['estado'].toString()),
          _customRow(
              'Prof. rodado izquierdo:', _myInspections['interior'].toString()),
          _customRow('Prof. rodado medio:', _myInspections['medio'].toString()),
          _customRow(
              'Prof. rodado derechi:', _myInspections['exterior'].toString()),
          _customRow(
              'Observaciones:', _myInspections['observaciones'].toString()),
        ]);
  }

  Widget _customRow(String text1, String text2) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          child: Text(
            text1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
            child: Text(
              text2 != 'null' ? text2 : '-',
            )),
      ],
    );
  }
}
