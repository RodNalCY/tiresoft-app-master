import 'package:flutter/material.dart';
import 'package:tiresoft/vehiculos/models/ubicacion_posicion.dart';
import 'package:tiresoft/vehiculos/models/vehiculo.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ListVehiculoDetails extends StatefulWidget {
  Vehiculo vehiculo;
  String cliente;

  ListVehiculoDetails({Key? key, required this.vehiculo, required this.cliente})
      : super(key: key);

  @override
  State<ListVehiculoDetails> createState() => _ListVehiculoDetailsState();
}

class _ListVehiculoDetailsState extends State<ListVehiculoDetails> {
  late final TextEditingController _txtEdFecha;
  late final TextEditingController _txtEdKmHr;
  final txtDateFormat = DateFormat("yyyy-MM-dd");

  late Future<List<UbicacionPosicion>> future_posiciones;
  List<UbicacionPosicion> _posicion = [];

  Future<List<UbicacionPosicion>> cargarpositionSuccess() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/showDatosNeumaticosPosicionHistorial"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id_cliente': widget.cliente,
        'vehiculo': {
          'id': widget.vehiculo.v_id,
          'id_configuracion': widget.vehiculo.v_id_configuracion,
          'tipo_costo': widget.vehiculo.v_id_tipo_costo,
        }
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print("Vehiculo Details");
      print(jsonData);

      for (var item in jsonData['success']['resultado']['posicion']) {
        _posicion.add(
          UbicacionPosicion(
              item['ubicacion'].toString(),
              item['posicion'] != null ? item['posicion'].toString() : '-',
              item['id_neumaticos'].toString()),
        );
      }
      return _posicion;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  @override
  void initState() {
    _txtEdFecha = TextEditingController();
    _txtEdKmHr = TextEditingController();
    future_posiciones = cargarpositionSuccess();
    super.initState();
  }

  @override
  void dispose() {
    _txtEdFecha.dispose();
    _txtEdKmHr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Placa: " + widget.vehiculo.v_placa),
        backgroundColor: Color(0xff212F3D),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: future_posiciones,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text('$error');
          } else if (snapshot.hasData) {
            return Container(
              color: Colors.black12,
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Codigo: ', // default text style
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget.vehiculo.v_codigo,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17.0),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text:
                                        'Configuración: ', // default text style
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget.vehiculo.v_configuracion,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17.0),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      text:
                                          'N° neumáticos: ', // default text style
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              widget.vehiculo.v_num_neumaticos,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text.rich(
                                    TextSpan(
                                      text:
                                          'Aplicación: ', // default text style
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: widget.vehiculo.v_aplicacion,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          DateTimeField(
                            initialValue: DateTime.now(),
                            controller: _txtEdFecha,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Fecha Instalación/Retiro",
                            ),
                            format: txtDateFormat,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));

                              return DateTimeField.tryParse(
                                  date.toString(), txtDateFormat);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _txtEdKmHr,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Km/Hr de Vehículo',
                            ),
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(
                            width: 130.0,
                            child: MaterialButton(
                              onPressed: () async {},
                              color: Color(0xff212F3D),
                              child: Text('Guardar',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              neumatico(context, snapshot.data, "A", 0),
                              neumatico(context, snapshot.data, "B", 1),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              neumatico(context, snapshot.data, "C", 4),
                              neumatico(context, snapshot.data, "D", 2),
                              neumatico(context, snapshot.data, "E", 3),
                              neumatico(context, snapshot.data, "F", 5),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              neumatico(context, snapshot.data, "G", 8),
                              neumatico(context, snapshot.data, "H", 6),
                              neumatico(context, snapshot.data, "I", 7),
                              neumatico(context, snapshot.data, "J", 9),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              neumatico(context, snapshot.data, "K", 12),
                              neumatico(context, snapshot.data, "L", 10),
                              neumatico(context, snapshot.data, "M", 11),
                              neumatico(context, snapshot.data, "N", 13),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              neumatico(context, snapshot.data, "O", 16),
                              neumatico(context, snapshot.data, "P", 14),
                              neumatico(context, snapshot.data, "Q", 15),
                              neumatico(context, snapshot.data, "R", 17),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              neumatico(context, snapshot.data, "S", 20),
                              neumatico(context, snapshot.data, "T", 18),
                              neumatico(context, snapshot.data, "U", 19),
                              neumatico(context, snapshot.data, "V", 21),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade500),
              ),
            );
          }
        },
      ),
    );
  }

  Widget neumatico(BuildContext context, data, String letter, int i) {
    Widget result = Container();
    int order = i;
    String ubicacion = (order + 1).toString();

    if (validate(data, order, ubicacion) == 1) {
      result = positionSuccess(context, letter + "-" + data![order].v_posicion);
    } else if (validate(data, order, ubicacion) == 2) {
      result = positionLocked(context, letter + "-" + data![order].v_posicion);
    }
    return result;
  }

  int validate(data, int order, String ubicacion) {
    int status = 0;

    if (data[order].v_ubicacion == ubicacion &&
        data[order].v_posicion != '-' &&
        data[order].v_neumatico != '-') {
      status = 1;
    } else if (data[order].v_ubicacion == ubicacion &&
        data[order].v_posicion != '-' &&
        data[order].v_neumatico == '-') {
      status = 2;
    }
    return status;
  }

  Center positionLocked(BuildContext context, String name) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            tooltip: name,
            iconSize: 55,
            icon: Image.asset(
              'assets/neumatico2.jpg',
            ),
            onPressed: null,
          ),
          Container(
            padding: EdgeInsets.only(right: 2, left: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center positionSuccess(BuildContext context, String name) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            tooltip: name,
            iconSize: 55,
            icon: Image.asset(
              'assets/neumatico1.jpg',
            ),
            onPressed: () {
              showOptionDialog(context, name);
            },
          ),
          Container(
            padding: EdgeInsets.only(right: 2, left: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showOptionDialog(BuildContext context, String name) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "Desea desinstalar la posición: \n" + name,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 32.0,
                        color: Colors.red,
                      ),
                      Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // POST
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.double_arrow,
                        size: 32.0,
                        color: Colors.blue,
                      ),
                      Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
