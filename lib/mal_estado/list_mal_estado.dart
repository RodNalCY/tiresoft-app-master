import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/mal_estado/models/neumatico_mal_estado.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';
import 'package:http/http.dart' as http;

class ListMalEstado extends StatefulWidget {
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;

  ListMalEstado(this._id_cliente, this._user, this._name_cliente, {Key? key})
      : super(key: key);

  @override
  State<ListMalEstado> createState() => _ListMalEstadoState();
}

class _ListMalEstadoState extends State<ListMalEstado> {
  late Future<List<NeumaticoMalEstado>> _listado_mal_estado;
  String searchString = "";

  Future<List<NeumaticoMalEstado>> _postMalEstado() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/neumaticos/listNeumaticoMalEstado"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    List<NeumaticoMalEstado> _mal_estados = [];
    String str_rm_original = "-";
    String str_rm_final = "-";
    String str_rm_limite = "-";
    String str_fechita = "-";
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print("JSON Mal Estado:");
      print(jsonData['success']['resultado']);
      for (var item in jsonData['success']['resultado']) {
        if (item["remanente_final"] != null) {
          str_rm_final = item["remanente_final"];
        }
        if (item["remanente_original"] != null) {
          str_rm_original = item["remanente_original"];
        }
        if (item["remanente_limite"] != null) {
          str_rm_limite = item["remanente_limite"];
        }
        if (item["fecha_retiro"] != null) {
          str_fechita = item["fecha_retiro"];
        }
        _mal_estados.add(NeumaticoMalEstado(
            item["id"],
            item["nombre_estado"],
            item["num_serie"],
            item['marca'],
            item['modelo'],
            item['medida'],
            str_fechita,
            str_rm_original,
            str_rm_final,
            str_rm_limite,
            item["precio"],
            item["costo_perdido"]));
      }

      return _mal_estados;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listado_mal_estado = _postMalEstado();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Neumáticos en mal estado"),
        centerTitle: true,
        backgroundColor: Color(0xff212F3D),
        elevation: 0.0,
      ),
      drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
      body: Container(
        child: FutureBuilder(
          future: _listado_mal_estado,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                        // hintText: 'buscar x placa',
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Expanded(child: _myListMalEstado(context, snapshot.data))
                ]),
              );
              return Container(
                child: Text("Hola Boba"),
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ));
  }

  Widget _myListMalEstado(BuildContext context, data) {
    // backing data
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        return data[index].nme_num_serie.contains(searchString)
            ? Card(
                child: ListTile(
                  onTap: () => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Serie: " + data[index].nme_num_serie)))
                  },
                  title: Text(
                      data[index].nme_marca + " " + data[index].nme_modelo,
                      style: TextStyle(fontWeight: FontWeight.w400)),
                  subtitle: Text(data[index].nme_disponibilidad +
                      " - " +
                      data[index].nme_fecha_retiro),
                  leading: CircleAvatar(
                      child: Text(data[index].nme_num_serie,
                          style: TextStyle(fontSize: 10.0))),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
