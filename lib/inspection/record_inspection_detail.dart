import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiresoft/inspeccion/list_inspeccion.dart';
import 'package:tiresoft/inspection/models/tire.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/widgets/custom_cart.dart';

class RecordInspectionDetail extends StatefulWidget {
  final String id_cliente;
  final String name_cliente;
  final int? idVehiculo;
  final int kmInspeccion;
  final String fechaInspeccion;
  final String? codigoInspeccion;
  final List<User> my_user;

  const RecordInspectionDetail(
      {Key? key,
      required this.id_cliente,
      required this.name_cliente,
      required this.my_user,
      required this.title,
      this.idVehiculo,
      required this.kmInspeccion,
      required this.fechaInspeccion,
      required this.codigoInspeccion})
      : super(key: key);

  final String title;
  static const listHeader = [
    'Pos 1',
    'Pos 2',
    'Pos 3',
    'Pos 4',
    'Pos 5',
    'Pos 6',
    'Pos 7',
    'Pos 8',
    'Pos 9',
    'Pos 10',
  ];

  @override
  State<RecordInspectionDetail> createState() => _RecordInspectionDetailState();
}

enum stateEnum { Continuar, ListaParaReencauchar, ListaParaReemplazar }

enum valveEnum { M, P, ST }

enum valveAccesibility { YES, NO }

