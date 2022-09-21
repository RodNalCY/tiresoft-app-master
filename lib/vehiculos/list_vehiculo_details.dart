import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/vehiculos/models/ubicacion_posicion.dart';
import 'package:tiresoft/vehiculos/models/vehiculo.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ListVehiculoDetails extends StatefulWidget {
  Vehiculo vehiculo;
  final List<User> user;
  String cliente;

  ListVehiculoDetails(
      {Key? key,
      required this.vehiculo,
      required this.user,
      required this.cliente})
      : super(key: key);

  @override
  State<ListVehiculoDetails> createState() => _ListVehiculoDetailsState();
}

class _ListVehiculoDetailsState extends State<ListVehiculoDetails> {
  late final TextEditingController _txtEdFecha;
  bool _validateFechita = false;
  String messageValidateFecha = "";
  late final TextEditingController _txtEdKmHr;
  bool _validateKmHr = false;
  final txtDateFormat = DateFormat("yyyy-MM-dd");
  String messageValidateKmHr = "";

  late Future<List<UbicacionPosicion>> future_posiciones;
  List<UbicacionPosicion> _posicion = [];

  late Map<String, dynamic> retirados;
  String map_neumaticos = "";

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

  List<String> listaMotivoRetiro = [
    'POR REENCAUCHE',
    'POR REPARACIÓN',
    'POR ROTACIÓN',
    'POR DESGASTE FINAL',
    'POR FALLA',
  ];
  int motivoRetiroIdSelected = 1;

