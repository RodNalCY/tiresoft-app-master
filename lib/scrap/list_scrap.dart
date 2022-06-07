import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/scrap/Models/Scrapt.dart';
import 'package:tiresoft/scrap/list_scrapt_details.dart';
import 'dart:convert';

import 'package:tiresoft/widgets/custom_drawer.dart';

class ListScrap extends StatefulWidget {
  final String _id_cliente;

  ListScrap(this._id_cliente, {Key? key}) : super(key: key);

  @override
  State<ListScrap> createState() => _ListScrapState();
}

class _ListScrapState extends State<ListScrap> {
  late Future<List<Scrapt>> _listadoScrap;
  String searchString = "";

  Future<List<Scrapt>> _postListScrap() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/scrap/listaNeumaticoScrap"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    List<Scrapt> _scrap = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData['success']['resultado']);

      for (var item in jsonData['success']['resultado']) {
        var _img_ruta_uno = "-";
        var _img_ruta_dos = "-";
        var _motivo_scrap = "-";
        var _fecha_scrap = "-";

        if (item["neumaticoimgruta1"] != null) {
          _img_ruta_uno = item["neumaticoimgruta1"];
        }

        if (item["neumaticoimgruta2"] != null) {
          _img_ruta_dos = item["neumaticoimgruta2"];
        }

        if (item["motivo_scrap"] != "") {
          _motivo_scrap = item["motivo_scrap"];
        }

        if (item["fecha_scrap"] != "0000-00-00") {
          _fecha_scrap = item["fecha_scrap"];
        }

        _scrap.add(Scrapt(
          item["id"],
          item["num_serie"],
          item["marca"],
          item["modelo"],
          item["medida"],
          _motivo_scrap,
          _fecha_scrap,
          item["remanente_final"],
          item["remanente_limite"],
          _img_ruta_uno,
          _img_ruta_dos,
        ));
      }

      return _scrap;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoScrap = _postListScrap();
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
          future: _listadoScrap,
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
                        hintText: 'buscar x serie',
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Expanded(child: _myListScrap(context, snapshot.data))
                ]),
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

  Widget _myListScrap(BuildContext context, data) {
    // backing data
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return data[index].s_serie.contains(searchString)
            ? Card(
                child: ListTile(
                  onTap: () => {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text("Serie: " + data[index].n_serie)))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListScraptDetails(
                                data[index], data[index].s_serie)))
                  },
                  title: Text(
                    'Serie: ' + data[index].s_serie,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(data[index].s_motivo_scrap +
                      ' \n' +
                      data[index].s_fecha_scrap),
                  leading: CircleAvatar(
                      child: Text(data[index].s_marca.substring(0, 1))),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
