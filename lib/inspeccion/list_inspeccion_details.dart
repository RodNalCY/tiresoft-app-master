import 'package:flutter/material.dart';
import 'package:tiresoft/inspeccion/edit_inspeccion.dart';
import 'package:tiresoft/inspeccion/models/inspeccion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/inspeccion/models/inspeccion_details.dart';
import 'package:tiresoft/login/models/user.dart';

class ListInspeccionDetails extends StatefulWidget {
  Inspeccion _inspeccion;
  String _identificador;
  String _id_cliente;
  final List<User> _user;

  ListInspeccionDetails(
      this._id_cliente, this._inspeccion, this._identificador, this._user,
      {Key? key})
      : super(key: key);

  @override
  State<ListInspeccionDetails> createState() => _ListInspeccionDetailsState();
}

class _ListInspeccionDetailsState extends State<ListInspeccionDetails> {
  late Future<List<InspeccionDetails>> _listado_details_inspeccion;
  String searchString = "";

  Future<List<InspeccionDetails>> _postListInspeccionDetails() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/inspecciones/getAllInspectionsMinifiedPerIdentifier/" +
              widget._identificador),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    List<InspeccionDetails> _inspeccion_details = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print("JSON INSPECCION DETAILS:");
      // print(jsonData['success']['resultado']);

      for (var item in jsonData['success']['resultado']) {
        _inspeccion_details.add(InspeccionDetails(
            item["id"], item["serie_neumatico"], item["posicion"]));
      }

      return _inspeccion_details;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listado_details_inspeccion = _postListInspeccionDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Identificador: " + widget._identificador),
          backgroundColor: Color(0xff212F3D),
        ),
        body: Container(
          color: Color.fromARGB(255, 227, 235, 243),
          child: FutureBuilder(
            future: _listado_details_inspeccion,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return _myListInspeccionDetails(context, snapshot.data);
                return Container(
                  margin: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Card(
                            elevation: 1,
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              child: Column(children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text.rich(
                                      TextSpan(
                                        text: 'Placa: ', // default text style
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: widget._inspeccion.i_placa,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17.0)),
                                        ],
                                      ),
                                      style: TextStyle(fontSize: 16.0)),
                                ),
                                SizedBox(height: 5.0),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text.rich(
                                      TextSpan(
                                        text:
                                            'Kilometraje (km): ', // default text style
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: widget
                                                  ._inspeccion.i_km_inspeccion,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17.0)),
                                        ],
                                      ),
                                      style: TextStyle(fontSize: 16.0)),
                                ),
                                SizedBox(height: 5.0),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text.rich(
                                      TextSpan(
                                        text: 'Fecha: ', // default text style
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: widget._inspeccion
                                                  .i_fecha_inspeccion,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17.0)),
                                        ],
                                      ),
                                      style: TextStyle(fontSize: 16.0)),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        elevation: 5,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchString = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                          child:
                              _myListInspeccionDetails(context, snapshot.data))
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error");
              }
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              ));
            },
          ),
        ));
  }

  Widget _myListInspeccionDetails(BuildContext context, data) {
    // backing data
    // snapshot.data[index].firstname.contains(searchString) && snapshot.data[index].lastname.contains(searchString)?

    return ListView.builder(
        itemCount: data.length,
        shrinkWrap: false,
        itemBuilder: (context, index) {
          return data[index].idt_serie.contains(searchString)
              ? ListTile(
                  onTap: () => {
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     content: Text("Serie: " + data[index].idt_serie)))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditInspeccion(
                                widget._id_cliente, data[index], widget._user)))
                  },
                  title: Text('Serie: ' + data[index].idt_serie,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 36, 76, 116),
                      child: Text("P-" + data[index].idt_posicion.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ))),
                  trailing: Icon(Icons.edit),
                )
              : Container();
        });
  }
}
