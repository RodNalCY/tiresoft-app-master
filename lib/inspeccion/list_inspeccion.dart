import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/inspeccion/list_inspeccion_details.dart';
import 'dart:convert';

import 'package:tiresoft/inspeccion/models/inspeccion.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ListInspeccion extends StatefulWidget {
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;

  ListInspeccion(this._id_cliente, this._user, this._name_cliente, {Key? key})
      : super(key: key);

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
        _inspeccion.add(Inspeccion(
          item["id"],
          str_identificador,
          item["placa"],
          item["km_inspeccion"],
          item["fecha_inspeccion"],
          item["insp_codigo"],
          item["vehi_codigo"],
          item["vehi_tipo"],
          item["vehi_marca"],
          item["vehi_modelo"],
          item["vehi_configuracion"],
        ));
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
          title: Text("Reporte Inspección"),
          centerTitle: true,
          backgroundColor: Color(0xff212F3D),
          elevation: 0.0,
        ),
        // drawer: CustomDrawer(widget._id_cliente),
        drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
        body: Container(
          child: FutureBuilder(
            future: _listadoInspeccion,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return _myListInspeccion(context, snapshot.data);
                return Container(
                  child: Column(children: <Widget>[
                    Card(
                      elevation: 5,
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
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                        ),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 2.0),
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
        floatingActionButton: FutureBuilder(
          future: _listadoInspeccion,
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
                        await _generateExcelInspeccion(context, snapshot.data);
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
      ),
    );
  }

  Future<void> _launchUrlAppStore() async {
    final Uri _url =
        Uri.parse('https://play.google.com/store/search?q=excel&c=apps');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
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
                                data[index].i_identificador,
                                this.widget._user)))
                  },
                  title: Text('Placa: ' + data[index].i_placa,
                      style: TextStyle(fontWeight: FontWeight.w400)),
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

  Future<void> _generateExcelInspeccion(BuildContext context, data) async {
    print("Excel Inspeccion Export");
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1:J1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:J1').cellStyle.bold = true;
    sheet.getRangeByName('A1:J1').cellStyle.fontColor = '#FFFFFF';
    // > Columns
    sheet.getRangeByIndex(1, 1).setText('Identificador');
    sheet.getRangeByIndex(1, 2).setText('Cod. Inpección');
    sheet.getRangeByIndex(1, 3).setText('Cod. Vehículo');
    sheet.getRangeByIndex(1, 4).setText('V. Placa');
    sheet.getRangeByIndex(1, 5).setText('V. Tipo');
    sheet.getRangeByIndex(1, 6).setText('V. Marca');
    sheet.getRangeByIndex(1, 7).setText('V. Modelo');
    sheet.getRangeByIndex(1, 8).setText('V. Configuración');
    sheet.getRangeByIndex(1, 9).setText('Km/Hr de Inspección');
    sheet.getRangeByIndex(1, 10).setText('Fecha Inspección');
    // > Rows
    int _row = 2;
    for (var i = 0; i < data.length; i++) {
      sheet.getRangeByIndex(_row, 1).setText(data[i].i_identificador);
      sheet.getRangeByIndex(_row, 2).setText(data[i].i_cod_inspeccion);
      sheet.getRangeByIndex(_row, 3).setText(data[i].i_cod_vehiculo);
      sheet.getRangeByIndex(_row, 4).setText(data[i].i_placa);
      sheet.getRangeByIndex(_row, 5).setText(data[i].i_vh_tipo);
      sheet.getRangeByIndex(_row, 6).setText(data[i].i_vh_marca);
      sheet.getRangeByIndex(_row, 7).setText(data[i].i_vh_modelo);
      sheet.getRangeByIndex(_row, 8).setText(data[i].i_vh_configuracion);
      sheet.getRangeByIndex(_row, 9).setText(data[i].i_km_inspeccion);
      sheet.getRangeByIndex(_row, 10).setText(data[i].i_fecha_inspeccion);
      _row++;
    }
    final List<int> bytes = workbook.saveAsStream();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Inspecciones.xlsx';
    final File file = File(fileName);
    final _write = await file.writeAsBytes(bytes, flush: true);
    final _open = OpenFile.open(fileName);
    workbook.dispose();
  }
}
