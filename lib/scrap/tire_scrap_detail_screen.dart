import 'package:flutter/material.dart';
import 'package:tiresoft/listInspection/tire_detail_screen.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TireScrapDetailScreen extends StatefulWidget {
  final int neumaticoId;

  const TireScrapDetailScreen({
    Key? key,
    required this.neumaticoId,
  }) : super(key: key);
  @override
  _TireScrapDetailScreenState createState() => _TireScrapDetailScreenState();
}

class _TireScrapDetailScreenState extends State<TireScrapDetailScreen> {
  Map _myTire = new Map();

  void getData() async {
    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/scrap/showRecorridoNeumatico/" +
            widget.neumaticoId.toString());

    var graphResponse = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': "5",
      }),
    );

    final myTire = json.decode(graphResponse.body);
    print(myTire.toString());
    setState(() {
      _myTire = myTire['neumatico'];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();

    setState(() {});
  }

  int _currentSortColumn = 0;
  bool _isSortAsc = true;
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
          _customRow('Serie:', _myTire['num_serie'].toString()),
          _customRow('Fecha de scrap:', _myTire['fecha_retiro'].toString()),
          _customRow('Remanente final:', _myTire['remanente_final'].toString()),
          _customRow(
              'Remanente limite:', _myTire['remanente_limite'].toString()),
          _customRow(
              'Motivo:',
              _myTire['motivo_scrap'] != null
                  ? (_myTire['motivo_scrap']['motivo'] ?? '-')
                  : '-'),
          _image(_myTire['neumaticoimgruta1'].toString()),
          _image(_myTire['neumaticoimgruta2'].toString())
        ]);
  }

  Widget _image(String path) {
    if (path != 'null') {
      return Padding(
          padding: EdgeInsets.all(5),
          child: Image.network('https://tiresoft2.lab-elsol.com/' + path));
    } else {
      return const Text("No tiene imagen");
    }
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
