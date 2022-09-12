import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/mal_estado/models/neumatico_mal_estado.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

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
        if (item["fecha_scrap"] != null) {
          str_fechita = item["fecha_scrap"];
        }
        _mal_estados.add(NeumaticoMalEstado(
            item["id"],
            item["nombre_estado"],
            item["num_serie"],
            item['marca'],
            item['modelo'],
            item['medida'],
            item['disenio'],
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
                  Card(
                    elevation: 5.0,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Expanded(child: _myListMalEstado(context, snapshot.data))
                ]),
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: _listado_mal_estado,
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Para descargar el archivo .xlsx'),
                content: const Text(
                    '¿Tiene la aplicación compatible para abrir el archivo excel?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await _launchUrlAppStore();
                      Navigator.of(context).pop();
                    },
                    child: const Text('No, Descargar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _generateExcelMalEstado(context, snapshot.data);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Si, Exportar'),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.green,
            child: const Icon(Icons.file_download),
          );
        },
      ),
    ));
  }

  Future<void> _generateExcelMalEstado(BuildContext context, data) async {
    print("Excel Mal Estado Export");
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1:L1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:L1').cellStyle.bold = true;
    sheet.getRangeByName('A1:L1').cellStyle.fontColor = '#FFFFFF';
    // > Columns
    sheet.getRangeByIndex(1, 1).setText('Id');
    sheet.getRangeByIndex(1, 2).setText('Num. Serie');
    sheet.getRangeByIndex(1, 3).setText('Marca');
    sheet.getRangeByIndex(1, 4).setText('Modelo');
    sheet.getRangeByIndex(1, 5).setText('Medida');
    sheet.getRangeByIndex(1, 6).setText('Diseño');
    sheet.getRangeByIndex(1, 7).setText('R. Final');
    sheet.getRangeByIndex(1, 8).setText('R. Límite');
    sheet.getRangeByIndex(1, 9).setText('Disponibilidad');
    sheet.getRangeByIndex(1, 10).setText('Costo (\$)');
    sheet.getRangeByIndex(1, 11).setText('Costo de Pérdida (\$)');
    sheet.getRangeByIndex(1, 12).setText('Fecha Retiro');
    // > Rows
    int _row = 2;
    for (var i = 0; i < data.length; i++) {
      sheet.getRangeByIndex(_row, 1).setText(data[i].nme_id.toString());
      sheet.getRangeByIndex(_row, 2).setText(data[i].nme_num_serie);
      sheet.getRangeByIndex(_row, 3).setText(data[i].nme_marca);
      sheet.getRangeByIndex(_row, 4).setText(data[i].nme_modelo);
      sheet.getRangeByIndex(_row, 5).setText(data[i].nme_medida);
      sheet.getRangeByIndex(_row, 6).setText(data[i].nme_disenio);
      sheet.getRangeByIndex(_row, 7).setText(data[i].nme_remanente_final);
      sheet.getRangeByIndex(_row, 8).setText(data[i].nme_remanente_limite);
      sheet.getRangeByIndex(_row, 9).setText(data[i].nme_disponibilidad);
      sheet.getRangeByIndex(_row, 10).setText(data[i].nme_costo);
      sheet.getRangeByIndex(_row, 11).setText(data[i].nme_costo_perdida);
      sheet.getRangeByIndex(_row, 12).setText(data[i].nme_fecha_retiro);
      _row++;
    }

    final List<int> bytes = workbook.saveAsStream();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Neumaticos_Mal_Estado.xlsx';
    final File file = File(fileName);
    final _write = await file.writeAsBytes(bytes, flush: true);
    final _open = OpenFile.open(fileName);
    workbook.dispose();
  }

  Future<void> _launchUrlAppStore() async {
    final Uri _url =
        Uri.parse('https://play.google.com/store/search?q=excel&c=apps');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
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
                      data[index].nme_marca +
                          " " +
                          data[index].nme_modelo +
                          " " +
                          data[index].nme_medida,
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
