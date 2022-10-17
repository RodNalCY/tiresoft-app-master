import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/anio.dart';
import 'package:tiresoft/reportes/reporte_consolidado/models/mes.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_desgaste_irregular.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_distribucion_medida.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_equipos_inspeccionados.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_graphic_inspecciones.dart';
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
  late List<Anio> _list_anios = [];
  late String _ddownFirstAnioName;
  late String _ddownFirstAnioId;
  bool statusMes = false;
  bool statusMessage = false;

  Future<List<Anio>> cargarListaAnios() async {
    print("cargarListaAnios()");
    final response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/reporte/anios"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': '5',
      }),
    );
    _list_anios = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData['success']['datos']) {
        _list_anios.add(Anio(item['anio'], item['anio']));
      }

      _ddownFirstAnioName = jsonData['success']['datos'][0]['anio'];
      _ddownFirstAnioId = jsonData['success']['datos'][0]['anio'];
      cargarListaMeses();

      return _list_anios;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  late List<Mes> _mesesList = [];
  late String _ddownFirsMesInitName;
  late String _ddownFirsMesInitId;

  late String _ddownFirsMesFinishName;
  late String _ddownFirsMesFinishId;

  Future<List<Mes>> cargarListaMeses() async {
    print("cargarListaMeses()");
    final response = await http.post(
      Uri.parse("https://tiresoft2.lab-elsol.com/api/reporte/meses"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_cliente': '5',
        'year': _ddownFirstAnioId,
      }),
    );
    _mesesList = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData['success']['datos']) {
        _mesesList.add(Mes(item['numero_mes'], item['mes']));
      }

      setState(() {
        _ddownFirsMesInitName = jsonData['success']['datos'][0]['mes'];
        _ddownFirsMesInitId = jsonData['success']['datos'][0]['numero_mes'];

        _ddownFirsMesFinishName = jsonData['success']['datos'][0]['mes'];
        _ddownFirsMesFinishId = jsonData['success']['datos'][0]['numero_mes'];
        statusMes = true;
      });

      return _mesesList;
    } else {
      throw Exception("Falló la Conexión");
    }
  }

  Container widgetDropDownMInit() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: DropdownButton<String>(
        value: _ddownFirsMesInitName,
        icon: const Icon(
          Icons.expand_more,
          color: Colors.blue,
        ),
        elevation: 16,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        underline: Container(
          height: 1,
          color: Colors.blue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _ddownFirsMesInitName = newValue!;
          });
        },
        items: _mesesList
            .map((fc) => DropdownMenuItem<String>(
                  onTap: () {
                    _ddownFirsMesInitId = fc.m_id.toString();
                  },
                  child: Text(fc.m_mes),
                  value: fc.m_mes,
                ))
            .toList(),
      ),
    );
  }

  Container widgetDropDownMFinish() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: DropdownButton<String>(
        value: _ddownFirsMesFinishName,
        icon: const Icon(
          Icons.expand_more,
          color: Colors.blue,
        ),
        elevation: 16,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        underline: Container(
          height: 1,
          color: Colors.blue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _ddownFirsMesFinishName = newValue!;
          });
        },
        items: _mesesList
            .map((fc) => DropdownMenuItem<String>(
                  onTap: () {
                    _ddownFirsMesFinishId = fc.m_id.toString();
                  },
                  child: Text(fc.m_mes),
                  value: fc.m_mes,
                ))
            .toList(),
      ),
    );
  }

  Widget widgetDropDownAnio() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: DropdownButton<String>(
        value: _ddownFirstAnioName,
        icon: const Icon(
          Icons.expand_more,
          color: Colors.blue,
        ),
        elevation: 16,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        underline: Container(
          height: 1,
          color: Colors.blue,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _ddownFirstAnioName = newValue!;
            cargarListaMeses();
          });
        },
        items: _list_anios
            .map((fc) => DropdownMenuItem<String>(
                  onTap: () {
                    _ddownFirstAnioId = fc.a_id.toString();
                  },
                  child: Text(fc.a_anio),
                  value: fc.a_anio,
                ))
            .toList(),
      ),
    );
  }

  Widget dropDownBloqueado() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: DropdownButton<String>(
          icon: const Icon(
            Icons.expand_more,
            color: Colors.blue,
          ),
          underline: Container(),
          hint: SizedBox(
            width: 55.0,
            child: LinearProgressIndicator(
              color: Colors.blue.shade300,
              backgroundColor: Colors.white,
              minHeight: 2,
            ),
          ),
          onChanged: null,
          items: []),
    );
  }

  @override
  void initState() {
    _ctrl_email_user = TextEditingController(text: widget._user[0].u_email);
    cargarListaAnios();
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
        height: double.infinity,
        color: Color.fromARGB(255, 227, 235, 243),
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
                    statusMessage
                        ? Container(
                            child: Center(
                              child: Text(
                                '(${_ddownFirsMesInitName} a ${_ddownFirsMesFinishName} - ${_ddownFirstAnioId})',
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
                          statusMes
                              ? widgetDropDownAnio()
                              : dropDownBloqueado(),
                          statusMes
                              ? widgetDropDownMInit()
                              : dropDownBloqueado(),
                          statusMes
                              ? widgetDropDownMFinish()
                              : dropDownBloqueado(),
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
                              setState(() => statusMessage = true),
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
                      margin:
                          EdgeInsets.only(top: 25.0, left: 13.0, right: 13.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        minHeight: 2,
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
                        showDialogConfirmEmail(context, _ctrl_email_user.text);
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

  Future<void> showDialogConfirmEmail(
      BuildContext context, String email) async {
    Navigator.of(context).pop();
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
                        minHeight: 2,
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
    print('Anio   > ${_ddownFirstAnioId}');
    print('MesInit > ${_ddownFirsMesInitId}');
    print('MesFin  > ${_ddownFirsMesFinishId}');
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
        'month1': _ddownFirsMesInitId.toString(),
        'month2': _ddownFirsMesFinishId.toString(),
        'year': _ddownFirstAnioId.toString(),
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
    print("Generando... Reporte Consolidado");
    setState(() {
      isActivedReporteConsolidado = true;
      isLoading = true;
      _refresh = true;
      statusMessage = true;
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

  Widget pintarGraficos() {
    print('Anio    : ${_ddownFirstAnioId}');
    print('MesInit : ${_ddownFirsMesInitId}');
    print('MesFin  : ${_ddownFirsMesFinishId}');
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // WidgetEquiposInspeccionados(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetDistribucionMedida(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetPosicionRuedaMarca(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetMarcaEjeDireccional(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetMarcaEjeTraccion(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetMarcaEjeApoyo(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetMalEstado(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetResumenScrap(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetResumenRetiro(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          SizedBox(
            height: 30.0,
          ),
          WidgetRemanenteUnidad(
            cliente: widget._id_cliente,
            anio: _ddownFirstAnioId,
            mes_inicio: _ddownFirsMesInitId.toString(),
            mes_fin: _ddownFirsMesFinishId.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          WidgetRemanenteMedida(
            cliente: widget._id_cliente,
            anio: _ddownFirstAnioId,
            mes_inicio: _ddownFirsMesInitId.toString(),
            mes_fin: _ddownFirsMesFinishId.toString(),
            refresh: _refresh,
          ),
          SizedBox(
            height: 30.0,
          ),
          // WidgetServicioReencauche(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetDesgasteIrregular(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetInfladoNeumatico(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetPresionInflado(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetReencauche(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetReencauchabilidad(
          //   cliente: widget._id_cliente,
          //   anio: _ddownFirstAnioId,
          //   mes_inicio: _ddownFirsMesInitId.toString(),
          //   mes_fin: _ddownFirsMesFinishId.toString(),
          //   refresh: _refresh,
          // ),
          // SizedBox(
          //   height: 30.0,
          // ),
          // WidgetInpeccionesCard()
        ],
      ),
    );
  }

  Center WidgetInpeccionesCard() {
    return Center(
      child: Card(
        color: Color.fromARGB(255, 225, 245, 252),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            const ListTile(
              leading: Icon(
                Icons.swipe_right,
                size: 35,
                color: Colors.blue,
              ),
              subtitle: Text(
                'Para visualizar las inspecciones debe ir a la siguiente vista.',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('VOLVER'),
                  onPressed: null,
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text(
                    'SIGUIENTE',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    final detail_inspeccion =
                        '${_ddownFirsMesInitName} a ${_ddownFirsMesFinishName} - ${_ddownFirstAnioId}';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WidgetGraphicInspecciones(
                            cliente: widget._id_cliente,
                            anio: _ddownFirstAnioId,
                            mes_inicio: _ddownFirsMesInitId.toString(),
                            mes_fin: _ddownFirsMesFinishId.toString(),
                            refresh: _refresh,
                            details: detail_inspeccion),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
