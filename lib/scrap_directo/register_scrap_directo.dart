import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
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
          child: Text(listaMotivoScrap[int.parse(value) - 1]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          motivoScrapIdselected = int.parse(_val.toString());
        });
      },
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
                          children: [
                            Text(
                              "Condición Neumático:",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            SizedBox(width: 15.0),
                            condicionNeumaticoWidgetList(),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "Marca Neumático:",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            SizedBox(width: 15.0),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "Modelo Neumático:",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            SizedBox(width: 15.0),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "Medida Neumático:",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            SizedBox(width: 15.0),
                          ],
                        )),
                    SizedBox(height: 15.0),
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
    print("ID-CLIENTE > " + widget._cliente_id.toString());
    print("ID-NumeroCliente > " + _txtEdNumSerie.text.toString());
    print("ID-DOT > " + _txtEdDOT.text.toString());
    print("ID-CostoSinIGV > " + _txtEdCostoSnIGV.text.toString());
    print("TIPO-MONEDA > " + tipoMonedaIdselected.toString());
    print("CONDICION NEUMATICOS> " + condicionNeumaticoIdselected.toString());

    print("R-Original > " + _txtEdRemOriginal.text.toString());
    print("R-Final > " + _txtEdRemFinal.text.toString());
    print("R-Limite > " + _txtEdRemLimite.text.toString());

    print("km-Inicial > " + _txtEdKmInicial.text.toString());
    print("km-Final > " + _txtEdKmFinal.text.toString());

    print("MOTIVO SCRAP > " + motivoScrapIdselected.toString());

    print("Fecha Scrap> " + _txtEdFechaScrap.text.toString());

    setState(() {
      isLoadingSave = false;
    });
  }
}