  bool status_A = false;
  bool status_B = false;
  bool status_C = false;
  bool status_D = false;
  bool status_E = false;
  bool status_F = false;
  bool status_G = false;
  bool status_H = false;
  bool status_I = false;
  bool status_J = false;
  bool status_K = false;
  bool status_L = false;
  bool status_N = false;
  bool status_M = false;
  bool status_O = false;
  bool status_P = false;
  bool status_Q = false;
  bool status_R = false;
  bool status_S = false;
  bool status_T = false;
  bool status_U = false;
  bool status_V = false;

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
              height: double.infinity,
              color: Colors.black12,
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text.rich(
                                      TextSpan(
                                        text:
                                            'N° neumáticos: ', // default text style
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: widget
                                                .vehiculo.v_num_neumaticos,
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
                            messageValidateKmHr != ""
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 15, left: 5, right: 5),
                                    child: Text(
                                      messageValidateKmHr,
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  )
                                : Container(),
                            TextFormField(
                              controller: _txtEdKmHr,
                              keyboardType: TextInputType.number,
                              onChanged: (val) => validateFutureKmHr(val),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Km/Hr de Vehículo',
                                errorText: _validateKmHr
                                    ? 'Km/Hr es un campo obligatorio'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            messageValidateFecha != ""
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 15, left: 5, right: 5),
                                    child: Text(
                                      messageValidateFecha,
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  )
                                : Container(),
                            DateTimeField(
                              initialValue: DateTime.now(),
                              controller: _txtEdFecha,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Fecha Instalación/Retiro",
                                errorText: _validateFechita
                                    ? 'Fecha de inspección es un campo obligatorio'
                                    : null,
                              ),
                              format: txtDateFormat,
                              onChanged: (val) => validateFutureFechita(val),
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
                            SizedBox(height: 20.0),
                            SizedBox(
                              width: 130.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  if (!validateFormIsEmpty()) {
                                    enviarListaRetirado();
                                  }
                                },
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
                                status_A
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "A", 0),
                                status_B
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "B", 1),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                status_C
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "C", 4),
                                status_D
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "D", 2),
                                status_E
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "E", 3),
                                status_F
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "F", 5),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                status_G
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "G", 8),
                                status_H
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "H", 6),
                                status_I
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "I", 7),
                                status_J
                                    ? positionRetirado()
                                    : neumatico(context, snapshot.data, "J", 9),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                status_K
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "K", 12),
                                status_L
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "L", 10),
                                status_M
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "M", 11),
                                status_N
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "N", 13),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                status_O
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "O", 16),
                                status_P
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "P", 14),
                                status_Q
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "Q", 15),
                                status_R
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "R", 17),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                status_S
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "S", 20),
                                status_T
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "T", 18),
                                status_U
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "U", 19),
                                status_V
                                    ? positionRetirado()
                                    : neumatico(
                                        context, snapshot.data, "V", 21),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
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
      result = positionSuccess(context, letter + "-" + data![order].v_posicion,
          data![order].v_neumatico);
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

  Center positionRetirado() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            tooltip: "",
            iconSize: 55,
            icon: Image.asset(
              'assets/neumatico3.jpg',
            ),
            onPressed: null,
          ),
          Container(
            padding: EdgeInsets.only(right: 2, left: 2),
            decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0.2),
                ),
            child: Text(
              "",
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

  Center positionSuccess(BuildContext context, String name, String neumatico) {
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
              showOptionDialog(context, name, neumatico);
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

  Future<void> showOptionDialog(
      BuildContext context, String name, String neumatico) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                "Desea retirar el neumatico de la posición: " + name,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new DropdownButton<String>(
                      icon: const Icon(Icons.unfold_more,
                          color: Color(0xff2874A6)),
                      value: motivoRetiroIdSelected.toString(),
                      items:
                          <String>['1', '2', '3', '4', '5'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(listaMotivoRetiro[int.parse(value) - 1]),
                        );
                      }).toList(),
                      onChanged: (_val) {
                        setState(() {
                          motivoRetiroIdSelected = int.parse(_val.toString());
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
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
                        selectedRemoveNeumatico(context, name, neumatico);
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
                SizedBox(
                  height: 10.0,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> enviarListaRetirado() async {
    if (map_neumaticos.length > 0) {
      final ultimo = map_neumaticos.length - 1;
      final neumaticos_retirados = map_neumaticos.substring(0, ultimo);
      retirados = {
        "id_cliente": widget.cliente,
        "id_usuario": widget.user[0].u_id,
        "id_vehiculo": widget.vehiculo.v_id,
        "fecha_retiro": _txtEdFecha.text.toString(),
        "km_retiro": _txtEdKmHr.text.toString(),
        "retirados": [neumaticos_retirados]
      };
      print('> ${retirados}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Debe desinstalar por lo menos un neumático.")),
      );
    }
  }

  Future<void> selectedRemoveNeumatico(
      BuildContext context, String name, String id) async {
    map_neumaticos = map_neumaticos +
        '{' +
        '"id_neumatico":${id},' +
        '"motivo_retiro":${motivoRetiroIdSelected}' +
        '}' +
        ',';

    String neumatico_name = name.substring(0, 1);
    switch (neumatico_name) {
      case "A":
        setState(() {
          status_A = true;
        });
        break;
      case "B":
        setState(() {
          status_B = true;
        });
        break;
      case "C":
        setState(() {
          status_C = true;
        });
        break;
      case "D":
        setState(() {
          status_D = true;
        });
        break;
      case "E":
        setState(() {
          status_E = true;
        });
        break;
      case "F":
        setState(() {
          status_F = true;
        });
        break;
      case "G":
        setState(() {
          status_G = true;
        });
        break;
      case "H":
        setState(() {
          status_H = true;
        });
        break;
      case "I":
        setState(() {
          status_I = true;
        });
        break;
      case "J":
        setState(() {
          status_J = true;
        });
        break;
      case "K":
        setState(() {
          status_K = true;
        });
        break;
      case "L":
        setState(() {
          status_L = true;
        });
        break;
      case "M":
        setState(() {
          status_M = true;
        });
        break;
      case "N":
        setState(() {
          status_N = true;
        });
        break;
      case "O":
        setState(() {
          status_O = true;
        });
        break;
      case "P":
        setState(() {
          status_P = true;
        });
        break;
      case "Q":
        setState(() {
          status_Q = true;
        });
        break;
      case "R":
        setState(() {
          status_R = true;
        });
        break;
      case "S":
        setState(() {
          status_S = true;
        });
        break;
      case "T":
        setState(() {
          status_T = true;
        });
        break;
      case "U":
        setState(() {
          status_U = true;
        });
        break;
      case "V":
        setState(() {
          status_V = true;
        });
        break;
    }

    Navigator.of(context).pop();
  }

  Future<bool> validateFutureKmHr(value) async {
    bool state = false;
    if (!(_txtEdKmHr.text.isEmpty)) {
      state = false;

      final response = await http.post(
        Uri.parse(
            "https://tiresoft2.lab-elsol.com/api/vehiculos/validateKilometraje"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'clienteId': widget.cliente,
          'id_vehiculo': widget.vehiculo.v_id,
          'km': value.toString(),
        }),
      );

      if (response.statusCode == 500) {
        var responseDecode = json.decode(response.body);
        var message = responseDecode['error'];
        setState(() {
          messageValidateKmHr = message.toString();
        });
      } else {
        setState(() {
          messageValidateKmHr = "";
        });
      }
    } else {
      state = true;
    }

    setState(() {
      _validateKmHr = state;
    });
    return state;
  }

  Future<bool> validateFutureFechita(value) async {
    bool state = false;
    if (!(_txtEdFecha.text.isEmpty)) {
      state = false;

      var newFormat = DateFormat("yyyy-MM-dd");
      String updatedDt = newFormat.format(value!);

      final response = await http.post(
        Uri.parse(
            "https://tiresoft2.lab-elsol.com/api/vehiculos/validateFechaInspeccion"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'clienteId': widget.cliente,
          'id_vehiculo': widget.vehiculo.v_id,
          'fecha_inspeccion': updatedDt,
        }),
      );

      if (response.statusCode == 500) {
        var responseDecode = json.decode(response.body);
        var message = responseDecode['error'];
        setState(() {
          messageValidateFecha = message.toString();
        });
      } else {
        setState(() {
          messageValidateFecha = "";
        });
      }
    } else {
      state = true;
    }

    setState(() {
      _validateFechita = state;
    });
    return state;
  }

  bool validateFormIsEmpty() {
    bool statusEmpty = false;
    if (_txtEdKmHr.text.isEmpty && _txtEdFecha.text.isEmpty) {
      statusEmpty = true;
      setState(() {
        _validateKmHr = statusEmpty;
        _validateFechita = statusEmpty;
      });
    } else if (_txtEdKmHr.text.isEmpty) {
      statusEmpty = true;
      setState(() {
        _validateKmHr = statusEmpty;
      });
    } else if (_txtEdFecha.text.isEmpty) {
      statusEmpty = true;
      setState(() {
        _validateFechita = statusEmpty;
      });
    }

    return statusEmpty;
  }
}
