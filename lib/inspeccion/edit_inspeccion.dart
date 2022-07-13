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
  @override
  void initState() {
    _ctrlr_PSI = new TextEditingController(text: 'PSI');
    _ctrlr_presion_actual = new TextEditingController(
        text: widget._global_insp_dtail.idt_posicion.toString());
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
        });
      },
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

  @override
  Widget build(BuildContext context) {
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
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   child: separacionDualesWidget(),
                      // ),
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

    print("Inaccesibilidad SI NO > " + accesibilidadIdselected.toString());
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
  }

  Widget presionCardWidget() {
    return CustomCart(
      'Presión',
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "alert - message",
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
              child: motivoInnacesibilidadWidgetList(),
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
                "alert - message",
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
                      onChanged: (val) => {},
                      controller: null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Exterior'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) => {},
                      controller: null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Medio'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) => {},
                      controller: null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Interior'),
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
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              readOnly: true,
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
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
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              readOnly: true,
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Observaciones'),
            ),
          ),
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
                    readOnly: true,
                    controller: null,
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
              readOnly: true,
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
          ),
        ],
      ),
    );
  }
}
