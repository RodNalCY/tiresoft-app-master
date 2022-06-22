import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/scrap/list_scrap.dart';
import 'package:tiresoft/scrap/list_tire_scrap_screen.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:tiresoft/widgets/custom_drawer.dart';

class RecordScrapScreen extends StatefulWidget {
  final String title = 'Registration';
  final String _cliente_id;
  final String _cliente_name;
  final List<User> _user;

  const RecordScrapScreen(this._cliente_id, this._user, this._cliente_name,
      {Key? key})
      : super(key: key);
  State<StatefulWidget> createState() => _RecordScrapScreenState();
}

class _RecordScrapScreenState extends State<RecordScrapScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _remanenteLimiteController =
      TextEditingController();
  final TextEditingController _remanenteFinalController =
      TextEditingController();

  bool _validateRemanenteLimite = false;
  bool _validateRemanenteFinal = false;
  bool _validateKm = false;
  bool _validateDate = false;
  bool _validateVehicle = false;

  String? selectedLetter;
  int? selectedVehiculoId;
  final format = DateFormat("yyyy-MM-dd");
  var vehicles = [];
  final List<String> letters = [];
  XFile? pickedImage;
  XFile? pickedImage2;

  Uint8List? pickedImageAsBytes;
  Uint8List? pickedImageAsBytes2;

  @override
  void initState() {
    getVehicles();
    super.initState();
    mapTires = {
      '0': 'Debe seleccionar un vehiculo',
      '1': 'Debe seleccionar un vehiculo'
    };

    listIdTires = ['0', '1'];
  }

  void getVehicles() async {
    final response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/vehiculosMinified"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._cliente_id,
      }),
    );
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final _json_decode = jsonDecode(body);
      final my_vehicles = _json_decode['success']['resultado'] as List;
      for (final element in my_vehicles) {
        if (element['neumaticos']) {
          letters.add(element['placa'].toString());
          setState(() {});
        }
      }
      setState(() {
        vehicles = my_vehicles;
      });
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  Map mapTires = {'0': '7914', '1': '7915', '2': '1070 - 4'};
  final ImagePicker _picker = ImagePicker();
  List<String> listIdTires = ['0', '1', '2'];

  Future<String> getTires() async {
    var response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/inspecciones/getneumatico/" +
              selectedVehiculoId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._cliente_id,
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final _json_decode = jsonDecode(body);
      final myTires = _json_decode as List;
      // print(
      //     "JSON--------------------------------------------------------------");
      // print(selectedVehiculoId.toString());
      // print(myTires);

      bool isfound = false;
      List<String> tmp = [];
      Map tmp2 = new Map();
      for (final element in myTires) {
        if (element['neumatico'] != null) {
          int id = element['neumatico']['id'];
          tmp.add(id.toString());
          tmp2[id.toString()] = element['neumatico']['num_serie'];
          selectedTireId = id;
        }
      }
      setState(() {
        listIdTires = tmp;
        mapTires = tmp2;
      });
    }

    print('Mira aqui ${listIdTires}');
    print('Mira aqui mapa ${mapTires}');

    if (mapTires.length > 0) {
      return 'Se cargaron los neumaticos';
    } else {
      return 'Este vehiculo no tiene neumaticos';
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
    } else if (_remanenteLimiteController.text.isEmpty) {
      setState(() {
        _validateRemanenteLimite = true;
      });
      return true;
    } else if (_remanenteFinalController.text.isEmpty) {
      setState(() {
        _validateRemanenteFinal = true;
      });
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
      _validateRemanenteFinal = false;
      _validateRemanenteLimite = false;
      _validateVehicle = false;
    });
    return false;
  }

  bool isLoadingSave = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: homeScaffoldKey,
      // drawer: CustomDrawer(widget._cliente_id),
      drawer: NavigationDrawerWidget(widget._user, widget._cliente_name),
      appBar: AppBar(
        title: Text("Registro Scrap"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: const Center(
                        child: Text(
                            "Por favor ingrese la siguiente información",
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
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
                                    () => {selectedVehiculoId = element['id']}),
                                getTires(),
                              },
                          },
                      },

                      validator: (letter) =>
                          letter == null ? 'Placa invalida o no existe' : null,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10), child: tiresAvailable()),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _remanenteLimiteController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Remanente Limite',
                        errorText: _validateRemanenteLimite
                            ? 'Debe ingresar el remanente Limite'
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _remanenteFinalController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Remanente Final',
                        errorText: _validateRemanenteFinal
                            ? 'Debe ingresar el remanente Final'
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _kmController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Kilometraje recorrido',
                        errorText:
                            _validateKm ? 'Km es un campo obligatorio' : null,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "Motivo de Scrap",
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                          SizedBox(height: 5.0),
                          motivoScrapWidgetList(),
                        ],
                      )),
                  SizedBox(height: 10.0),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "Motivo de Retiro",
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                          SizedBox(height: 5.0),
                          motivoRetiroWidgetList(),
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: DateTimeField(
                      initialValue: DateTime.now(),
                      controller: _dateController,
                      // onFieldSubmitted: _onSubmitbornDate,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: _validateDate
                            ? 'Fecha de retiro es un campo obligatorio'
                            : null,
                        labelText: "Fecha de retiro",
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

                        return DateTimeField.tryParse(date.toString(), format);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.all(5.0)),
                        addPhotoWidget(),
                        Padding(padding: EdgeInsets.all(5.0)),
                        addPhotoWidget2()
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Center(
                    child: MaterialButton(
                      padding: EdgeInsets.only(right: 45.0, left: 45.0),
                      child: isLoadingSave
                          ? Transform.scale(
                              scale: 0.5,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 1),
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    strokeWidth: 5.0),
                              ),
                            )
                          : Text(
                              'Guardar',
                              style: TextStyle(fontSize: 15.0),
                            ),
                      color: Color(0xff212F3D),
                      textColor: Colors.white,
                      onPressed: () async => {
                        print("Finalizado I"),
                        if (!validateFormIsEmpty())
                          {
                            setState(() {
                              isLoadingSave = true;
                            }),
                            createScrap()
                          }
                      },
                    ),
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            )),
      ),
    );
  }

  List<String> motivoScrapList = [
    'IMPACTO EN LA BANDA DE RODAMIENTO',
    'IMPACTO EN EL FLANCO',
    'PESTAÑA DAÑADA',
    'PESTAÑA QUEMADA',
    'CORTE PASANTE EN EL FLANCO',
    'CORTE PASANTE EN LA \nBANDA DE RODAMIENTO',
    'EXCESIVO DESGASTE DE LA \nBANDA DE RODAMIENTO',
    'SEPARACION DE CUERDAS EN EL FLANCO',
    'VOLADURA DEL NEUMÁTICO',
    'RODADO A BAJA PRESIÓN',
    'FATIGA DE LA CARCASA',
    'ROTURA CIRCUNFERENCIAL',
    'SEPARACION DEL INNERLINER',
    'DESPRENDIMIENTO DE LA BANDA \nDE RODAMIENTO',
    'SEPARACION DE TELAS ESTRUCTURALES \nEN EL FLANCO',
    'SEPARACION DE TELAS ESTRUCTURALES \nEN EL HOMBRO',
    'FALLA DEL PARCHE POR PRESION \nINSUFICIENTE',
    'REPARACION INADECUADA',
    'CONTAMINACION DEL NEUMATICO',
    'RUPTURA DE LA CARCASA POR \nINCRUSTACION DE OBJETO',
    'SEPARACION DE CUERDAS EN EL \nAREA DE LA PESTAÑA',
    'EXPOSICION DE CUERDAS(OXIDADAS)'
  ];
  int motivoScrapIdselected = 1;
  int selectedTireId = 0;

  List<String> motivoRetiroList = [
    'POR REENCAUCHE',
    'POR REPARACIÓN',
    'POR ROTACIÓN',
    'POR DESGASTE FINAL',
    'POR FALLA'
  ];
  int motivoRetiroIdselected = 1;

  Widget tiresAvailable() {
    if (!listIdTires.isNotEmpty) {
      return Text('Seleccione un vehiculo');
    } else {
      return DropdownButton<String>(
        value: selectedTireId.toString(),
        items: listIdTires.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff212F3D),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.only(
                  left: 30.0, bottom: 5.0, top: 5.0, right: 30.0),
              child: Text(
                mapTires[value.toString()] ?? '-',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          );
        }).toList(),
        onChanged: (_val) {
          setState(() {
            selectedTireId = int.parse(_val.toString());
          });
        },
      );
    }
  }

  Widget motivoScrapWidgetList() {
    return DropdownButton<String>(
      value: motivoScrapIdselected.toString(),
      items: <String>[
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20',
        '21',
        '22'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(motivoScrapList[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          motivoScrapIdselected = int.parse(_val.toString());
        });
      },
    );
  }

  Widget motivoRetiroWidgetList() {
    return DropdownButton<String>(
      value: motivoRetiroIdselected.toString(),
      items: <String>['1', '2', '3', '4', '5'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(motivoRetiroList[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          motivoRetiroIdselected = int.parse(_val.toString());
        });
      },
    );
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Seleccione el origen de la foto",
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camara"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Galeria"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final XFile? file = await _picker.pickImage(source: imageSource);

      if (file != null) {
        file.readAsBytes().then((x) {
          setState(() => {pickedImageAsBytes = x});
        });
        setState(() => {pickedImage = file});
      }
    }
  }

  void _pickImage2() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Seleccione el origen de la foto",
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camara"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Galeria"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final XFile? file = await _picker.pickImage(source: imageSource);

      if (file != null) {
        file.readAsBytes().then((x) {
          setState(() => {pickedImageAsBytes2 = x});
        });
        setState(() => {pickedImage2 = file});
      }
    }
  }

  Widget addPhotoWidget() {
    return Column(
      children: [
        TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.12);
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              _pickImage();
            },
            child: const Text('Adjuntar foto 1')),
        Container(
          child: pickedImageAsBytes != null
              ? Image.memory(
                  pickedImageAsBytes!,
                  width: 180.0,
                  height: 180.0,
                  fit: BoxFit.fitHeight,
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.red[200]),
                  width: 180.0,
                  height: 180.0,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        )
      ],
    );
  }

  Widget addPhotoWidget2() {
    return Column(
      children: [
        TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.12);
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              _pickImage2();
            },
            child: const Text('Adjuntar foto 2')),
        Container(
          child: pickedImageAsBytes2 != null
              ? Image.memory(
                  pickedImageAsBytes2!,
                  width: 180.0,
                  height: 180.0,
                  fit: BoxFit.fitHeight,
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.red[200]),
                  width: 180.0,
                  height: 180.0,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        )
      ],
    );
  }

  Future<void> createScrap() async {
    final SharedPreferences prefs = await _prefs;
    int? userId = prefs.getInt('userId');
    userId ?? 10;

    print("createScrap()");
    print("ID-CLIENTE > " + widget._cliente_id.toString());
    print("ID-VEHICULO > " + selectedVehiculoId.toString());
    print("ID-NEUMATICO > " + selectedTireId.toString());

    print("r limite > " + _remanenteLimiteController.text.toString());
    print("r final > " + _remanenteFinalController.text.toString());
    print("_kmController > " + _kmController.text.toString());

    print("SCRAP > " + motivoScrapIdselected.toString());
    print("RETIRO > " + motivoRetiroIdselected.toString());
    print("fecha > " + _dateController.text);
    print("user > " + userId.toString());

    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/registroScrapxNeumaticosInstalados");
    var request = await http.MultipartRequest("POST", url);

    if (pickedImageAsBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'imgneumaticomalestado1', pickedImageAsBytes!,
          filename: 'photo.jpg'));
    }

    if (pickedImageAsBytes2 != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'imgneumaticomalestado2', pickedImageAsBytes2!,
          filename: 'photo2.jpg'));
    }

    request.fields['id_cliente'] = widget._cliente_id.toString();
    request.fields['id_vehiculo'] = selectedVehiculoId.toString();
    request.fields['kmrecorr'] = _kmController.text.toString();
    request.fields['id_motivo_retiro'] = motivoRetiroIdselected.toString();
    request.fields['id_neumaticos'] = selectedTireId.toString();
    request.fields['rem_final'] = _remanenteFinalController.text.toString();
    request.fields['rem_limite'] = _remanenteLimiteController.text.toString();
    request.fields['id_motivo_scrap'] = motivoScrapIdselected.toString();
    request.fields['fecha_scrap'] = _dateController.text; // CORREGIS BD
    request.fields['id_usuario'] = userId.toString();

    var responseAttachmentSTR = await request.send();

    //response
    String x = await responseAttachmentSTR.stream.bytesToString();
    print('Response: ${x}');

    if (responseAttachmentSTR.statusCode == 200) {
      setState(() {
        pickedImageAsBytes = null;
        pickedImageAsBytes2 = null;
        isLoadingSave = false;
      });

      onSuccess();
      print("Finalizado II");
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ListScrap(widget._cliente_id, widget._user,
      //             widget._cliente_name))); // RDX - DEFINIR ID CLIENTE
    } else {
      onError();
      setState(() {
        isLoadingSave = false;
      });
    }
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Scrap creado con exito")),
    );
  }

  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ocurrio un error")),
    );
  }
}
