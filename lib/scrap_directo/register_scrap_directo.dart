import 'dart:typed_data';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RegisterScrapDirecto extends StatefulWidget {
  final String _cliente_id;
  final String _cliente_name;
  final List<User> _user;

  RegisterScrapDirecto(this._cliente_id, this._user, this._cliente_name,
      {Key? key})
      : super(key: key);

  @override
  State<RegisterScrapDirecto> createState() => _RegisterScrapDirectoState();
}

class _RegisterScrapDirectoState extends State<RegisterScrapDirecto> {
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  bool isLoadingSave = false;

  final TextEditingController _txtEdNumSerie = TextEditingController();
  bool _validatetxtEdNumSerie = false;

  final TextEditingController _txtEdDOT = TextEditingController();
  bool _validatetxtEdDOT = false;

  final TextEditingController _txtEdCostoSnIGV = TextEditingController();
  bool _validatetxtEdCostoSnIGV = false;

  final TextEditingController _txtEdRemOriginal = TextEditingController();
  bool _validatetxtEdRemOriginal = false;

  final TextEditingController _txtEdRemFinal = TextEditingController();
  bool _validatetxtEdRemFinal = false;

  final TextEditingController _txtEdRemLimite = TextEditingController();
  bool _validatetxtEdRemLimite = false;

  final TextEditingController _txtEdKmInicial = TextEditingController();
  bool _validatetxtEdKmInicial = false;

  final TextEditingController _txtEdKmFinal = TextEditingController();
  bool _validatetxtEdKmFinal = false;

  final TextEditingController _txtEdFechaScrap = TextEditingController();
  bool _validatetxtEdFechaScrap = false;
  final txtDateFormat = DateFormat("yyyy-MM-dd");

  List? neuMarcaList;
  String? _myIdMarca;

  List? neuMedidaList;
  String? _myIdMedida;

  Future<void> _getMarcasList() async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/detalleScrapDirectoNeumaticos"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': '5',
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print("JSON 1:");
      // print("Marca");
      // print(jsonData['success']['resultado']['marca']);
      // print("Medida");
      // print(jsonData['success']['resultado']['medida']);

      setState(() {
        neuMarcaList = jsonData['success']['resultado']['marca'];
        neuMedidaList = jsonData['success']['resultado']['medida'];
      });
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  List? neuModeloList;
  String? _myIdModelo;

