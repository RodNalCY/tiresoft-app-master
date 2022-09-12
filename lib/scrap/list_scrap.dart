import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/scrap/Models/Scrapt.dart';
import 'package:tiresoft/scrap/list_scrapt_details.dart';
import 'dart:convert';
import 'package:tiresoft/widgets/custom_drawer.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ListScrap extends StatefulWidget {
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;
  ListScrap(this._id_cliente, this._user, this._name_cliente, {Key? key})
      : super(key: key);

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
      // print(jsonData['success']['resultado']);

      for (var item in jsonData['success']['resultado']) {
        var _img_ruta_uno = "-";
        var _img_ruta_dos = "-";
        var _motivo_scrap = "-";
        var _fecha_scrap = "-";

        if (item["neumaticoimgruta1"] != null) {
          _img_ruta_uno =
              "https://tiresoft2.lab-elsol.com/" + item["neumaticoimgruta1"];
        }

        if (item["neumaticoimgruta2"] != null) {
          _img_ruta_dos =
              "https://tiresoft2.lab-elsol.com/" + item["neumaticoimgruta2"];
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
          item["disenio"],
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
        title: Text("Reporte Scrap"),
        centerTitle: true,
        backgroundColor: Color(0xff212F3D),
        elevation: 0.0,
      ),
      // drawer: CustomDrawer(widget._id_cliente),
      drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
      body: Container(
        child: FutureBuilder(
          future: _listadoScrap,
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
      floatingActionButton: FutureBuilder(
        future: _listadoScrap,
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
                      await _generateExcelScrap(context, snapshot.data);
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

  Future<void> _generateExcelScrap(BuildContext context, data) async {
    print("Excel Scrap Export");
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
    sheet.getRangeByIndex(1, 9).setText('Motivo Scrap');
    sheet.getRangeByIndex(1, 10).setText('Fecha Scrap');
    sheet.getRangeByIndex(1, 11).setText('Imagen (1°)');
    sheet.getRangeByIndex(1, 12).setText('Imagen (2°)');
    // > Rows
    int _row = 2;
    for (var i = 0; i < data.length; i++) {
      sheet.getRangeByIndex(_row, 1).setText(data[i].s_id.toString());
      sheet.getRangeByIndex(_row, 2).setText(data[i].s_serie);
      sheet.getRangeByIndex(_row, 3).setText(data[i].s_marca);
      sheet.getRangeByIndex(_row, 4).setText(data[i].s_modelo);
      sheet.getRangeByIndex(_row, 5).setText(data[i].s_medida);
      sheet.getRangeByIndex(_row, 6).setText(data[i].s_disenio);
      sheet.getRangeByIndex(_row, 7).setText(data[i].s_remanente_final);
      sheet.getRangeByIndex(_row, 8).setText(data[i].s_remanente_limite);
      sheet.getRangeByIndex(_row, 9).setText(data[i].s_motivo_scrap);
      sheet.getRangeByIndex(_row, 10).setText(data[i].s_fecha_scrap);
      sheet.getRangeByIndex(_row, 11).setText(data[i].s_neumatico_ruta_1);
      sheet.getRangeByIndex(_row, 12).setText(data[i].s_neumatico_ruta_2);
      _row++;
    }

    final List<int> bytes = workbook.saveAsStream();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Scraps.xlsx';
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
                    data[index].s_marca +
                        " " +
                        data[index].s_modelo +
                        " " +
                        data[index].s_medida,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(data[index].s_motivo_scrap +
                      ' \n' +
                      data[index].s_fecha_scrap),
                  leading: CircleAvatar(
                      child: Text(data[index].s_serie,
                          style: TextStyle(fontSize: 10.0))),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
