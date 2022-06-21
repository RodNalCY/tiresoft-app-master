import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/neumaticos/list_neumatico_details.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListNeumaticos extends StatefulWidget {
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;

  ListNeumaticos(this._id_cliente, this._user, this._name_cliente, {Key? key})
      : super(key: key);

  @override
  State<ListNeumaticos> createState() => _ListNeumaticosState();
}

class _ListNeumaticosState extends State<ListNeumaticos> {
  late Future<List<Neumatico>> _listadoNeumaticos;
  String searchString = "";

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
          title: Text("Reporte Neumáticos"),
          centerTitle: true,
          backgroundColor: Color(0xff212F3D),
          elevation: 0.0,
        ),
        // drawer: CustomDrawer(widget._id_cliente),
        drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
        body: Container(
          child: FutureBuilder(
            future: _listadoNeumaticos,
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
                          // hintText: 'buscar x serie',
                        ),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Expanded(child: _myListNeumaticos(context, snapshot.data))
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

  Widget _myListNeumaticos(BuildContext context, data) {
    // backing data
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        return data[index].n_serie.contains(searchString)
            ? Card(
                child: ListTile(
                  onTap: () => {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text("Serie: " + data[index].n_serie)))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListNeumaticosDetails(
                                data[index], data[index].n_serie)))
                  },
                  title: Text(
                    'Serie: ' + data[index].n_serie,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(data[index].n_marca +
                      ' ' +
                      data[index].n_modelo +
                      ' ' +
                      data[index].n_medida),
                  leading: CircleAvatar(
                      child: Text(data[index].n_marca.substring(0, 1))),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
