import 'package:flutter/material.dart';
import 'package:tiresoft/vehiculos/list_vehiculo_details.dart';
import 'package:tiresoft/vehiculos/models/vehiculo.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListVehiculos extends StatefulWidget {
  final String _id_cliente;

  ListVehiculos(this._id_cliente, {Key? key}) : super(key: key);

  @override
  State<ListVehiculos> createState() => _ListVehiculosState();
}

class _ListVehiculosState extends State<ListVehiculos> {
  late Future<List<Vehiculo>> _listadoVehiculos;
  String searchString = "";

  Future<List<Vehiculo>> _postVehiculos() async {
    final response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/listaVehiculos"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    List<Vehiculo> _vehiculos = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print("JSON:");
      print(jsonData['success']['resultado']);

      String str_f_fabricacion = "-";
      String str_tipo = "-";

      for (var item in jsonData['success']['resultado']) {
        if (item["fecha_fabricacion"] != null) {
          str_f_fabricacion = item["fecha_fabricacion"];
        }

        _vehiculos.add(Vehiculo(
            item["id"],
            item["placa"],
            item["codigo"],
            item["tipo"],
            item["marca"],
            item["modelo"],
            item["configuracion"],
            item["aplicacion"],
            item["nomplanta"],
            item["nomestado"],
            str_f_fabricacion,
            item["fecha_registro"]));
      }

      return _vehiculos;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoVehiculos = _postVehiculos();
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
        body: Container(
          child: FutureBuilder(
            future: _listadoVehiculos,
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
                          hintText: 'buscar x placa',
                        ),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Expanded(child: _myListVehiculos(context, snapshot.data))
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

  Widget _myListVehiculos(BuildContext context, data) {
    // backing data
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        return data[index].v_placa.contains(searchString)
            ? Card(
                child: ListTile(
                  onTap: () => {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text("Placa: " + data[index].v_placa)))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListVehiculoDetails(
                                data[index], data[index].v_placa)))
                  },
                  title: Text(
                      'Placa: ' +
                          data[index].v_placa +
                          ' - ' +
                          data[index].v_tipo,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(data[index].v_marca +
                      ' ' +
                      data[index].v_modelo +
                      ' ' +
                      data[index].v_configuracion),
                  leading: CircleAvatar(
                      child: Text(data[index].v_marca.substring(0, 1))),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
