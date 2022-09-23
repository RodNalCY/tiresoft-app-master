import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_desgaste_irregular.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_distribucion_medida.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_equipos_inspeccionados.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_inflado_neumatico.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_inspecciones.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_mal_estado.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_marca_eje_apoyo.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_marca_eje_traccion.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_marcas_eje_direccional.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_posicion_rueda_marca.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_presion_inflado.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_reencauchabilidad.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_reencauche.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_remanente_medida.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_remanente_unidad.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_resumen_retiro.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_resumen_scrap.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_servicio_reencauche.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReporteConsolidado extends StatefulWidget {
  final String _id_cliente;
  final String _name_cliente;
  final List<User> _user;

  ReporteConsolidado(this._id_cliente, this._user, this._name_cliente,
      {Key? key})
      : super(key: key);

  @override
  State<ReporteConsolidado> createState() => _ReporteConsolidadoState();
}

class _ReporteConsolidadoState extends State<ReporteConsolidado> {
  late final TextEditingController _ctrl_email_user;
  late bool _refresh = false;
  late bool _isLoadingSend = false;
  // Activador para el reporte
  bool isActivedReporteConsolidado = false;
  bool isLoading = false;
  // AÑO SELECTED
  String anioIdSelected = "Año";
  Widget anioWidgetList() {
    return DropdownButton<String>(
      value: anioIdSelected,
      icon: const Icon(
        Icons.expand_more,
        color: Colors.blue,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      underline: Container(
        height: 1,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          anioIdSelected = newValue!;
        });
      },
      items: <String>['Año', '2019', '2020', '2021', '2022']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
    );
  }

  // MES INICIAL SELECTED
  int mesesIdselectedInit = 0;
  List<String> listaMesesNameInit = [
    'Mes Inicial',
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Setiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  Widget mesesInitedWidgetList() {
    return DropdownButton<String>(
      icon: const Icon(Icons.expand_more, color: Colors.blue),
      elevation: 16,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      underline: Container(
        height: 1,
        color: Colors.blue,
      ),
      value: mesesIdselectedInit.toString(),
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
        '12'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(listaMesesNameInit[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          mesesIdselectedInit = int.parse(_val.toString());
        });
      },
    );
  }

  // AÑO FINAL SELECTED
  int mesesIdselectedFinish = 0;
  List<String> listaMesesNameFinish = [
    'Mes Final',
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Setiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  Widget mesesFinishedWidgetList() {
    return DropdownButton<String>(
      icon: const Icon(Icons.expand_more, color: Colors.blue),
      elevation: 16,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      underline: Container(
        height: 1,
        color: Colors.blue,
      ),
      value: mesesIdselectedFinish.toString(),
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
        '12'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(listaMesesNameFinish[int.parse(value)]),
        );
      }).toList(),
      onChanged: (_val) {
        setState(() {
          mesesIdselectedFinish = int.parse(_val.toString());
        });
      },
    );
  }

  String calcularMeses(int mes) {
    String value = "";
    switch (mes) {
      case 1:
        value = "Enero";
        break;
      case 2:
        value = "Febrero";
        break;
      case 3:
        value = "Marzo";
        break;
      case 4:
        value = "Abril";
        break;
      case 5:
        value = "Mayo";
        break;
      case 6:
        value = "Junio";
        break;
      case 7:
        value = "Julio";
        break;
      case 8:
        value = "Agosto";
        break;
      case 9:
        value = "Setiembre";
        break;
      case 10:
        value = "Octubre";
        break;
      case 11:
        value = "Noviembre";
        break;
      case 12:
        value = "Diciembre";
        break;
    }
    return value;
  }

  @override
  void initState() {
    _ctrl_email_user = TextEditingController(text: widget._user[0].u_email);
    super.initState();
  }

  @override
  void dispose() {
    print('Finish: dispose()');
    _ctrl_email_user.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
      appBar: AppBar(
        title: Text("Reporte Consolidado"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.white54,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          '${widget._name_cliente}',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    isActivedReporteConsolidado
                        ? Container(
                            child: Center(
                              child: Text(
                                '(${calcularMeses(mesesIdselectedInit)} a ${calcularMeses(mesesIdselectedFinish)} - ${anioIdSelected})',
                                style: TextStyle(
                                    color: Color(0xff212F3D), fontSize: 14.0),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: anioWidgetList(),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: mesesInitedWidgetList(),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: mesesFinishedWidgetList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.red,
                                  size: 15.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Seguimiento del Reporte Consolidado",
                                    style: TextStyle(color: Colors.black38))
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 15.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'No Enviado',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            label: Text("Consultar"),
                            icon: Icon(Icons.visibility),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(right: 15.0, left: 15.0),
                              primary: Colors.blue,
                              elevation: 6.0,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () => generarReporteConsolidado(),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.outgoing_mail),
                            label: Text("Exportar "),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(right: 15.0, left: 15.0),
                              primary: Colors.red,
                              elevation: 6.0,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async => {
                              await showDialogSendEmail(context),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isActivedReporteConsolidado && isLoading
                  ? Container(
                      margin: EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.black12,
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        minHeight: 1.0,
                        // value: _progress,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              isActivedReporteConsolidado ? pintarGraficos() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDialogSendEmail(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15.0,
                      right: 15.0,
                      bottom: 5.0,
                    ),
                    child: new Text(
                      "Generar de Reporte Consolidado",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: new Text(
                    "Verifique si su cuenta de correo electrónico se encuentra activo, caso contrario edite porque se enviará el Reporte Consolidado a su buzón de correo.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: 15.0,
                  ),
                  child: TextFormField(
                    controller: _ctrl_email_user,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _ctrl_email_user.text = widget._user[0].u_email;
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
                        sendEmailValideData(context);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_circle_right,
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

  Future<void> sendEmailValideData(BuildContext context) async {
    if (anioIdSelected == "Año") {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, seleccione el año")),
      );
    } else if (mesesIdselectedInit == 0) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, seleccione el mes inicial")),
      );
    } else if (mesesIdselectedFinish == 0) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, seleccione el mes Final")),
      );
    } else {
      Navigator.of(context).pop();
      showDialogConfirmEmail(context, _ctrl_email_user.text);
    }
  }

  Future<void> showDialogConfirmEmail(
      BuildContext context, String email) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: <Widget>[
                Center(
                  child: new Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Icon(
                      Icons.picture_as_pdf,
                      size: 40.0,
                      color: Colors.red.shade500,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: new Text(
                        "El Reporte Consolidado (.pdf) se enviará al siguiente correo:",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: new Text(
                        '"' + email + '"',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: _isLoadingSend
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              showDialogSendEmail(context);
                            },
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_circle_left,
                              size: 32.0,
                              color: _isLoadingSend ? Colors.grey : Colors.red,
                            ),
                            Text(
                              'atrás',
                              style: TextStyle(
                                fontSize: 11.0,
                                color:
                                    _isLoadingSend ? Colors.grey : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _isLoadingSend
                          ? null
                          : () async {
                              setState(() => _isLoadingSend = true);
                              final response = await sendEmailPost();
                              if (response) {
                                setState(() => _isLoadingSend = false);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Se envio el reporte consolidado correctamente.")),
                                );
                              } else {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Error, no se pude enviar el reporte consolidado.")),
                                );
                              }
                            },
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.outgoing_mail,
                              size: 32.0,
                              color: _isLoadingSend ? Colors.grey : Colors.blue,
                            ),
                            Text(
                              _isLoadingSend ? 'Enviando' : 'Enviar',
                              style: TextStyle(
                                fontSize: 11.0,
                                color:
                                    _isLoadingSend ? Colors.grey : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _isLoadingSend
                    ? SizedBox(
                        height: 20.0,
                      )
                    : Container(),
                _isLoadingSend
                    ? new LinearProgressIndicator(
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                      )
                    : Container(),
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

  Future<bool> sendEmailPost() async {
    print('Cliente > ${widget._id_cliente}');
    print('Usuario > ${widget._user[0].u_id}');
    print('Email   > ${_ctrl_email_user.text}');
    print('Anio   > ${anioIdSelected}');
    print('MesInit > ${mesesIdselectedInit}');
    print('MesFin  > ${mesesIdselectedFinish}');
    bool statusSend = false;

    final response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/reporte/savePdf"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': widget._id_cliente,
        'id_usuario': widget._user[0].u_id.toString(),
        'email': _ctrl_email_user.text.toString(),
        'month1': mesesIdselectedInit.toString(),
        'month2': mesesIdselectedFinish.toString(),
        'year': anioIdSelected.toString(),
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print("JSON:");
      print(jsonData['success']);
      statusSend = true;
    } else {
      throw Exception("Falló la Conexión");
    }
    return statusSend;
  }

  Future<void> generarReporteConsolidado() async {
    if (anioIdSelected == "Año") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, seleccione el año")),
      );
    } else if (mesesIdselectedInit == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, seleccione el mes inicial")),
      );
    } else if (mesesIdselectedFinish == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, seleccione el mes Final")),
      );
    } else {
      print("Generando... Reporte Consolidado");
      setState(() {
        isActivedReporteConsolidado = true;
        isLoading = true;
        _refresh = true;
      });
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _refresh = false;
      });
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget pintarGraficos() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetEquiposInspeccionados(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetDistribucionMedida(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetPosicionRuedaMarca(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetMarcaEjeDireccional(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetMarcaEjeTraccion(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetMarcaEjeApoyo(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetMalEstado(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetResumenScrap(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetResumenRetiro(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetRemanenteUnidad(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetRemanenteMedida(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetServicioReencauche(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetDesgasteIrregular(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetInfladoNeumatico(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetPresionInflado(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetReencauche(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetReencauchabilidad(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetInspecciones(
            cliente: widget._id_cliente,
            anio: anioIdSelected,
            mes_inicio: mesesIdselectedInit.toString(),
            mes_fin: mesesIdselectedFinish.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
