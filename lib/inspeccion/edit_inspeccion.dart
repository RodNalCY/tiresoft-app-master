import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiresoft/inspeccion/models/inspeccion_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tiresoft/widgets/custom_cart.dart';

class EditInspeccion extends StatefulWidget {
  String _global_id_cliente;
  InspeccionDetails _global_insp_dtail;

  EditInspeccion(this._global_id_cliente, this._global_insp_dtail, {Key? key})
      : super(key: key);

  @override
  State<EditInspeccion> createState() => _EditInspeccionState();
}

class _EditInspeccionState extends State<EditInspeccion> {
  final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  late TextEditingController _ctrlr_PSI;
  late TextEditingController _ctrlr_presion_actual;
  late TextEditingController _ctrlr_cantidad_tuerca;
  late TextEditingController _ctrlr_recomendacion;

  late TextEditingController _ctrlr_rm_exterior;
  late TextEditingController _ctrlr_rm_medio;
  late TextEditingController _ctrlr_rm_interior;

  String messageValidationPresion = "";
  String messageValidationMMRemanente = "";

  @override
  void initState() {
    _ctrlr_PSI = new TextEditingController(text: 'PSI');

    _ctrlr_presion_actual = new TextEditingController(
        text: widget._global_insp_dtail.idt_posicion.toString());

    _ctrlr_cantidad_tuerca = new TextEditingController(text: '1');

    _ctrlr_recomendacion = new TextEditingController(text: 'Operativo II');

    _ctrlr_rm_exterior = new TextEditingController(text: '5');
    _ctrlr_rm_medio = new TextEditingController(text: '5');
    _ctrlr_rm_interior = new TextEditingController(text: '5');

    // _validateMMRemanente("8", "5", "15");

    super.initState();
  }

  List<String> listaTapaPiton = [
    'Tapa válvula Metálica',
    'Tapa válvula Plastico',
    'Sin tapa válvula'
  ];
  int tapaPitonIdselected = 1;

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
  int accesibilidadIdselected = 1;
  bool statusAccesibilidadNO = false;

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
  int _motivoInnacesibilidadId = 0;
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
  int _value_estado = 1;
  bool _point_edit = false;
  Uint8List? pickedImageAsBytesEdit;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? pickedImageXFile;
  // Checkboxes Duales mal hermanados
  bool _isActivateDisenio = false;
  bool _isActivateTamanio = false;
  bool _isActivateTipoConstruccion = false;
  bool _isActivateMedidaNeumatico = false;
  bool _isActivateNoAplica = false;

  // Link Imagen Edit
  String str_image_view =
      "https://cdn2.atraccion360.com/media/aa/cegjmxouuaajzve.jpg";

  // Radio Buttons separacion entre duales
  int _value_estado_separcion_dual = 1;

  // Checkboxes Observaciones
  bool _isActivateDesgIrregular = false;
  bool _isActivateParReparar = false;
  bool _isActivateAroDefectuoso = false;
  bool _isActivateFallFlanco = false;

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
  int _desgIrregularId = 0;
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
  int _paraRepararId = 0;
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
  int _fallaFlancoId = 0;
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

