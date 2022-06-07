import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:tiresoft/inspection/models/vehicle.dart';
import 'package:tiresoft/inspection/record_inspection_detail.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tiresoft/widgets/custom_drawer.dart';

class RecordInspectionHeader extends StatefulWidget {
  final String title = 'Registration';
  final String _id_cliente;

  RecordInspectionHeader(this._id_cliente, {Key? key}) : super(key: key);

  State<StatefulWidget> createState() => _RecordInspectionHeaderState();
}

class _RecordInspectionHeaderState extends State<RecordInspectionHeader> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _validateKm = false;
  bool _validateDate = false;
  bool _validateVehicle = false;

  String messageValidationDateTiresoft = "";
  String messageValidationKmTiresoft = "";
  String? selectedLetter;
  int? selectedId;
  final format = DateFormat("yyyy-MM-dd");
  var vehicles = [];
  final List<String> letters = [];

  var data;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // Toggles the password show status

  @override
  void initState() {
    getVehicles();
    super.initState();
    setState(() {});
  }

  void getVehicles() async {
    var response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/vehiculosMinified"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final _json_decode = jsonDecode(body);
      final _lista_vehiculos = _json_decode['success']['resultado'] as List;

      for (final element in _lista_vehiculos) {
        letters.add(element['placa'].toString());
        setState(() {});
      }
      setState(() {
        vehicles = _lista_vehiculos;
      });
    }
  }

  bool validateFormIsEmpty() {
    if (selectedLetter == null) {
      setState(() {
        _validateVehicle = true;
      });
      return true;
    } else if (_kmController.text.isEmpty) {
      setState(() {
        _validateKm = true;
      });
      return true;
    } else if (messageValidationDateTiresoft != "" ||
        messageValidationKmTiresoft != "") {
      return true;
    } else if (_dateController.text.isEmpty) {
      setState(() {
        _validateDate = true;
      });
      return true;
    }

    setState(() {
      _validateKm = false;
      _validateDate = false;
      _validateVehicle = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final header = Container(
      height: 80,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.deepOrangeAccent,
          Colors.redAccent,
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(0.7, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      )),
      padding: EdgeInsets.only(left: 50.0),
      child: Text(
        "Pokemon",
        style: TextStyle(
            color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
      alignment: Alignment(-0.9, 0.4),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: homeScaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(""),
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: Text(
                "Registrar inspección",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              Container(
                margin: EdgeInsets.all(25),
                child: Center(
                    child: Text("Por favor ingrese la siguiente información",
                        style: TextStyle(fontSize: 14))),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: SimpleAutocompleteFormField<String>(
                  suggestionsHeight: 150,
                  decoration: InputDecoration(
                      errorText: _validateVehicle
                          ? 'Debe seleccionar un vehiculo'
                          : null,
                      labelText: 'Placa del Vehiculo',
                      border: OutlineInputBorder()),
                  // suggestionsHeight: 200.0,
                  maxSuggestions: 20,
                  itemBuilder: (context, item) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(item!),
                  ),
                  onSearch: (String search) async => search.isEmpty
                      ? letters
                      : letters
                          .where(
                              (letter) => search.toLowerCase().contains(letter))
                          .toList(),
                  itemFromString: (string) => letters.singleWhere(
                      (letter) => letter == string.toLowerCase(),
                      orElse: () => ''),
                  onChanged: (value) => {
                    setState(() => {
                          selectedLetter = value,
                        }),
                    for (final element in vehicles)
                      {
                        if (element["placa"] == value)
                          {
                            setState(() => {selectedId = element['id']}),
                          },
                      },
                  },
                  // onSaved: (value) => setState(() => selectedLetter = value),
                  validator: (letter) =>
                      letter == null ? 'Placa invalida o no existe' : null,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _codeController,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Código de inspección'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  messageValidationKmTiresoft,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (RawKeyEvent event) {
                    if (event.runtimeType == RawKeyDownEvent) {
                      //validateKm();
                    }
                  },
                  child: TextFormField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => validateKm(val),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kilometraje',
                      errorText:
                          _validateKm ? 'Km es un campo obligatorio' : null,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  messageValidationDateTiresoft,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: DateTimeField(
                  initialValue: DateTime.now(),
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: _validateDate
                        ? 'Fecha de inspección es un campo obligatorio'
                        : null,
                    labelText: "Fecha de inspección",
                    labelStyle: TextStyle(
                        fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                  ),
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    validateDate(date);
                    return DateTimeField.tryParse(date.toString(), format);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Siguiente'),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {
                    if (!validateFormIsEmpty())
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordInspectionDetail(
                                      title: 'Registrar inspeccion',
                                      idVehiculo: selectedId,
                                      fechaInspeccion: _dateController.text,
                                      codigoInspeccion: _codeController.text,
                                      kmInspeccion:
                                          int.parse(_kmController.text),
                                    ))),
                      }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> validateDate(DateTime? date) async {
    var newFormat = DateFormat("y-MM-dd");
    String updatedDt = newFormat.format(date!);

    var urlDate = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/vehiculos/validateFechaInspeccion");

    var body = jsonEncode({
      "clienteId": 5,
      "id_vehiculo": selectedId,
      "fecha_inspeccion": updatedDt
    });
    final response = await http.post(urlDate,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      var responseDecode = json.decode(response.body);
      var error = responseDecode['error'];
      var message = responseDecode['message'];
      if (error == false) {
        setState(() {
          messageValidationDateTiresoft = "";
        });
        return true;
      } else {
        setState(() {
          messageValidationDateTiresoft = message.toString();
        });
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> validateKm(String km) async {
    var urlDate = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/vehiculos/validateKilometraje");

    var body = jsonEncode({
      "clienteId": 5,
      "id_vehiculo": selectedId,
      "km": km,
    });
    final response = await http.post(urlDate,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      var responseDecode = json.decode(response.body);
      var error = responseDecode['error'];
      var message = responseDecode['message'];

      if (error == false) {
        setState(() {
          messageValidationKmTiresoft = "";
        });
        return true;
      } else {
        setState(() {
          messageValidationKmTiresoft = message.toString();
        });
        return false;
      }
    } else {
      return false;
    }
  }
}
