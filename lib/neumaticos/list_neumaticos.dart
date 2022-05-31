import 'package:flutter/material.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';
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
      // print(jsonData['success']['resultado']);

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
              return _myListNeumaticos(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _myListNeumaticos(BuildContext context, data) {
    // backing data
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Serie: " + data[index].n_serie)))
          },
          title: Text('Serie: ' + data[index].n_serie),
          subtitle: Text(data[index].n_marca +
              ' ' +
              data[index].n_modelo +
              ' ' +
              data[index].n_medida),
          leading:
              CircleAvatar(child: Text(data[index].n_marca.substring(0, 1))),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}
