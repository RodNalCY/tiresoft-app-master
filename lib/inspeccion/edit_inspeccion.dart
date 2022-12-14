import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiresoft/inspeccion/models/inspeccion_details.dart';
import 'package:http/http.dart' as http;
import 'package:tiresoft/login/models/user.dart';
import 'dart:convert';
import 'package:tiresoft/widgets/custom_cart.dart';
import 'dart:io';

class EditInspeccion extends StatefulWidget {
  String _global_id_cliente;
  InspeccionDetails _global_insp_dtail;
  final List<User> _user;

  EditInspeccion(this._global_id_cliente, this._global_insp_dtail, this._user,
      {Key? key})
      : super(key: key);

  @override
  State<EditInspeccion> createState() => _EditInspeccionState();
}

class _EditInspeccionState extends State<EditInspeccion> {
  ////////////////////////////////////////////
  File? file_image;
  ImagePicker image_picker = ImagePicker();
  XFile? pickedFile;
  late String name_photo_response;
  // late bool state_link = false;
  ////////////////////////////////////////////
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  bool isLoadingSave = false;
  late String str_id_neumatico;
  late String str_id_vehiculo;
  late String id_inspeccion;
  late TextEditingController _ctrlr_PSI;
  late String str_psi_tipo;
  late TextEditingController _ctrlr_presion_actual;
  late String str_psi_actual;

  late TextEditingController _ctrlr_cantidad_tuerca;
  late String str_cantidad_tuerca;
  late TextEditingController _ctrlr_recomendacion;
  late String str_recomendacion;

  late TextEditingController _ctrlr_rm_exterior;
  late String str_rm_exterior;
  late TextEditingController _ctrlr_rm_medio;
  late String str_rm_medio;
  late TextEditingController _ctrlr_rm_interior;
  late String str_rm_interior;

  String messageValidationPresion = "";
  String messageValidationMMRemanente = "";

  List<String> listaTapaPiton = [
    'Tapa válvula Metálica',
    'Tapa válvula Plastico',
    'Sin tapa válvula'
  ];
  late int tapaPitonIdselected;

  Widget tapaPitonWidgetList() {
    return DropdownButton<String>(
      value: tapaPitonIdselected.toString(),
      items: <String>['1', '2', '3'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(listaTapaPiton[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          tapaPitonIdselected = int.parse(_val.toString());
        });
      },
    );
  }

  List<String> accesibilidadTapaPiton = ['NO', 'SI'];
  late int accesibilidadIdselected;
  late bool statusAccesibilidadNO;

  Widget accesibilidadtapaPitonWidgetList() {
    return DropdownButton<String>(
      value: accesibilidadIdselected.toString(),
      items: <String>['0', '1'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(accesibilidadTapaPiton[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          accesibilidadIdselected = int.parse(_val.toString());
          if (accesibilidadIdselected == 0) {
            statusAccesibilidadNO = true;
          } else {
            statusAccesibilidadNO = false;
            _motivoInnacesibilidadId = 0;
          }
        });
      },
    );
  }

