import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/inspeccion/list_inspeccion_details.dart';
import 'dart:convert';

import 'package:tiresoft/inspeccion/models/Inspeccion.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';

class ListInspeccion extends StatefulWidget {
  final String _id_cliente;

  ListInspeccion(this._id_cliente, {Key? key}) : super(key: key);

  @override
  State<ListInspeccion> createState() => _ListInspeccionState();
}

class _ListInspeccionState extends State<ListInspeccion> {
  late Future<List<Inspeccion>> _listadoInspeccion;
  String searchString = "";

  Future<List<Inspeccion>> _postListInspeccion() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/inspecciones/getAllInspectionsMinified"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    List<Inspeccion> _inspeccion = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print("JSON INSPECCION:");
      // print(jsonData['success']['resultado']);

      for (var item in jsonData['success']['resultado']) {
        var str_identificador = item["identificador"].toString();
        _inspeccion.add(Inspeccion(item["id"], str_identificador, item["placa"],
            item["km_inspeccion"], item["fecha_inspeccion"]));
      }

      return _inspeccion;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoInspeccion = _postListInspeccion();
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
        drawer: CustomDrawer(widget._id_cliente),
        body: Container(
          child: FutureBuilder(
            future: _listadoInspeccion,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return _myListInspeccion(context, snapshot.data);
                return Container(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchString = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'buscar x placa / identificador',
                        ),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Expanded(child: _myListInspeccion(context, snapshot.data))
                  ]),
                );
              } else if (snapshot.hasError) {
                return Text("Error");
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _myListInspeccion(BuildContext context, data) {
    // backing data
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        return data[index].i_identificador.contains(searchString) ||
                data[index].i_placa.contains(searchString)
            ? Card(
                child: ListTile(
                  onTap: () => {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     content: Text("Identificador: " + data[index].i_identificador)))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListInspeccionDetails(
                                widget._id_cliente,
                                data[index],
                                data[index].i_identificador)))
                  },
                  title: Text('Placa: ' + data[index].i_placa,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text('km: ' +
                      data[index].i_km_inspeccion +
                      ' Fecha: ' +
                      data[index].i_fecha_inspeccion),
                  leading:
                      CircleAvatar(child: Text(data[index].i_identificador)),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
