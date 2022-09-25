import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/neumaticos/list_neumatico_details.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';
import 'package:tiresoft/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

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
          item["fecha_registro"],
          item["disenio"],
          item["precio_soles"],
          item["precio"],
        ));
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte Neumáticos"),
        centerTitle: true,
        backgroundColor: Color(0xff212F3D),
        elevation: 0.0,
      ),
      // drawer: CustomDrawer(widget._id_cliente),
      drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
      body: Container(
        color: Color.fromARGB(255, 227, 235, 243),
        child: FutureBuilder(
          future: _listadoNeumaticos,
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
                  Expanded(child: _myListNeumaticos(context, snapshot.data))
                ]),
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          },
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: _listadoNeumaticos,
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
                      await _generateExcelNeumaticos(context, snapshot.data);
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
    );
  }

  Future<void> _generateExcelNeumaticos(BuildContext context, data) async {
    print("Excel Vehiculo Export");
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1:L1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:L1').cellStyle.bold = true;
    sheet.getRangeByName('A1:L1').cellStyle.fontColor = '#FFFFFF';
    // > Columns
    sheet.getRangeByIndex(1, 1).setText('Id');
    sheet.getRangeByIndex(1, 2).setText('Nro. Serie');
    sheet.getRangeByIndex(1, 3).setText('Marca');
    sheet.getRangeByIndex(1, 4).setText('Modelo');
    sheet.getRangeByIndex(1, 5).setText('Medida');
    sheet.getRangeByIndex(1, 6).setText('Diseño');
    sheet.getRangeByIndex(1, 7).setText('Costo (\$)');
    sheet.getRangeByIndex(1, 8).setText('Costo (S/)');
    sheet.getRangeByIndex(1, 9).setText('Condición del Neumático');
    sheet.getRangeByIndex(1, 10).setText('Estado');
    sheet.getRangeByIndex(1, 11).setText('Vehículo');
    sheet.getRangeByIndex(1, 12).setText('Fecha Registro');
    // > Rows
    int _row = 2;
    for (var i = 0; i < data.length; i++) {
      sheet.getRangeByIndex(_row, 1).setText(data[i].n_id.toString());
      sheet.getRangeByIndex(_row, 2).setText(data[i].n_serie);
      sheet.getRangeByIndex(_row, 3).setText(data[i].n_marca);
      sheet.getRangeByIndex(_row, 4).setText(data[i].n_modelo);
      sheet.getRangeByIndex(_row, 5).setText(data[i].n_medida);
      sheet.getRangeByIndex(_row, 6).setText(data[i].n_disenio);
      sheet.getRangeByIndex(_row, 7).setText(data[i].n_costo_dolares);
      sheet.getRangeByIndex(_row, 8).setText(data[i].n_costo_soles);
      sheet.getRangeByIndex(_row, 9).setText(data[i].n_condicion);
      sheet.getRangeByIndex(_row, 10).setText(data[i].n_estado);
      sheet.getRangeByIndex(_row, 11).setText(data[i].n_vehiculo);
      sheet.getRangeByIndex(_row, 12).setText(data[i].n_f_registro);
      _row++;
    }
    final List<int> bytes = workbook.saveAsStream();
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Neumaticos.xlsx';
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

  Widget _myListNeumaticos(BuildContext context, data) {
    // backing data
    double size_serie = 0;
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        size_serie = 0;
        if ((data[index].n_serie).toString().length >= 6) {
          size_serie = 9.0;
        } else {
          size_serie = 12.0;
        }

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
                    data[index].n_marca +
                        ' ' +
                        data[index].n_modelo +
                        ' ' +
                        data[index].n_medida,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                      data[index].n_estado + ' ' + data[index].n_f_registro),
                  leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 36, 76, 116),
                      child: Text(
                        data[index].n_serie,
                        style: TextStyle(
                            fontSize: size_serie,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      )),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              )
            : Container();
      },
    );
  }
}
