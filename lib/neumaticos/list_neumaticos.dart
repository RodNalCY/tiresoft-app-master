import 'package:flutter/material.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListNeumaticos extends StatefulWidget {
  final String _id_cliente;

  ListNeumaticos(this._id_cliente, {Key? key}) : super(key: key);

  @override
  State<ListNeumaticos> createState() => _ListNeumaticosState();
}

class _ListNeumaticosState extends State<ListNeumaticos> {
  late Future<List<Neumatico>> _listadoNeumaticos;

  Future<List<Neumatico>> _postNeumaticos() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/neumaticos/listaNeumaticos"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    List<Neumatico> neumaticos = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData['success']['resultado']);

      for (var item in jsonData['success']['resultado']) {
        neumaticos.add(Neumatico(
            item["id"],
            item["num_serie"],
            item["marca"],
            item["modelo"],
            item["medida"],
            item["nuevo"],
            item["estado"],
            item["vehiculo"],
            item["fecha_registro"]));
      }
      return neumaticos;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoNeumaticos = _postNeumaticos();
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
        body: FutureBuilder(
          future: _listadoNeumaticos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                  crossAxisCount: 2, children: _listNeumaticos(snapshot.data));
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  List<Widget> _listNeumaticos(data) {
    List<Widget> neumaticos = [];

    for (var neu in data) {
      neumaticos.add(Card(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0), child: Text(neu.n_serie))
          ],
        ),
      ));
    }

    return neumaticos;
  }
}

class Neumatico {
  int n_id;
  String n_serie;
  String n_marca;
  String n_modelo;
  String n_medida;
  String n_condicion;
  String n_estado;
  String n_vehiculo;
  String n_f_registro;

  Neumatico(this.n_id, this.n_serie, this.n_marca, this.n_modelo, this.n_medida,
      this.n_condicion, this.n_estado, this.n_vehiculo, this.n_f_registro) {
    this.n_id = n_id;
    this.n_serie = n_serie;
    this.n_marca = n_marca;
    this.n_modelo = n_modelo;
    this.n_medida = n_medida;
    this.n_condicion = n_condicion;
    this.n_estado = n_estado;
    this.n_vehiculo = n_vehiculo;
    this.n_f_registro = n_f_registro;
  }
}