  // Consultas Future Validate
  Future<void> _validateMMRemanente(
      String exterior, String medio, String interior) async {
    final response = await http.post(
      Uri.parse(
          "https://tiresoft2.lab-elsol.com/api/neumaticos/validateRemanentes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'clienteId': widget._global_id_cliente,
        "id_neumaticos": "1292",
        "exterior": exterior,
        "medio": medio,
        "interior": interior,
      }),
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

  @override
  Widget build(BuildContext context) {
    print("Id > " + widget._global_insp_dtail.idt_id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Serie: " + widget._global_insp_dtail.idt_serie),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _globalFormKey,
            child: Center(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "P-" +
                            widget._global_insp_dtail.idt_posicion.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18.0),
                      ),
                      IconButton(
                        icon: Image.asset('assets/llanta2.jpg'),
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
                        child: estadoWidget(),
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
                      MaterialButton(
                        padding: EdgeInsets.only(right: 45.0, left: 45.0),
                        color: Color(0xff212F3D),
                        textColor: Colors.white,
                        child: Text(
                          'Guardar',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        onPressed: () async => {updateInspeccionNeumatico()},
                      )
                    ],
                  )),
            )),
      ),
    );
  }

  Future<void> updateInspeccionNeumatico() async {
    print("createScrapDirecto()");
    print("PSI > " + _ctrlr_PSI.text.toString());
    print("P.Actual > " + _ctrlr_presion_actual.text.toString());
    print("Tapa Piton Id > " + tapaPitonIdselected.toString());

    print(
        "Inaccesibilidad SI(1) NO(0) > " + accesibilidadIdselected.toString());
    print("Inaccesibilidad Id > " + _motivoInnacesibilidadId.toString());
    print("Tuerca Estado Id > " + _estadoTuercaId.toString());

    print("_isActivateDisenio > " + _isActivateDisenio.toString());
    print("_isActivateTamanio > " + _isActivateTamanio.toString());
    print("_isActivateTipoConstruccion > " +
        _isActivateTipoConstruccion.toString());
    print("_isActivateMedidaNeumatico > " +
        _isActivateMedidaNeumatico.toString());
    print("_isActivateNoAplica > " + _isActivateNoAplica.toString());

    print("Estado > " + _value_estado.toString());
    print("Image Edit > " + pickedImageAsBytesEdit.toString());
    print("Separacion entre duales Id > " +
        _value_estado_separcion_dual.toString());
    print("Desgaste Irregular > " + _isActivateDesgIrregular.toString());
    print("Desgaste Irregular Option > " + _desgIrregularId.toString());
    print("Para Reparar > " + _isActivateParReparar.toString());
    print("Para Reparar Option > " + _paraRepararId.toString());
    print("Aro Defectuoso > " + _isActivateAroDefectuoso.toString());
    print("Falla Flanco > " + _isActivateFallFlanco.toString());
    print("Falla Flanco Option > " + _fallaFlancoId.toString());

    print("Cantidad Tuerca > " + _ctrlr_cantidad_tuerca.text.toString());
    print("Recomendacion > " + _ctrlr_recomendacion.text.toString());
    print("RM Exterior > " + _ctrlr_rm_exterior.text.toString());
    print("RM Medio > " + _ctrlr_rm_medio.text.toString());
    print("RM Interior > " + _ctrlr_rm_interior.text.toString());
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
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _ctrlr_presion_actual,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => validatePresion(val.toString()),
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

  Future<bool> validatePresion(String pressure) async {
    var presion = int.tryParse(pressure) ?? 0;
    print("PSI > " + presion.toString());
    if (presion > 160) {
      setState(() {
        messageValidationPresion = "La presion debe ser menor a 160";
      });
      return true;
    } else {
      setState(() {
        messageValidationPresion = "";
      });
      return false;
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
                  }),
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

  Widget estadoWidget() {
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
                    pickedImageAsBytesEdit = null;
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
                    pickedImageAsBytesEdit = null;
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
                  });
                },
              ),
              SizedBox(width: 10.0),
              Text("Lista para Reemplazar")
            ],
          ),
          _value_estado.toInt() == 3 ? calcularPhoto() : Text(""),
        ],
      ),
    );
  }

  Widget calcularPhoto() {
    if (_point_edit == true) {
      return camaraUploadEditPhoto();
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
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget camaraUploadEditPhoto() {
    return Center(
      child: Column(
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
                _pickImageOpenCamara();
              },
              child: const Text('Adjuntar foto 1')),
          Container(
            child: pickedImageAsBytesEdit != null
                ? Image.memory(
                    pickedImageAsBytesEdit!,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  )
                : Container(
                    decoration: BoxDecoration(color: Colors.red[200]),
                    width: 200,
                    height: 200,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 14.0),
            ),
            onPressed: () {
              print("Button Editar Desactivate");
              setState(() {
                _point_edit = false;
                pickedImageAsBytesEdit = null;
              });
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

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
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    // readOnly: true,
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

  void _pickImageOpenCamara() async {
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
      final XFile? file = await _imagePicker.pickImage(source: imageSource);

      if (file != null) {
        file.readAsBytes().then((x) {
          setState(() => {pickedImageAsBytesEdit = x});
        });
        setState(() => {pickedImageXFile = file});
      }
    }
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