  Widget dropDownBloqueado() {
    return Container(
      padding: EdgeInsets.only(right: 15.0),
      child: DropdownButton<String>(
          hint: Text("Bloqueado"), onChanged: null, items: []),
    );
  }

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
  late int _motivoInnacesibilidadId;
  Widget motivoInnacesibilidadWidgetList() {
    return DropdownButton<String>(
      value: _motivoInnacesibilidadId.toString(),
      items: <String>['0', '1', '2', '3', '4', '5', '6', '7', '8']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(motivoInnacesibilidadList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _motivoInnacesibilidadId = int.parse(_val.toString());
        });
      },
    );
  }

  List<String> estadoTuercaList = [
    'OK',
    'Tuerca Robada',
    'Tuerca Floja',
    'Falta Tuerca',
    'Cambiar \nEspárrago',
    'Huacha Floja'
  ];
  int _estadoTuercaId = 1;
  Widget estadoTuercaWidgetList() {
    return DropdownButton<String>(
      value: _estadoTuercaId.toString(),
      items: <String>['1', '2', '3', '4', '5', '6'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(estadoTuercaList[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _estadoTuercaId = int.parse(_val.toString());
        });
      },
    );
  }

  // Radio Buttons Estado
  late int _value_estado;
  bool _point_edit = false;
  Uint8List? pickedImageAsBytesEdit;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? pickedImageXFile;
  // Checkboxes Duales mal hermanados
  late bool _isActivateDisenio;
  late bool _isActivateTamanio;
  late bool _isActivateTipoConstruccion;
  late bool _isActivateMedidaNeumatico;
  late bool _isActivateNoAplica;

  // Link Imagen Edit
  late String str_image_view;

  // Radio Buttons separacion entre duales
  late int _value_estado_separcion_dual;

  // Checkboxes Observaciones
  late bool _isActivateDesgIrregular;
  late bool _isActivateParReparar;
  late bool _isActivateAroDefectuoso;
  late bool _isActivateFallFlanco;

  List<String> desgasteIrregularList = [
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
  late int _desgIrregularId;
  Widget desgasteIrregularOptionWidgetList() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _desgIrregularId.toString(),
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
          child: Text(desgasteIrregularList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _desgIrregularId = int.parse(_val.toString());
        });
      },
    );
  }

  List<String> paraRepararList = [
    'NO NECESITA REPARACION',
    'BANDA DE RODAMIENTO',
    'HOMBRO',
    'FLANCO',
    'PESTAÑA'
  ];
  late int _paraRepararId;
  Widget paraRepararOptionWidgetList() {
    return DropdownButton<String>(
      value: _paraRepararId.toString(),
      items: <String>['0', '1', '2', '3', '4'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(paraRepararList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _paraRepararId = int.parse(_val.toString());
        });
      },
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
  late int _fallaFlancoId;
  Widget fallasFlancoOptionWidgetList() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _fallaFlancoId.toString(),
      items: <String>['0', '1', '2', '3', '4', '5', '6', '7', '8']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(fallasFlancoList[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          _fallaFlancoId = int.parse(_val.toString());
        });
      },
    );
  }

  // Consultas Future API's
  Future<void> _validateMMRemanente(
      String exterior, String medio, String interior) async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/neumaticos/validateRemanentes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'clienteId': widget._global_id_cliente,
          "id_neumaticos": str_id_neumatico,
          "exterior": exterior,
          "medio": medio,
          "interior": interior,
        },
      ),
    );
    String body;
    final jsonData;
    if (response.statusCode == 200) {
      body = utf8.decode(response.bodyBytes);
      jsonData = jsonDecode(body);
      setState(() {
        messageValidationMMRemanente = "";
      });
    } else if (response.statusCode == 500) {
      body = utf8.decode(response.bodyBytes);
      jsonData = jsonDecode(body);
      setState(() {
        messageValidationMMRemanente = jsonData["error"].toString();
      });
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  late Future<List> _edit_neumatico;

  Future<List> _getShowInspEditNeumatico() async {
    id_inspeccion = widget._global_insp_dtail.idt_id.toString();

    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/inspecciones/getOneInspeccionSimplified/" +
              id_inspeccion),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._global_id_cliente,
      }),
    );

    List _insp_edit_neumatico = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsdta = jsonDecode(body);
      // print("JSON INSPECCION NEUMATICO:");
      // print(jsdta);
      // print(jsdta["km_proyectado"]);
      file_image = null;
      // Cargamos y validamos Datos
      str_id_neumatico = jsdta['id_neumaticos'].toString();
      str_id_vehiculo = jsdta['id_vehiculo'].toString();
      str_psi_tipo = "PSI";
      str_psi_actual = jsdta['presion'].toString();
      str_cantidad_tuerca = jsdta['tuercacantidad'] != null
          ? jsdta['tuercacantidad'].toString()
          : "0";
      str_recomendacion = jsdta['recomendacion'] != null
          ? jsdta['recomendacion'].toString()
          : "-";
      str_rm_exterior = jsdta['exterior'] != null ? jsdta['exterior'] : "";
      str_rm_medio = jsdta['medio'] != null ? jsdta['medio'] : "";
      str_rm_interior = jsdta['interior'] != null ? jsdta['interior'] : "";

      // Cargamos los Texting
      _ctrlr_PSI = new TextEditingController(text: str_psi_tipo);
      _ctrlr_presion_actual = new TextEditingController(text: str_psi_actual);
      _ctrlr_cantidad_tuerca =
          new TextEditingController(text: str_cantidad_tuerca);
      _ctrlr_recomendacion = new TextEditingController(text: str_recomendacion);

      _ctrlr_rm_exterior = new TextEditingController(text: str_rm_exterior);
      _ctrlr_rm_medio = new TextEditingController(text: str_rm_medio);
      _ctrlr_rm_interior = new TextEditingController(text: str_rm_interior);

      String sw_valvula =
          jsdta['valvula'] != null ? jsdta['valvula'].toString() : "ST";
      switch (sw_valvula) {
        case "M":
          tapaPitonIdselected = 1;
          break;
        case "P":
          tapaPitonIdselected = 2;
          break;
        case "ST":
          tapaPitonIdselected = 3;
          break;
        default:
          tapaPitonIdselected = 3;
          break;
      }

      String sw_accesibilidad = jsdta['accesibilidad'] != null
          ? jsdta['accesibilidad'].toString()
          : "1";
      switch (sw_accesibilidad) {
        case "0":
          accesibilidadIdselected = 0;
          statusAccesibilidadNO = true;
          break;
        case "1":
          accesibilidadIdselected = 1;
          statusAccesibilidadNO = false;
          break;
      }

      String sw_motivo_inaccesible = jsdta['motivo_inaccesibilidad'] != null
          ? jsdta['motivo_inaccesibilidad'].toString()
          : "0";
      switch (sw_motivo_inaccesible) {
        case "0":
          _motivoInnacesibilidadId = 0;
          break;
        case "1":
          _motivoInnacesibilidadId = 1;
          break;
        case "2":
          _motivoInnacesibilidadId = 2;
          break;
        case "3":
          _motivoInnacesibilidadId = 3;
          break;
        case "4":
          _motivoInnacesibilidadId = 4;
          break;
        case "5":
          _motivoInnacesibilidadId = 5;
          break;
        case "6":
          _motivoInnacesibilidadId = 6;
          break;
        case "7":
          _motivoInnacesibilidadId = 7;
          break;
        case "8":
          _motivoInnacesibilidadId = 8;
          break;
      }

      String str_sep_duales =
          jsdta['sep_duales'] != null ? jsdta['sep_duales'].toString() : "4";
      switch (str_sep_duales) {
        case "No Aplica":
          _value_estado_separcion_dual = 4;
          break;
        default:
          _value_estado_separcion_dual = 4;
          break;
      }

      String str_duales_mal_herm =
          jsdta['resultado'] != null ? jsdta['resultado'].toString() : "-";

      final findDisenio = str_duales_mal_herm.contains('Diseño'); // true
      final findTamanio = str_duales_mal_herm.contains('Tamaño'); // true
      final findTConstr =
          str_duales_mal_herm.contains('Tipo de Construcción'); // true
      final findMedNeum =
          str_duales_mal_herm.contains('Medida de Neumático'); // true
      final findNAplica = str_duales_mal_herm.contains('No Aplica'); // true

      // print('Obs > ${str_duales_mal_herm}');
      // print('1- ${findDisenio}');
      // print('2- ${findTamanio}');
      // print('3- ${findTConstr}');
      // print('4- ${findMedNeum}');
      // print('5- ${findNAplica}');

      if (findDisenio) {
        _isActivateDisenio = true;
      } else {
        _isActivateDisenio = false;
      }

      if (findTamanio) {
        _isActivateTamanio = true;
      } else {
        _isActivateTamanio = false;
      }

      if (findTConstr) {
        _isActivateTipoConstruccion = true;
      } else {
        _isActivateTipoConstruccion = false;
      }

      if (findMedNeum) {
        _isActivateMedidaNeumatico = true;
      } else {
        _isActivateMedidaNeumatico = false;
      }

      if (findNAplica) {
        _isActivateNoAplica = true;
      } else {
        _isActivateNoAplica = false;
      }

      String str_estado_neumatico =
          jsdta['estado'] != null ? jsdta['estado'].toString() : "-";
      String _imagen_neumatico = jsdta['neumaticoimgruta1'] != null
          ? "https://tiresoft2.lab-elsol.com/" + jsdta['neumaticoimgruta1']
          : "https://tiresoft2.lab-elsol.com/images/reportes/img_neumaticos_mal_estado/no_image.png";

      // print(_imagen_neumatico);

      switch (str_estado_neumatico) {
        case "Continuar en Operación":
          _value_estado = 1;
          str_image_view = _imagen_neumatico;
          break;
        case "Lista para Reencauchar":
          _value_estado = 2;
          str_image_view = _imagen_neumatico;
          break;
        case "Lista para Reemplazar":
          _value_estado = 3;
          str_image_view = _imagen_neumatico;

          break;
      }

      String str_observaciones =
          jsdta['otros'] != null ? jsdta['otros'].toString() : "-";

      final findDesgIrregular =
          str_observaciones.contains('Desg. Irregular'); // true
      final findParaReparar =
          str_observaciones.contains('Lista para Reparar'); // true
      final findAroDefectuoso =
          str_observaciones.contains('Aro Defectuoso'); // true
      final findFallaFlanco =
          str_observaciones.contains('Fallas en el flanco'); // true

      String str_des_irregular = jsdta['desgirregular'] != null
          ? jsdta['desgirregular'].toString().substring(0, 1)
          : "0";
      _desgIrregularId = int.parse(str_des_irregular);
      // print('Obs dsIrregular > ${str_des_irregular}');

      int int_par_reparar =
          jsdta['parareparar'] != null ? jsdta['parareparar'] : 0;
      _paraRepararId = int_par_reparar;
      // print('Obs parReparar > ${int_par_reparar}');

      int int_fall_flanco =
          jsdta['fallasflanco'] != null ? jsdta['fallasflanco'] : 0;
      _fallaFlancoId = int_fall_flanco;
      // print('Obs fallFlanco > ${int_fall_flanco}');

      // print('Obs > ${str_observaciones}');
      // print('1- ${findDesgIrregular}');
      // print('2- ${findParaReparar}');
      // print('3- ${findAroDefectuoso}');
      // print('4- ${findFallaFlanco}');

      if (findDesgIrregular) {
        _isActivateDesgIrregular = true;
      } else {
        _isActivateDesgIrregular = false;
      }

      if (findParaReparar) {
        _isActivateParReparar = true;
      } else {
        _isActivateParReparar = false;
      }

      if (findAroDefectuoso) {
        _isActivateAroDefectuoso = true;
      } else {
        _isActivateAroDefectuoso = false;
      }

      if (findFallaFlanco) {
        _isActivateFallFlanco = true;
      } else {
        _isActivateFallFlanco = false;
      }

      return _insp_edit_neumatico;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  late StreamBuilder _widget;

  @override
  void initState() {
    _edit_neumatico = _getShowInspEditNeumatico();

    _ctrlr_cantidad_tuerca = new TextEditingController(text: '1');

    _ctrlr_recomendacion = new TextEditingController(text: 'Operativo II');

    _ctrlr_rm_exterior = new TextEditingController(text: '5');
    _ctrlr_rm_medio = new TextEditingController(text: '5');
    _ctrlr_rm_interior = new TextEditingController(text: '5');

    // _validateMMRemanente("8", "5", "15");

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("F->dispose()");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Id > " + widget._global_insp_dtail.idt_id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Serie: " + widget._global_insp_dtail.idt_serie),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 227, 235, 243),
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List>(
            future: _edit_neumatico,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                final error = snapshot.error;
                return Text("$error");
              } else if (snapshot.hasData) {
                return Form(
                  key: _globalFormKey,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "P-" +
                                widget._global_insp_dtail.idt_posicion
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18.0),
                          ),
                          IconButton(
                            icon: Image.asset('assets/neumatico1.jpg'),
                            iconSize: 100,
                            onPressed: () {},
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: presionCardWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: tapaPitonWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: profundidadRodadoWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: dualesMalHermanadosWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: separacionDualesWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: observacionesWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: estadoWidget(context),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: estadoTuercasWidget(),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: recomendacionWidget(),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: SizedBox(
                              width: 130,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  primary: Color(0xff212F3D),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoadingSave = true;
                                  });
                                  updateInspeccionNeumatico();
                                },
                                child: isLoadingSave
                                    ? Transform.scale(
                                        scale: 0.6,
                                        child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 5.0),
                                      )
                                    : Text('Actualizar'),
                              ),
                            ),
                          ),
                          // MaterialButton(
                          //   padding: EdgeInsets.only(right: 45.0, left: 45.0),
                          //   color: Color(0xff212F3D),
                          //   textColor: Colors.white,
                          //   child: isLoadingSave
                          //       ? Transform.scale(
                          //           scale: 0.5,
                          //           child: Container(
                          //             margin: EdgeInsets.symmetric(vertical: 1),
                          //             child: CircularProgressIndicator(
                          //                 backgroundColor: Colors.white,
                          //                 strokeWidth: 5.0),
                          //           ),
                          //         )
                          //       : Text(
                          //           'Guardar',
                          //           style: TextStyle(fontSize: 15.0),
                          //         ),
                          //   onPressed: () async => {
                          //     setState(() {
                          //       isLoadingSave = true;
                          //     }),
                          //     updateInspeccionNeumatico(),
                          //   },
                          // ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> updateInspeccionNeumatico() async {
    print("createScrapDirecto()");
    // setState(() {
    //   isLoadingSave = false;
    // });
    // print("PSI > " + _ctrlr_PSI.text.toString());
    // print("P.Actual > " + _ctrlr_presion_actual.text.toString());
    // print("Tapa Piton Id > " + tapaPitonIdselected.toString());

    // print(
    //     "Inaccesibilidad SI(1) NO(0) > " + accesibilidadIdselected.toString());
    // print("Inaccesibilidad Id > " + _motivoInnacesibilidadId.toString());
    // print("Tuerca Estado Id > " + _estadoTuercaId.toString());

    // print("_isActivateDisenio > " + _isActivateDisenio.toString());
    // print("_isActivateTamanio > " + _isActivateTamanio.toString());
    // print("_isActivateTipoConstruccion > " +
    //     _isActivateTipoConstruccion.toString());
    // print("_isActivateMedidaNeumatico > " +
    //     _isActivateMedidaNeumatico.toString());
    // print("_isActivateNoAplica > " + _isActivateNoAplica.toString());

    // print("Estado Neumatico > " + _value_estado.toString());
    // print("Image Edit > " + pickedImageAsBytesEdit.toString());
    // print("Separacion entre duales Id > " +
    //     _value_estado_separcion_dual.toString());
    // print("Desgaste Irregular > " + _isActivateDesgIrregular.toString());
    // print("Desgaste Irregular Option > " + _desgIrregularId.toString());
    // print("Para Reparar > " + _isActivateParReparar.toString());
    // print("Para Reparar Option > " + _paraRepararId.toString());
    // print("Aro Defectuoso > " + _isActivateAroDefectuoso.toString());
    // print("Falla Flanco > " + _isActivateFallFlanco.toString());
    // print("Falla Flanco Option > " + _fallaFlancoId.toString());

    // print("Cantidad Tuerca > " + _ctrlr_cantidad_tuerca.text.toString());
    // print("Recomendacion > " + _ctrlr_recomendacion.text.toString());
    // print("RM Exterior > " + _ctrlr_rm_exterior.text.toString());
    // print("RM Medio > " + _ctrlr_rm_medio.text.toString());
    // print("RM Interior > " + _ctrlr_rm_interior.text.toString());

    // POST > ACTUALIZAR INSPECCION

    Uri uri = Uri.parse(
        'https://tiresoft2.lab-elsol.com/api/inspecciones/updateInspeccion');

    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    request.fields['id'] = id_inspeccion;
    request.fields['id_cliente'] = widget._global_id_cliente.toString();
    request.fields['id_usuario'] = widget._user[0].u_id.toString();
    request.fields['id_neumaticos'] = str_id_neumatico;
    request.fields['posicion'] =
        widget._global_insp_dtail.idt_posicion.toString();
    request.fields['tipo_presion'] = _ctrlr_PSI.text.toString();
    request.fields['presion'] = _ctrlr_presion_actual.text.toString();

    // TIPO DE VALVULA
    late String temp_tapa_valvula;
    switch (tapaPitonIdselected.toString()) {
      case "1":
        temp_tapa_valvula = "M";
        break;
      case "2":
        temp_tapa_valvula = "P";
        break;
      case "3":
        temp_tapa_valvula = "ST";
        break;
    }

    request.fields['valvula'] = temp_tapa_valvula;
    request.fields['accesibilidad'] = accesibilidadIdselected.toString();
    request.fields['motivo_inaccesibilidad'] =
        _motivoInnacesibilidadId.toString();

    request.fields['exterior'] = _ctrlr_rm_exterior.text.toString();
    request.fields['medio'] = _ctrlr_rm_medio.text.toString();
    request.fields['interior'] = _ctrlr_rm_interior.text.toString();

    // DUALES MAL HERMANADOS
    String duales_mal_hermanados = "";

    if (_isActivateDisenio) {
      duales_mal_hermanados += "Diseño,";
    }
    if (_isActivateTamanio) {
      duales_mal_hermanados += "Tamaño,";
    }
    if (_isActivateTipoConstruccion) {
      duales_mal_hermanados += "Tipo de Construcción,";
    }
    if (_isActivateMedidaNeumatico) {
      duales_mal_hermanados += "Medida de Neumático";
    }
    if (_isActivateNoAplica) {
      duales_mal_hermanados = "No Aplica";
    }
    request.fields['resultado'] = duales_mal_hermanados;

    // ESTADO DEL NEUMATICO
    String temp_estado_neumatico = "";
    switch (_value_estado.toString()) {
      case "1":
        temp_estado_neumatico = "Continuar en Operación";
        break;
      case "2":
        temp_estado_neumatico = "Lista para Reencauchar";
        break;
      case "3":
        temp_estado_neumatico = "Lista para Reemplazar";
        break;
    }
    request.fields['estado'] = temp_estado_neumatico;

    //IMAGEN - FALTA EN EL API
    if (file_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', file_image!.path));
    }

    // print("Image Edit > ");
    // print(pickedImageAsBytesEdit);

    // ESTADO TUERCAS
    request.fields['tuercaestado'] = _estadoTuercaId.toString();
    request.fields['tuercacantidad'] = _ctrlr_cantidad_tuerca.text.toString();
    // RECOMENDACION
    request.fields['recomendacion'] = _ctrlr_recomendacion.text.toString();

    // SEPARACION ENTRE DUALES
    request.fields['separaciond'] = "Sep. Entre Duales- No Aplica";

    // // OBSERVACIONES
    String observaciones_neumatico = "";

    if (_isActivateDesgIrregular) {
      observaciones_neumatico += "Desg. Irregular,";
    }

    if (_isActivateParReparar) {
      observaciones_neumatico += "Lista para Reparar,";
    }

    if (_isActivateAroDefectuoso) {
      observaciones_neumatico += "Aro Defectuoso,";
    }

    if (_isActivateFallFlanco) {
      observaciones_neumatico += "Fallas en el flanco";
    }
    // print("OBS > " + observaciones_neumatico);
    request.fields['otros'] = observaciones_neumatico;
    request.fields['desgirregular'] = _desgIrregularId.toString();
    request.fields['parareparar'] = _paraRepararId.toString();
    request.fields['fallasflanco'] = _fallaFlancoId.toString();
    // DATOS PARA IMAGEN MAL ESTADO
    request.fields['serieneumatico'] = widget._global_insp_dtail.idt_serie;
    request.fields['vehiculo_id'] = str_id_vehiculo;

    // Enviar el POST
    var response = await request.send();
    String parse_response = await response.stream.bytesToString();
    print('Status: ${response.statusCode}');
    print('Response: ${parse_response}');

    if (response.statusCode == 200) {
      onSuccess();
      setState(() {
        isLoadingSave = false;
      });
      print("Finalizado");
    } else {
      setState(() {
        isLoadingSave = false;
      });
      onError();
    }
  }

  void onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inspección actualizada con exito")),
    );
  }

  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ocurrio un error al editar inspección")),
    );
  }

  Widget presionCardWidget() {
    return CustomCart(
      'Presión',
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              messageValidationPresion,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: _ctrlr_PSI,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Tipo de Presión'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
                  child: TextFormField(
                    maxLength: 3,
                    controller: _ctrlr_presion_actual,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => validatePresion(val),
                    decoration: InputDecoration(labelText: 'Presión Actual'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> validatePresion(String pressure) async {
    for (int i = 0; i < pressure.length; i++) {
      if (pressure[i] == '.') {
        /////////////////////////////////////////////////
        _ctrlr_presion_actual.value = TextEditingValue(
          text: '',
          selection: TextSelection.fromPosition(
            TextPosition(offset: 0),
          ),
        );
        ////////////////////////////////////////////////
      } else {
        var presion = int.tryParse(pressure) ?? 0;
        if (presion >= 161) {
          setState(() {
            messageValidationPresion = "La presion debe ser menor a 160";
          });
        } else {
          setState(() {
            messageValidationPresion = "";
          });
        }
      }
    }
  }

  Widget tapaPitonWidget() {
    return CustomCart(
      'Tapa de Pitón',
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          "Tapa",
                          style: TextStyle(color: Colors.black45),
                        ),
                        tapaPitonWidgetList(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text("Accesibilidad",
                              style: TextStyle(color: Colors.black45)),
                          accesibilidadtapaPitonWidgetList(),
                        ],
                      )),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.only(left: 25.0, top: 10.0),
                child: Text("Motivo Inaccesibilidad",
                    style: TextStyle(color: Colors.black45))),
            Container(
              padding: EdgeInsets.only(left: 25.0),
              child: statusAccesibilidadNO
                  ? motivoInnacesibilidadWidgetList()
                  : dropDownBloqueado(),
            ),
          ],
        ),
      ),
    );
  }

  Widget profundidadRodadoWidget() {
    return CustomCart(
        'Profundidad de rodado MM',
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                messageValidationMMRemanente,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      maxLength: 5,
                      controller: _ctrlr_rm_exterior,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Exterior'),
                      onChanged: (value) => _validateMMRemanente(
                          value, _ctrlr_rm_medio.text, _ctrlr_rm_interior.text),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      maxLength: 5,
                      controller: _ctrlr_rm_medio,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Medio'),
                      onChanged: (value) => _validateMMRemanente(
                          _ctrlr_rm_exterior.text,
                          value,
                          _ctrlr_rm_interior.text),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      maxLength: 5,
                      controller: _ctrlr_rm_interior,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Interior'),
                      onChanged: (value) => _validateMMRemanente(
                          _ctrlr_rm_exterior.text, _ctrlr_rm_medio.text, value),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget dualesMalHermanadosWidget() {
    return CustomCart(
      'Duales mal Hermanados',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                  value: _isActivateDisenio,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateDisenio = value as bool;
                      _isActivateNoAplica = false;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Diseño")
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: _isActivateTamanio,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateTamanio = value as bool;
                      _isActivateNoAplica = false;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Tamaño")
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _isActivateTipoConstruccion,
                onChanged: (bool? value) {
                  setState(() {
                    _isActivateTipoConstruccion = value as bool;
                    _isActivateNoAplica = false;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Tipo de Construcción")
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: _isActivateMedidaNeumatico,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateMedidaNeumatico = value as bool;
                      _isActivateNoAplica = false;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Medida de Neumático")
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: _isActivateNoAplica,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateNoAplica = value as bool;
                      _isActivateDisenio = false;
                      _isActivateTamanio = false;
                      _isActivateTipoConstruccion = false;
                      _isActivateMedidaNeumatico = false;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("No Aplica")
            ],
          ),
        ],
      ),
    );
  }

  Widget separacionDualesWidget() {
    return CustomCart(
      'Separación entre duales',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _value_estado_separcion_dual,
                onChanged: (value) {
                  setState(() {
                    _value_estado_separcion_dual = value as int;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Ok")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 2,
                groupValue: _value_estado_separcion_dual,
                onChanged: (value) {
                  setState(() {
                    _value_estado_separcion_dual = value as int;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Muy Juntos")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 3,
                groupValue: _value_estado_separcion_dual,
                onChanged: (value) {
                  setState(() {
                    _value_estado_separcion_dual = value as int;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Muy Separados")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 4,
                groupValue: _value_estado_separcion_dual,
                onChanged: (value) {
                  setState(() {
                    _value_estado_separcion_dual = value as int;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("No Aplica")
            ],
          ),
        ],
      ),
    );
  }

  Widget observacionesWidget() {
    return CustomCart(
      'Observaciones',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                  value: _isActivateDesgIrregular,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateDesgIrregular = value as bool;
                      _desgIrregularId = 0;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Desgaste Irregular"),
            ],
          ),
          _isActivateDesgIrregular
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  child: desgasteIrregularOptionWidgetList())
              : Container(child: null),
          Row(
            children: [
              Checkbox(
                  value: _isActivateParReparar,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateParReparar = value as bool;
                      _paraRepararId = 0;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Para Reparar")
            ],
          ),
          _isActivateParReparar
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  child: paraRepararOptionWidgetList())
              : Container(child: null),
          Row(
            children: [
              Checkbox(
                  value: _isActivateAroDefectuoso,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateAroDefectuoso = value as bool;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Aro Defectuoso")
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: _isActivateFallFlanco,
                  onChanged: (bool? value) {
                    setState(() {
                      _isActivateFallFlanco = value as bool;
                      _fallaFlancoId = 0;
                    });
                  }),
              SizedBox(width: 10.0),
              Text("Fallas en el Flanco")
            ],
          ),
          _isActivateFallFlanco
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  child: fallasFlancoOptionWidgetList(),
                )
              : Container(child: null),
        ],
      ),
    );
  }

  Widget estadoWidget(BuildContext context) {
    return CustomCart(
      'Estado',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _value_estado,
                onChanged: (value) {
                  setState(() {
                    _value_estado = value as int;
                    // pickedImageAsBytesEdit = null;
                    file_image = null;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Continuar en Operación")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 2,
                groupValue: _value_estado,
                onChanged: (value) {
                  setState(() {
                    _value_estado = value as int;
                    // pickedImageAsBytesEdit = null;
                    file_image = null;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Lista para Reencauchar")
            ],
          ),
          Row(
            children: [
              Radio(
                value: 3,
                groupValue: _value_estado,
                onChanged: (value) {
                  setState(() {
                    _value_estado = value as int;
                    _point_edit = true;
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Lista para Reemplazar")
            ],
          ),
          _value_estado.toInt() == 3 ? calcularPhoto(context) : Text(""),
        ],
      ),
    );
  }

  Widget calcularPhoto(BuildContext context) {
    if (_point_edit == true && file_image == null) {
      return showUploadPhoto(context);
    } else if (_point_edit == true && file_image != null) {
      return showViewPhoto(context);
    } else {
      return showImageEdit();
    }
  }

  Widget showImageEdit() {
    return Center(
      child: Column(
        children: [
          Image.network(
            str_image_view,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 14.0),
            ),
            onPressed: () {
              print("Button Editar Activate");
              setState(() {
                _point_edit = true;
              });
            },
            child: Icon(Icons.cameraswitch),
          ),
        ],
      ),
    );
  }

  Center showUploadPhoto(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.red[200],
            ),
          ),
          child: Icon(
            Icons.add_photo_alternate,
            size: 40,
          ),
          onPressed: () {
            showOptionDialog(context);
          },
        ),
      ),
    );
  }

  Center showViewPhoto(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Image.file(file_image!),
          ),
          SizedBox.fromSize(
            size: Size(60, 60),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () {
                    showOptionDialog(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.cameraswitch,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Actualizar",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 9.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showOptionDialog(BuildContext context) async {
    await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: Text(
              "Seleccionar el origen de la imagen:",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  openFileOrCamera(1, context);
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 35.0,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        'Galería',
                        style: TextStyle(
                          fontSize: 9.0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  openFileOrCamera(2, context);
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 35.0,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        'Cámara',
                        style: TextStyle(
                          fontSize: 9.0,
                          color: Colors.black45,
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

  Future openFileOrCamera(int option, BuildContext context) async {
    pickedFile = null;

    // Navigator.of(context).pop();
    Navigator.of(context).pop();

    switch (option) {
      case 1:
        pickedFile = await image_picker.pickImage(
            source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
        break;
      case 2:
        pickedFile = await image_picker.pickImage(
            source: ImageSource.camera, maxHeight: 1920, maxWidth: 1080);
        break;
    }

    setState(() {
      if (pickedFile != null) {
        file_image = File(pickedFile!.path);
        // setState(() {
        //   // state_link = false;
        // });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Imagen no seleccionada")),
        );
      }
    });
  }

  // Widget camaraUploadEditPhoto() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         TextButton(
  //             style: ButtonStyle(
  //               foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  //               overlayColor: MaterialStateProperty.resolveWith<Color?>(
  //                 (Set<MaterialState> states) {
  //                   if (states.contains(MaterialState.hovered))
  //                     return Colors.blue.withOpacity(0.04);
  //                   if (states.contains(MaterialState.focused) ||
  //                       states.contains(MaterialState.pressed))
  //                     return Colors.blue.withOpacity(0.12);
  //                   return null; // Defer to the widget's default.
  //                 },
  //               ),
  //             ),
  //             onPressed: () {
  //               _pickImageOpenCamara();
  //             },
  //             child: const Text('Adjuntar foto 1')),
  //         Container(
  //           child: pickedImageAsBytesEdit != null
  //               ? Image.memory(
  //                   pickedImageAsBytesEdit!,
  //                   width: 200.0,
  //                   height: 200.0,
  //                   fit: BoxFit.fitHeight,
  //                 )
  //               : Container(
  //                   decoration: BoxDecoration(color: Colors.red[200]),
  //                   width: 200,
  //                   height: 200,
  //                   child: Icon(
  //                     Icons.camera_alt,
  //                     color: Colors.grey[800],
  //                   ),
  //                 ),
  //         ),
  //         TextButton(
  //           style: TextButton.styleFrom(
  //             textStyle: const TextStyle(fontSize: 14.0),
  //           ),
  //           onPressed: () {
  //             print("Button Editar Desactivate");
  //             setState(() {
  //               _point_edit = false;
  //               pickedImageAsBytesEdit = null;
  //             });
  //           },
  //           child: const Text('Cancelar'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget estadoTuercasWidget() {
    return CustomCart(
      'Estado de Tuercas',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(left: 10.0, top: 25.0),
                    child: estadoTuercaWidgetList()),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 16.0, right: 10.0, left: 10.0),
                  child: TextFormField(
                    // readOnly: true,
                    maxLength: 3,
                    controller: _ctrlr_cantidad_tuerca,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: 'Cantidad de tuercas'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget recomendacionWidget() {
    return CustomCart(
      'Recomendación',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              // readOnly: true,
              controller: _ctrlr_recomendacion,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
          ),
        ],
      ),
    );
  }
}