class _RecordInspectionDetailState extends State<RecordInspectionDetail>
    with TickerProviderStateMixin {
  var position = 0;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController leftRemaindeController = TextEditingController();
  TextEditingController rightRemaindeController = TextEditingController();
  TextEditingController midRemaindeController = TextEditingController();
  TextEditingController pressureController = TextEditingController();
  TextEditingController recomendationController = TextEditingController();
  TextEditingController nutQuantityController = TextEditingController();

  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;
  bool checkbox4 = false;
  bool checkbox5 = false;
  bool checkBoxDualTipoConstruccion = false;
  bool checkBoxDualNoAplica = true;
  bool checkBoxDualTamano = false;
  bool checkBoxDualDisenio = false;
  bool checkBoxDualMedidaNeumatico = false;

  bool checkboxAroDefectuoso = false;

  int _fallaFlanco = 0;
  int _paraReparar = 0;
  int _estadoTuerca = 1;
  int _motivoInnacesibilidad = 0;
  int _desgIrregular = 0;
  String messageValidationPressureTiresoft = "";
  List<Tire> tires = [];
  final ImagePicker _picker = ImagePicker();
  String messageValidationRemanenteTiresoft = "";
  List<int> listIdInspections = [];

  void cleanForm() {
    midRemaindeController.text = '';
    leftRemaindeController.text = '';
    rightRemaindeController.text = '';

    pressureController.text = '';

    recomendationController.text = '';
    checkBoxDualTipoConstruccion = false;
    checkBoxDualNoAplica = true;
    checkBoxDualTamano = false;
    checkBoxDualDisenio = false;
    checkBoxDualMedidaNeumatico = false;
  }

  Future<String> createPost() async {
    if (tires[position].brand == 'tmp') {
      tireIsSaved();
      return 'Ya fue guardado';
    }

    var accesibilidad_temporal =
        _valveAccesibility.toString() == 'valveAccesibility.YES' ? 1 : 0;

    String valvula_temporal = "";
    if (_valve.toString() == "valveEnum.M") {
      valvula_temporal = "M";
    } else if (_valve.toString() == "valveEnum.P") {
      valvula_temporal = "P";
    } else {
      valvula_temporal = "ST";
    }

    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/inspecciones/storeInspeccion");

    final SharedPreferences prefs = await _prefs;
    int? userId = prefs.getInt('userId');

    bool _validatePressure = false;
    var body = jsonEncode({
      "id_cliente": widget.id_cliente,
      "id_neumaticos": tires[position].uid,
      "id_vehiculo": widget.idVehiculo,
      "km_inspeccion_parcial": widget.kmInspeccion,
      "medio": midRemaindeController.text,
      "exterior": leftRemaindeController.text,
      "interior": rightRemaindeController.text,
      "posicion": tires[position].position,
      "id_ejes": tires[position].idEjes,
      "tipo_presion": "PSI",
      "presion": pressureController.text,
      "valvula": valvula_temporal,
      "accesibilidad": accesibilidad_temporal,
      "motivo_inaccesibilidad": _motivoInnacesibilidad,
      "separaciond": 0,
      "desgirregular0": _desgIrregular,
      "fallasflanco": _fallaFlanco,
      "parareparar": _paraReparar,
      "tuercaestado": _estadoTuerca,
      "otro3": checkboxAroDefectuoso,
      "tuercacantidad": int.parse(nutQuantityController.text),
      "estado": parseState(_state.toString()),
      "recomendacion": recomendationController.text,
      "id_personas": userId ?? 10,
      "remanente_original": 1,
      "resultado1": checkBoxDualDisenio,
      "resultado2": checkBoxDualTamano,
      "resultado3": checkBoxDualTipoConstruccion,
      "resultado4": checkBoxDualMedidaNeumatico,
      "resultado5": checkBoxDualNoAplica,
    });
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 201) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      var newInspectionCreated = json.decode(response.body);
      var tmpId = newInspectionCreated['inspeccion_actual'];
      listIdInspections.add(tmpId);
      print('TMPiD  ${tmpId} ');
      print("Valvula");
      print(_valve.toString());

      tires[position].brand = 'tmp';
      onSuccess();
      if (tmpId != null && pickedImageAsBytes != null) {
        await updateImagePost(tmpId, widget.idVehiculo, tires[position].uid,
            tires[position].position);
      }
      cleanForm();
      return 'succcess';
    } else {
      onError();
      return 'error';
    }
  }

  Future<String> updateImagePost(
      idInspeccion, idVehiculo, idNeumaticos, posicion) async {
    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/inspecciones/singleStoreNeumaticoImgMalEstado1");
    var request = await http.MultipartRequest("POST", url);

    request.files.add(http.MultipartFile.fromBytes(
        'neumaticoimg1', pickedImageAsBytes!,
        filename: 'photo.jpg'));

    request.fields['id_cliente'] = widget.id_cliente;
    request.fields['id_inspeccion'] = idInspeccion.toString();
    request.fields['vehiculo'] = idVehiculo.toString();
    request.fields['serieneumatico'] = idNeumaticos.toString();
    request.fields['neuposicion'] = posicion.toString();

    var responseAttachmentSTR = await request.send();

    //response
    // String x = await responseAttachmentSTR.stream.bytesToString();
    // print('Show here2 ${x}');

    if (responseAttachmentSTR.statusCode == 200) {
      setState(() {
        pickedImageAsBytes = null;
        pickedImageAsBytes2 = null;
      });
      return 'succcess';
    } else {
      onError();
      return 'error';
    }
  }

  Future<bool> finishInspections() async {
    var url = Uri.parse(
        "https://tiresoft2.lab-elsol.com/api/inspecciones/finishedInspectionSimplified");

    var body = jsonEncode({
      "id_cliente": widget.id_cliente,
      "inspection_id": listIdInspections,
      "fecha_inspeccion": widget.fechaInspeccion,
      "vehiculo": widget.idVehiculo,
      "km_inspeccion": widget.kmInspeccion,
      "llantarepuesto": 0,
      "portallanta": 0,
      "codigo": widget.codigoInspeccion
    });
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    // print("Status");
    // print(response.statusCode);
    // print('Response: ${response.bodyBytes}');
    // print('Response: ${response.request}');
    // print('Response: ${response.body}');

    if (response.statusCode != 200) {
      onError();
    }

    onSuccessFinished();
    return true;
  }

  String parseState(String s) {
    switch (s) {
      case 'Continuar':
        return "Continuar en Operación";
      case 'ListaParaReencauchar':
        return 'Lista para Reencauchar';
      case 'ListaParaReemplazar':
        return 'Lista para Reemplazar';
      default:
        return "Continuar en Operación";
    }
  }

  Future<String> getTires() async {
    var response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/inspecciones/getneumatico/" +
              widget.idVehiculo.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget.id_cliente,
      }),
    );

    // print("STATUS");
    // print(widget.idVehiculo);
    // print(response.statusCode);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final _json_decode = jsonDecode(body);
      final myTires = _json_decode as List;
      // print("json > ");
      // print(myTires);
      for (var i = 1; i <= 10; i++) {
        bool isfound = false;
        for (final element in myTires) {
          if (element['neumatico'] != null) {
            if (element['neumatico']['posicion'] == i) {
              tires.add(Tire(
                uid: element['neumatico']['id'],
                serie: element['neumatico']['num_serie'],
                brand: element['neumatico']['marca'].toString(),
                model: element['neumatico']['modelo'].toString(),
                design: element['neumatico']['disenio'] != null
                    ? element['neumatico']['disenio'].toString()
                    : '-',
                position: element['neumatico']['posicion'],
                recomendedPressure: element['neumatico']['presion_recomendada'],
                idEjes: element['neumatico']['id_ejes'],
              ));
              isfound = true;
            }
          }
        }
        if (!isfound) {
          tires.add(
            Tire(
              uid: 0,
              serie: '7915',
              brand: "tmp",
              model: "MY507",
              design: "",
              position: i,
              recomendedPressure: 120,
              vehicle: 2,
              idEjes: 1,
            ),
          );
        }
      }
      setState(() {});

      if (myTires.length > 0) {
        return 'Se cargaron los neumaticos';
      } else {
        return 'Este vehiculo no tiene neumaticos';
      }
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  Widget applyWidget() {
    return form1();
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Neumatico inspeccionado con exito")),
    );
  }

  void tireIsSaved() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text("Este neumatico ya ha sido inspeccionado")),
    );
  }

  void onSuccessFinished() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inspeccion finalizada con exito")),
    );
  }

  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ocurrio un error")),
    );
  }

  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    getTires();
    super.initState();
    nutQuantityController.text = '0';
    print("1-Method Init()");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("3-Method deactivate()");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    print("4-Method dispose()");
  }

  Widget tireWidget(int pos) {
    return tires[pos].brand != 'tmp'
        ? IconButton(
            tooltip: tires[pos].serie,
            icon: this.position == pos
                ? Image.asset('assets/llanta3.jpg')
                : Image.asset('assets/llanta2.jpg'),
            iconSize: 50,
            onPressed: () {
              setState(() {
                position = pos;
              });
            },
          )
        : IconButton(
            icon: Image.asset('assets/llanta1.jpg'),
            iconSize: 50,
            onPressed: () {},
          );
  }

  stateEnum? _state = stateEnum.Continuar;
  valveEnum? _valve = valveEnum.ST;
  valveAccesibility? _valveAccesibility = valveAccesibility.YES;
  XFile? pickedImage;
  XFile? pickedImage2;

  Uint8List? pickedImageAsBytes;
  Uint8List? pickedImageAsBytes2;

  @override
  Widget build(BuildContext context) {
    print("2-Method build()");
    return Scaffold(
      // Persistent AppBar that never scrolls
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text('Inspeccionar neumaticos'),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          ///header image button distribution
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.fromLTRB(40, 15, 15, 15),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            alignment: Alignment.center,
            child: tires.length > 0
                ? diagramPosition()
                : CircularProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'Linear progress indicator',
                  ),
          ),

          ///Widget button

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                  padding: EdgeInsets.only(right: 30.0, left: 30.0),
                  child: Text('Guardar'),
                  color: Color(0xff212F3D),
                  textColor: Colors.white,
                  onPressed: () => {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Guardar inspeccion'),
                            content: const Text(
                                'Realmente desea guardar la inspección de este neumático'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => {
                                  createPost(),
                                  Navigator.pop(context, 'OK')
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      }),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
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
                    finishInspections().then((value) => {
                          if (value)
                            {
                              Navigator.of(context).pop()
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           ListInspeccion(widget.id_cliente)),
                              // )
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ListInspeccion(
                              //             widget.id_cliente,
                              //             widget.my_user,
                              //             widget.name_cliente)))
                            }
                        });
                  },
                  child: Text(
                    'Terminar y Finalizar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),

          Expanded(
            child: tires.length > 0 ? applyWidget() : Text('Cargando...'),
          ),
        ],
      ),
    );
  }

  Widget diagramPosition() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Column(
              children: [
                //Position 1
                tireWidget(0),
                Row(
                  children: [
                    //Position 3
                    tireWidget(2),
                    //Position 4
                    tireWidget(3),
                  ],
                ),
                Row(
                  children: [
                    //Position 7
                    tireWidget(6),
                    //Position 8
                    tireWidget(7),
                  ],
                )
              ],
            ),
            Column(
              children: [
                //Position 2
                tireWidget(1),
                Row(
                  children: [
                    //Position 5
                    tireWidget(4),
                    //Position 6
                    tireWidget(5),
                  ],
                ),
                Row(
                  children: [
                    //Position 9
                    tireWidget(8),
                    //Position 10
                    tireWidget(9),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
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

  form1() {
    return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                tableInfoTire(),
                pressuseWidget(),
                reasonInnacesibilityWidget(),
                rollingDepthWidget(),
                valveCoverWidget(),
                mismatchedDualsWidget(),
                tireStateWidget(),
                observationsWidget(),
                nutStateWidget(),
                recomendationWidget(),
              ],
            )));
  }

  Widget tableInfoTire() {
    return CustomCart(
      'Información del neumatico',
      Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Posición',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: EdgeInsets.all(8),
                child: Text(tires[position].position.toString()),
              )
            ]),
            TableRow(children: [
              Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Serie neumatico',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                  margin: EdgeInsets.all(8),
                  child: Text(tires[position].serie)),
            ]),
            TableRow(children: [
              Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Marca',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: EdgeInsets.all(8),
                child: Text(tires[position].brand.toString()),
              )
            ]),
            TableRow(children: [
              Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Modelo',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: EdgeInsets.all(8),
                child: Text(tires[position].model.toString()),
              )
            ]),
            TableRow(children: [
              Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'Diseño',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: EdgeInsets.all(8),
                child: Text(tires[position].design.toString()),
              )
            ]),
          ]),
    );
  }

  Widget pressuseWidget() {
    return CustomCart(
        'Presion',
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                messageValidationPressureTiresoft,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextFormField(
              controller: pressureController,
              keyboardType: TextInputType.number,
              onChanged: (val) => validatePressure(val.toString()),
              decoration: InputDecoration(labelText: 'Presion PSI'),
            ),
          ],
        ));
  }

  Widget rollingDepthWidget() {
    return CustomCart(
        'Profundidad de rodado MM',
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                messageValidationRemanenteTiresoft,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 100,
                  child: TextFormField(
                    onChanged: (val) => validateRemanente(
                        rightRemaindeController.text,
                        midRemaindeController.text,
                        val),
                    controller: leftRemaindeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Exterior'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 100,
                  child: TextFormField(
                    onChanged: (val) => validateRemanente(
                        rightRemaindeController.text,
                        val,
                        leftRemaindeController.text),
                    controller: midRemaindeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Medio'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 100,
                  child: TextFormField(
                    onChanged: (val) => validateRemanente(
                        val,
                        midRemaindeController.text,
                        leftRemaindeController.text),
                    controller: rightRemaindeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Interior'),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget reasonInnacesibilityWidget() {
    return CustomCart(
        'Accesibilidad a la Tapa de piton',
        Column(
          children: [
            valveCoverAccesibilityWidget(),
            _valveAccesibility.toString() == 'valveAccesibility.NO'
                ? motivoInnacesibilidadWidgetList()
                : Text("")
          ],
        ));
  }

  Widget mismatchedDualsWidget() {
    return CustomCart(
      'Duales Mal Hermanados',
      Column(
        children: [
          CheckboxListTile(
            title: Text("No aplica"),
            value: checkBoxDualNoAplica,
            onChanged: (newValue) {
              setState(() {
                checkBoxDualNoAplica = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          CheckboxListTile(
            title: Text("Diseño"),
            value: checkBoxDualDisenio,
            onChanged: (newValue) {
              setState(() {
                checkBoxDualDisenio = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          CheckboxListTile(
            title: Text("Tamaño"),
            value: checkBoxDualTamano,
            onChanged: (newValue) {
              setState(() {
                checkBoxDualTamano = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          CheckboxListTile(
            title: Text("Tipo de construcción"),
            value: checkBoxDualTipoConstruccion,
            onChanged: (newValue) {
              setState(() {
                checkBoxDualTipoConstruccion = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          CheckboxListTile(
            title: Text("Medida del neumatico"),
            value: checkBoxDualMedidaNeumatico,
            onChanged: (newValue) {
              setState(() {
                checkBoxDualMedidaNeumatico = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ],
      ),
    );
  }

  List<String> fallasFlancoList = [
    'SIN FALLAS EN EL FLANCO',
    'RODURA RADIAL',
    'ROTURA DIAGONAL',
    'CORTE LATERAL',
    'EXPOSICION DE CUERDAS',
    'PROTUBERANCIA',
    'RESEQUEDAD',
    'DAÑO UNIFORME DEL CAUCHO POR ROZAMINETO',
    'IMPACTO LATERAL'
  ];

  List<String> paraRepararList = [
    'NO NECESITA REPARACION',
    'BANDA DE RODAMIENTO',
    'HOMBRO',
    'FLANCO',
    'PESTAÑA'
  ];

  List<String> desgIrregularList = [
    'SIN DESGASTE IRREGULAR',
    'DESGASTE ONDULADO',
    'DESGASTE TIPO DIENTES DE SIERRA',
    'DESGASTE EN LOS HOMBROS',
    'DESGASTE TIPO RIVERA',
    'DESGASTE UNILATERAL',
    'DESGASTE DIAGONAL',
    'DESGASTE EXCENTRICO',
    'DESGASTE DE UN SOLO HOMBRO',
    'DESGASTE TIPO DEPRESION INTERMITENTE',
    'DESGASTE EN ESCALON',
    'DESGASTE PUNTA Y TALON',
    'DESGASTE ALTERNADO DE TACOS',
    'DESGASTE LOCALIZADO',
    'DESGASTE CENTRAL',
    'DESGASTE TIPO ISLA',
    'CHIPPING',
    'CHUNKING',
    'DESGASTE DE RIBETE(S)'
  ];

  List<String> estadoTuercaList = [
    'OK',
    'Tuerca Robada',
    'Tuerca Floja',
    'Falta Tuerca',
    'Cambiar Espárrago',
    'Huacha Floja'
  ];

  List<String> motivoInnacesibilidadList = [
    'Seleccionar',
    'Válvula corta',
    'Hand hole',
    'Requiere extensión',
    'Valvula deteriorada',
    'Valvula inadecuada',
    'Tapa de valvula pegada',
    'Obstruida',
    'Malograda'
  ];

  Widget fallasFlancoWidgetList() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _fallaFlanco.toString(),
      items: <String>['0', '1', '2', '3', '4', '5', '6', '7', '8']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(fallasFlancoList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _fallaFlanco = int.parse(_val.toString());
        });
      },
    );
  }

  Widget estadoTuercaWidgetList() {
    return DropdownButton<String>(
      value: _estadoTuerca.toString(),
      items: <String>['1', '2', '3', '4', '5', '6'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(estadoTuercaList[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _estadoTuerca = int.parse(_val.toString());
        });
      },
    );
  }

  Widget motivoInnacesibilidadWidgetList() {
    return DropdownButton<String>(
      value: _motivoInnacesibilidad.toString(),
      items: <String>['0', '1', '2', '3', '4', '5', '6', '7', '8']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(motivoInnacesibilidadList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _motivoInnacesibilidad = int.parse(_val.toString());
        });
      },
    );
  }

  Widget paraRepararWidgetList() {
    return DropdownButton<String>(
      value: _paraReparar.toString(),
      items: <String>['0', '1', '2', '3', '4'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(paraRepararList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _paraReparar = int.parse(_val.toString());
        });
      },
    );
  }

  Widget desgIrregularWidgetList() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _desgIrregular.toString(),
      items: <String>[
        '0',
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
        '18'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(desgIrregularList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _desgIrregular = int.parse(_val.toString());
        });
      },
    );
  }

  Widget observationsWidget() {
    return CustomCart(
        'Observaciones',
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownButtonHideUnderline(
              child: ButtonTheme(
                  alignedDropdown: true, child: desgIrregularWidgetList())),
          DropdownButtonHideUnderline(
              child: ButtonTheme(
                  alignedDropdown: true, child: paraRepararWidgetList())),
          DropdownButtonHideUnderline(
              child: ButtonTheme(
                  alignedDropdown: true, child: fallasFlancoWidgetList())),
          CheckboxListTile(
            title: const Text("Aro defectuoso"),
            value: checkboxAroDefectuoso,
            onChanged: (newValue) {
              setState(() {
                checkboxAroDefectuoso = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ]));
  }

  Widget nutStateWidget() {
    return CustomCart(
        'Estado de tuercas',
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          estadoTuercaWidgetList(),
          TextFormField(
            controller: nutQuantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cantidad de tuercas'),
          ),
        ]));
  }

  Widget valveCoverWidget() {
    return CustomCart(
        'Tapa de valvula',
        Column(children: [
          Column(
            children: [
              ListTile(
                title: const Text('Sin tapa valvula'),
                leading: Radio<valveEnum>(
                  value: valveEnum.ST,
                  groupValue: _valve,
                  onChanged: (valveEnum? value) {
                    setState(() {
                      _valve = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Tapa valvula metalica"),
                leading: Radio<valveEnum>(
                  value: valveEnum.M,
                  groupValue: _valve,
                  onChanged: (valveEnum? value) {
                    setState(() {
                      _valve = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Tapa valvula plastico"),
                leading: Radio<valveEnum>(
                  value: valveEnum.P,
                  groupValue: _valve,
                  onChanged: (valveEnum? value) {
                    setState(() {
                      _valve = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ]));
  }

  Widget valveCoverAccesibilityWidget() {
    return Column(children: [
      Column(
        children: [
          ListTile(
            title: const Text('Si'),
            leading: Radio<valveAccesibility>(
              value: valveAccesibility.YES,
              groupValue: _valveAccesibility,
              onChanged: (valveAccesibility? value) {
                setState(() {
                  _valveAccesibility = value;
                  _motivoInnacesibilidad = 0;
                });
              },
            ),
          ),
          ListTile(
            title: const Text("No"),
            leading: Radio<valveAccesibility>(
              value: valveAccesibility.NO,
              groupValue: _valveAccesibility,
              onChanged: (valveAccesibility? value) {
                setState(() {
                  _valveAccesibility = value;
                  pressureController.text = "0";
                });
              },
            ),
          ),
        ],
      ),
    ]);
  }

  Widget recomendationWidget() {
    return CustomCart(
        'Recomendaciones',
        Column(children: [
          TextFormField(
            controller: recomendationController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Mi recomendacion'),
          ),
        ]));
  }

  Widget tireStateWidget() {
    return CustomCart(
        'Estados del Neumatico',
        Column(
          children: [
            ListTile(
              title: const Text('Continuar en Operación'),
              leading: Radio<stateEnum>(
                value: stateEnum.Continuar,
                groupValue: _state,
                onChanged: (stateEnum? value) {
                  setState(() {
                    _state = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Lista para Reencauchar'),
              leading: Radio<stateEnum>(
                value: stateEnum.ListaParaReencauchar,
                groupValue: _state,
                onChanged: (stateEnum? value) {
                  setState(() {
                    _state = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Lista para Reemplazar'),
              leading: Radio<stateEnum>(
                value: stateEnum.ListaParaReemplazar,
                groupValue: _state,
                onChanged: (stateEnum? value) {
                  setState(() {
                    _state = value;
                  });
                },
              ),
            ),
            _state.toString() == "stateEnum.ListaParaReemplazar"
                ? Column(
                    children: [
                      TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
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
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(color: Colors.red[200]),
                                width: 200,
                                height: 200,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      )
                    ],
                  )
                : Text(""),
          ],
        ));
  }

  Future<bool> validateRemanente(String right, String mid, String left) async {
    final response = await http.post(
        Uri.parse(
            "https://tiresoft2.lab-elsol.com/api/neumaticos/validateRemanentes"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "clienteId": widget.id_cliente,
          "id_neumaticos": tires[position].uid,
          "interior": right,
          "exterior": left,
          "medio": mid
        }));

    // print(response.statusCode);
    if (response.statusCode == 500) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      var responseDecode = json.decode(response.body);
      var message = responseDecode['error'];

      setState(() {
        messageValidationRemanenteTiresoft = message.toString();
      });
      return false;
    } else {
      setState(() {
        messageValidationRemanenteTiresoft = "";
      });
      return true;
    }
  }

  Future<bool> validatePressure(String pressure) async {
    var presion = int.tryParse(pressure) ?? 0;
    if (presion >= 160) {
      setState(() {
        messageValidationPressureTiresoft = "La presion debe ser menor a 160";
      });
      return true;
    } else {
      setState(() {
        messageValidationPressureTiresoft = "";
      });
      return false;
    }
  }
}
