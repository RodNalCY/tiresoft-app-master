import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:tiresoft/inspeccion/models/vehicle.dart';
import 'package:tiresoft/inspeccion/register/record_inspection_detail.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'dart:convert';

import 'package:tiresoft/widgets/custom_drawer.dart';

class RecordInspectionHeader extends StatefulWidget {
  final String title = 'Registration';
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;
  RecordInspectionHeader(this._id_cliente, this._user, this._name_cliente,
      {Key? key})
      : super(key: key);

  State<StatefulWidget> createState() => _RecordInspectionHeaderState();
}

class _RecordInspectionHeaderState extends State<RecordInspectionHeader> {
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _kmController;
  late final TextEditingController _codeController;

  bool _validateKm = false;
  bool _validateDate = false;
  bool _validateVehicle = false;

  String messageValidationDateTiresoft = "";
  String messageValidationKmTiresoft = "";
  String? selectedLetter;
  int? selectedId;
  final format = DateFormat("yyyy-MM-dd");
  var vehicles = [];

  var data;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // Toggles the password show status
  late Future<List> listaVehiculos;
  final List<String> letters = [];

  Future<List> getVehicles() async {
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
        if (element['neumaticos']) {
          setState(() {
            letters.add(element['placa'].toString());
          });
        }
      }
      setState(() {
        vehicles = _lista_vehiculos;
      });
    }

    return letters;
  }

  @override
  void initState() {
    _dateController = TextEditingController();
    _kmController = TextEditingController();
    _codeController = TextEditingController();
    listaVehiculos = getVehicles();
    super.initState();
  }

  @override
  void dispose() {
    print("> dispose()");
    _dateController.dispose();
    _kmController.dispose();
    _codeController.dispose();
    super.dispose();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: homeScaffoldKey,
      // drawer: CustomDrawer(widget._id_cliente),
      drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
      appBar: AppBar(
        title: Text("Registrar Inspecci??n"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
        color: Color.fromARGB(255, 227, 235, 243),
        child: FutureBuilder(
          future: listaVehiculos,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text("$error");
            } else if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
                        child: Center(
                            child: Text(
                                "Por favor ingrese la siguiente informaci??n",
                                style: TextStyle(fontSize: 14))),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: SimpleAutocompleteFormField<String>(
                          suggestionsHeight: 220,
                          decoration: InputDecoration(
                              errorText: _validateVehicle
                                  ? 'Debe seleccionar un vehiculo'
                                  : null,
                              labelText: 'Placa del Vehiculo',
                              border: OutlineInputBorder()),
                          // suggestionsHeight: 200.0,
                          maxSuggestions: 1000,
                          itemBuilder: (context, item) => Padding(
                            padding: EdgeInsets.only(top: 7.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff212F3D),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: EdgeInsets.only(
                                  left: 30.0, bottom: 5.0, top: 5.0),
                              child: Text(
                                item!,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                          onSearch: (String search) async => search.isEmpty
                              ? letters
                              : letters
                                  .where((letter) =>
                                      search.toLowerCase().contains(letter))
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
                                    setState(
                                        () => {selectedId = element['id']}),
                                  },
                              },
                          },
                          // onSaved: (value) => setState(() => selectedLetter = value),
                          validator: (letter) => letter == null
                              ? 'Placa invalida o no existe'
                              : null,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _codeController,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'C??digo de inspecci??n'),
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
                              errorText: _validateKm
                                  ? 'Km es un campo obligatorio'
                                  : null,
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
                                ? 'Fecha de inspecci??n es un campo obligatorio'
                                : null,
                            labelText: "Fecha de inspecci??n",
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
                            return DateTimeField.tryParse(
                                date.toString(), format);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                      Center(
                        child: MaterialButton(
                          minWidth: 130.0,
                          child: isLoading
                              ? Transform.scale(
                                  scale: 0.6,
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 5.0),
                                )
                              : Text('Siguiente'),
                          color: Color(0xff212F3D),
                          textColor: Colors.white,
                          onPressed: () async => {
                            setState(() => isLoading = true),
                            await Future.delayed(const Duration(seconds: 2),
                                () {
                              setState(() => isLoading = false);
                            }),
                            if (!validateFormIsEmpty())
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecordInspectionDetail(
                                      id_cliente: widget._id_cliente,
                                      name_cliente: widget._name_cliente,
                                      my_user: widget._user,
                                      title: 'Registrar inspeccion',
                                      idVehiculo: selectedId,
                                      fechaInspeccion: _dateController.text,
                                      codigoInspeccion: _codeController.text,
                                      kmInspeccion:
                                          int.parse(_kmController.text),
                                    ),
                                  ),
                                ),
                              }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue.shade500),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> validateDate(DateTime? date) async {
    // print("Fecha 1");
    // print(date);
    var newFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = newFormat.format(date!);
    // print("Fecha 2 ");
    // print(newFormat);
    // print(updatedDt);

    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/vehiculos/validateFechaInspeccion"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'clienteId': widget._id_cliente,
        'id_vehiculo': selectedId,
        'fecha_inspeccion': updatedDt,
      }),
    );

    // print("response");
    // print(response);

    if (response.statusCode == 500) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      var responseDecode = json.decode(response.body);
      var message = responseDecode['error'];
      setState(() {
        messageValidationDateTiresoft = message.toString();
      });
      return true;
    } else {
      setState(() {
        messageValidationDateTiresoft = "";
      });
      return false;
    }
  }

  Future<bool> validateKm(String km) async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/vehiculos/validateKilometraje"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'clienteId': widget._id_cliente,
        'id_vehiculo': selectedId,
        'km': km,
      }),
    );
    print("Status");
    print(response.statusCode);
    if (response.statusCode == 500) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      String body = utf8.decode(response.bodyBytes);
      final _json_decode = jsonDecode(body);
      var message = _json_decode['error'];
      // print(_json_decode);
      // print(message);

      setState(() {
        messageValidationKmTiresoft = message.toString();
      });
      return false;
    } else {
      setState(() {
        messageValidationKmTiresoft = "";
      });
      return true;
    }
  }
}