  Future<void> _getModelosList() async {
    print("_getModelosList");
    final response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/neumaticos/getmodelos/" +
          _myIdMarca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'clienteId': '5',
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // print("JSON 2:");
      // print(jsonData['success']['resultado']);

      setState(() {
        neuModeloList = jsonData['success']['resultado'];
      });
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  List<String> listaTipoMonedaName = ['SOLES (S/)', 'DOLARES (\$)'];
  int tipoMonedaIdselected = 1;

  Widget tipoMonedaWidgetList() {
    return DropdownButton<String>(
      value: tipoMonedaIdselected.toString(),
      items: <String>['1', '2'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(listaTipoMonedaName[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          tipoMonedaIdselected = int.parse(_val.toString());
        });
      },
    );
  }

  List<String> listaCondicionNeumatico = ['NUEVO', 'REENCAUCHADO'];
  int condicionNeumaticoIdselected = 1;

  Widget condicionNeumaticoWidgetList() {
    return DropdownButton<String>(
      value: condicionNeumaticoIdselected.toString(),
      items: <String>['1', '2'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(listaCondicionNeumatico[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          condicionNeumaticoIdselected = int.parse(_val.toString());
        });
      },
    );
  }

  List<String> listaMotivoScrap = [
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
  Widget motivoScrapWidgetList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton<String>(
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
              child: Text(listaMotivoScrap[int.parse(value) - 1]),
            );
          }).toList(),
          onChanged: (_val) {
            setState(() {
              motivoScrapIdselected = int.parse(_val.toString());
            });
          },
        ),
      ],
    );
  }

  bool validateTextingFormIsEmpty() {
    if (_txtEdNumSerie.text.isEmpty) {
      setState(() {
        _validatetxtEdNumSerie = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdNumSerie = false;
      });
    }

    if (_txtEdDOT.text.isEmpty) {
      setState(() {
        _validatetxtEdDOT = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdDOT = false;
      });
    }

    if (_txtEdCostoSnIGV.text.isEmpty) {
      setState(() {
        _validatetxtEdCostoSnIGV = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdCostoSnIGV = false;
      });
    }

    if (_txtEdRemOriginal.text.isEmpty) {
      setState(() {
        _validatetxtEdRemOriginal = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdRemOriginal = false;
      });
    }

    if (_txtEdRemFinal.text.isEmpty) {
      setState(() {
        _validatetxtEdRemFinal = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdRemFinal = false;
      });
    }

    if (_txtEdRemLimite.text.isEmpty) {
      setState(() {
        _validatetxtEdRemLimite = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdRemLimite = false;
      });
    }

    if (_txtEdFechaScrap.text.isEmpty) {
      setState(() {
        _validatetxtEdFechaScrap = true;
      });
      return true;
    } else {
      setState(() {
        _validatetxtEdFechaScrap = false;
      });
    }

    return false;
  }

  @override
  void initState() {
    _getMarcasList();
    // _getModelosList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("4-Method dispose()");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("3-Method deactivate()");
  }

  @override
  Widget build(BuildContext context) {
    print("REGISTRO SCRAP DIRECTO");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavigationDrawerWidget(widget._user, widget._cliente_name),
      appBar: AppBar(
        title: Text("Neumático Directo"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _globalFormKey,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: const Center(
                          child: Text(
                              "Por favor ingrese la siguiente información",
                              style: TextStyle(fontSize: 14))),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _txtEdNumSerie,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Número de serie',
                          errorText: _validatetxtEdNumSerie
                              ? 'Debe ingresar el número de serie'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _txtEdDOT,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'DOT',
                          errorText: _validatetxtEdDOT
                              ? 'Debe ingresar el DOT del neumático'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _txtEdCostoSnIGV,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Costo sin IGV',
                          errorText: _validatetxtEdCostoSnIGV
                              ? 'Debe ingresar el costo sin IGV'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tipo de Moneda:",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            SizedBox(width: 15.0),
                            tipoMonedaWidgetList(),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Condición: ",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            SizedBox(width: 15.0),
                            condicionNeumaticoWidgetList(),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: dropDownMarcaWidget()),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: dropDownModeloWidget()),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: dropDownMedidaWidget()),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text("Niveles de Remanente",
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _txtEdRemOriginal,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'R. Original',
                                    errorText: _validatetxtEdRemOriginal
                                        ? 'Ingresar remanente original'
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _txtEdRemFinal,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'R. Final',
                                    errorText: _validatetxtEdRemFinal
                                        ? 'Ingresar remanente final'
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _txtEdRemLimite,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'R. Límite',
                                    errorText: _validatetxtEdRemLimite
                                        ? 'Ingresar remanente límite'
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text("Kilometraje (km)",
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54)),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _txtEdKmInicial,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'K Inicial',
                                      errorText: _validatetxtEdKmInicial
                                          ? 'Ingresar km original'
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _txtEdKmFinal,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'K. Final',
                                      errorText: _validatetxtEdKmFinal
                                          ? 'Ingresar km final'
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                    SizedBox(height: 10.0),
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
                      child: DateTimeField(
                        initialValue: DateTime.now(),
                        controller: _txtEdFechaScrap,
                        // onFieldSubmitted: _onSubmitbornDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          errorText: _validatetxtEdFechaScrap
                              ? 'Fecha de scrap/retiro es un campo obligatorio'
                              : null,
                          labelText: "Fecha de Scrap",
                          labelStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold", fontSize: 16.0),
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
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [addPhotoWidgetOne(), addPhotoWidgetTwo()],
                      ),
                    ),
                    SizedBox(height: 30.0),
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
                          if (!validateTextingFormIsEmpty())
                            {
                              print("Guardar I"),
                              setState(() {
                                isLoadingSave = true;
                              }),
                              createScrapDirecto()
                            }
                        },
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  Future<void> createScrapDirecto() async {
    print("createScrapDirecto()");
    print("1 ID-CLIENTE > " + widget._cliente_id.toString());
    print("2 ID-NumeroCliente > " + _txtEdNumSerie.text.toString());
    print("3 ID-DOT > " + _txtEdDOT.text.toString());
    print("4 ID-CostoSinIGV > " + _txtEdCostoSnIGV.text.toString());
    print("5 TIPO-MONEDA > " + tipoMonedaIdselected.toString());
    print("6 CONDICION NEUMATICOS> " + condicionNeumaticoIdselected.toString());

    print("7 R-Original > " + _txtEdRemOriginal.text.toString());
    print("8 R-Final > " + _txtEdRemFinal.text.toString());
    print("9 R-Limite > " + _txtEdRemLimite.text.toString());

    print("10 km-Inicial > " + _txtEdKmInicial.text.toString());
    print("11 km-Final > " + _txtEdKmFinal.text.toString());

    print("12 MOTIVO SCRAP > " + motivoScrapIdselected.toString());

    print("13 Fecha Scrap> " + _txtEdFechaScrap.text.toString());

    print("14 Id Marca > " + _myIdMarca.toString());
    print("15 Id Modelo > " + _myIdModelo.toString());
    print("16 Id Medida > " + _myIdMedida.toString());

    print("17 Photo One");
    print(pickedImageAsBytesOne);
    print("18 Photo Two");
    print(pickedImageAsBytesTwo);
    print("19 User Id > " + widget._user[0].u_id.toString());

    var request = await http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://tiresoft2.lab-elsol.com/api/registroScrapDirectoNeumaticos"));

    request.fields['id_cliente'] = widget._cliente_id.toString();
    request.fields['num_serie'] = _txtEdNumSerie.text.toString();
    request.fields['dot'] = _txtEdDOT.text.toString();
    request.fields['precio'] = _txtEdCostoSnIGV.text.toString();
    request.fields['tipo_moneda'] = tipoMonedaIdselected.toString();
    request.fields['nuevo'] = condicionNeumaticoIdselected.toString();

    request.fields['cantidad_reencauche'] = "";
    request.fields['id_disenio'] = "";
    request.fields['id_empresa'] = "";

    request.fields['id_marca'] = _myIdMarca.toString();
    request.fields['id_modelo'] = _myIdModelo.toString();
    request.fields['id_medida'] = _myIdMedida.toString();
    request.fields['remanente_original'] = _txtEdRemOriginal.text.toString();
    request.fields['remanente_final'] = _txtEdRemFinal.text.toString();
    request.fields['remanente_limite'] = _txtEdRemLimite.text.toString();
    request.fields['km_inicial'] = _txtEdKmInicial.text.toString();
    request.fields['km_final'] = _txtEdKmFinal.text.toString();
    request.fields['id_motivo_scrap'] = motivoScrapIdselected.toString();
    request.fields['fecha_scrap'] = _txtEdFechaScrap.text.toString();
    request.fields['id_usuario'] = widget._user[0].u_id.toString();

    //Adjuntamos Imagenes al POST
    if (pickedImageAsBytesOne != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'imgneumaticomalestado1', pickedImageAsBytesOne!,
          filename: 'photo.jpg'));
    }

    if (pickedImageAsBytesTwo != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'imgneumaticomalestado2', pickedImageAsBytesTwo!,
          filename: 'photo2.jpg'));
    }

    //Response HTTP
    var response = await request.send();
    String parse_response = await response.stream.bytesToString();
    print('Response: ${parse_response}');

    if (response.statusCode == 200) {
      setState(() {
        pickedImageAsBytesOne = null;
        pickedImageAsBytesTwo = null;
        isLoadingSave = false;
      });
      onSuccess();
      print("Finalizado II");
    } else {
      onError();
      setState(() {
        isLoadingSave = false;
      });
    }
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Scrap creado con exito el scrap")),
    );
  }

  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ocurrio un error en registro de scrap")),
    );
  }

  Uint8List? pickedImageAsBytesTwo;
  final ImagePicker _pickerImageTwo = ImagePicker();
  XFile? pickedXFileImageTwo;

  void _pickImageFunctionTwo() async {
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
      final XFile? file = await _pickerImageTwo.pickImage(source: imageSource);

      if (file != null) {
        file.readAsBytes().then((x) {
          setState(() => {pickedImageAsBytesTwo = x});
        });
        setState(() => {pickedXFileImageTwo = file});
      }
    }
  }

  Widget addPhotoWidgetTwo() {
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
              _pickImageFunctionTwo();
            },
            child: const Text('Adjuntar foto 2')),
        Container(
          child: pickedImageAsBytesTwo != null
              ? Image.memory(
                  pickedImageAsBytesTwo!,
                  width: 190.0,
                  height: 190.0,
                  fit: BoxFit.fitHeight,
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.red[200]),
                  width: 190.0,
                  height: 190.0,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        )
      ],
    );
  }

  Uint8List? pickedImageAsBytesOne;
  final ImagePicker _pickerImageOne = ImagePicker();
  XFile? pickedXFileImageOne;

  void _pickImageFunctionOne() async {
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
      final XFile? file = await _pickerImageOne.pickImage(source: imageSource);

      if (file != null) {
        file.readAsBytes().then((x) {
          setState(() => {pickedImageAsBytesOne = x});
        });
        setState(() => {pickedXFileImageOne = file});
      }
    }
  }

  Widget addPhotoWidgetOne() {
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
              _pickImageFunctionOne();
            },
            child: const Text('Adjuntar foto 1')),
        Container(
          child: pickedImageAsBytesOne != null
              ? Image.memory(
                  pickedImageAsBytesOne!,
                  width: 190.0,
                  height: 190.0,
                  fit: BoxFit.fitHeight,
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.red[200]),
                  width: 190.0,
                  height: 190.0,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        )
      ],
    );
  }

  Widget dropDownMedidaWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Medida: ",
              style: TextStyle(fontSize: 16.0, color: Colors.black54)),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: _myIdMedida,
              iconSize: 30,
              icon: (null),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              hint: Text('Seleccione Medida'),
              onChanged: (String? newValue) {
                setState(() {
                  _myIdMedida = newValue;
                  print("Id Medida");
                  print(_myIdMedida);
                });
              },
              items: neuMedidaList?.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['descripcion']),
                      value: item['id'].toString(),
                    );
                  })?.toList() ??
                  [],
            ),
          ),
        ]);
  }

  Widget dropDownModeloWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Modelo: ",
              style: TextStyle(fontSize: 16.0, color: Colors.black54)),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: _myIdModelo,
              iconSize: 30,
              icon: (null),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              hint: Text('Seleccione Modelo'),
              onChanged: (String? newValue) {
                setState(() {
                  _myIdModelo = newValue;
                  print("Id Modelo");
                  print(_myIdModelo);
                });
              },
              items: neuModeloList?.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['descripcion']),
                      value: item['id_modelo'].toString(),
                    );
                  })?.toList() ??
                  [],
            ),
          ),
        ]);
  }

  Widget dropDownMarcaWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Marca: ",
            style: TextStyle(fontSize: 16.0, color: Colors.black54)),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _myIdMarca,
            iconSize: 30.0,
            icon: null,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            onChanged: (String? newValue) {
              setState(() {
                _myIdModelo = null;
                neuModeloList = [];
                _myIdMarca = newValue;
                _getModelosList();
                print("Marca Id");
                print(_myIdMarca);
              });
            },
            hint: Text('Seleccione Marca'),
            items: neuMarcaList?.map((item) {
                  return new DropdownMenuItem(
                      child: new Text(item['descripcion']),
                      value: item['id'].toString());
                })?.toList() ??
                [],
          ),
        )
      ],
    );
  }
}
