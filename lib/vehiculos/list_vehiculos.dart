import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/vehiculos/list_vehiculo_details.dart';
import 'package:tiresoft/vehiculos/models/vehiculo.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ListVehiculos extends StatefulWidget {
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;

  ListVehiculos(this._id_cliente, this._user, this._name_cliente, {Key? key})
      : super(key: key);

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
      // print("JSON:");
      // print(jsonData['success']['resultado']);

      String str_f_fabricacion = "-";
      String str_tipo = "-";

      for (var item in jsonData['success']['resultado']) {
        if (item["fecha_fabricacion"] != null) {
          str_f_fabricacion = item["fecha_fabricacion"];
        }

        _vehiculos.add(
          Vehiculo(
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
            item["fecha_registro"],
            item["n_neumaticos"].toString(),
            item["tipo_costo"].toString(),
            item["id_configuracion"].toString(),
          ),
        );
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
          title: Text("Reporte Vehículos"),
          centerTitle: true,
          backgroundColor: Color(0xff212F3D),
          elevation: 0.0,
        ),
        // drawer: CustomDrawer(widget._id_cliente),
        drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
        body: Container(
          child: FutureBuilder(
            future: _listadoVehiculos,
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
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                        ),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
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
        floatingActionButton: FutureBuilder(
          future: _listadoVehiculos,
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
                        await _generateExcelVehiculos(context, snapshot.data);
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

  Future<void> _generateExcelVehiculos(BuildContext context, data) async {
    print("Excel Vehiculo Export");
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1:L1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:L1').cellStyle.bold = true;
    sheet.getRangeByName('A1:L1').cellStyle.fontColor = '#FFFFFF';
    // > Columns
    sheet.getRangeByIndex(1, 1).setText('Id');
    sheet.getRangeByIndex(1, 2).setText('Código');
    sheet.getRangeByIndex(1, 3).setText('Placa');
    sheet.getRangeByIndex(1, 4).setText('Año Fabricación');
    sheet.getRangeByIndex(1, 5).setText('V. Tipo');
    sheet.getRangeByIndex(1, 6).setText('V. Marca');
    sheet.getRangeByIndex(1, 7).setText('V. Modelo');
    sheet.getRangeByIndex(1, 8).setText('V. Configuración');
    sheet.getRangeByIndex(1, 9).setText('V. Aplicación');
    sheet.getRangeByIndex(1, 10).setText('Planta');
    sheet.getRangeByIndex(1, 11).setText('Estado');
    sheet.getRangeByIndex(1, 12).setText('Fecha Registro');
    // > Rows
    int _row = 2;
    for (var i = 0; i < data.length; i++) {
      sheet.getRangeByIndex(_row, 1).setText(data[i].v_id.toString());
      sheet.getRangeByIndex(_row, 2).setText(data[i].v_codigo);
      sheet.getRangeByIndex(_row, 3).setText(data[i].v_placa);
      sheet.getRangeByIndex(_row, 4).setText(data[i].v_anio_fabricacion);
      sheet.getRangeByIndex(_row, 5).setText(data[i].v_tipo);
      sheet.getRangeByIndex(_row, 6).setText(data[i].v_marca);
      sheet.getRangeByIndex(_row, 7).setText(data[i].v_modelo);
      sheet.getRangeByIndex(_row, 8).setText(data[i].v_configuracion);
      sheet.getRangeByIndex(_row, 9).setText(data[i].v_aplicacion);
      sheet.getRangeByIndex(_row, 10).setText(data[i].v_planta);
      sheet.getRangeByIndex(_row, 11).setText(data[i].v_estado);
      sheet.getRangeByIndex(_row, 12).setText(data[i].v_f_registro);
      _row++;
    }
    final List<int> bytes = workbook.saveAsStream();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Vehiculos.xlsx';
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
                            vehiculo: data[index], cliente: widget._id_cliente),
                      ),
                    ),
                  },
                  title: Text(data[index].v_marca + " " + data[index].v_modelo,
                      style: TextStyle(fontWeight: FontWeight.w400)),
                  subtitle: Text(data[index].v_tipo +
                      ' ' +
                      data[index].v_aplicacion +
                      ' ' +
                      data[index].v_f_registro),
                  leading: CircleAvatar(
                      child: Text(
                    data[index].v_placa,
                    style: TextStyle(
                      fontSize: 9.0,
                    ),
                  )),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
