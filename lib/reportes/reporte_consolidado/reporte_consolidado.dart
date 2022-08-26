import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_distribucion_medida.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_equipos_inspeccionados.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_mal_estado.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_marca_eje_apoyo.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_marca_eje_traccion.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_marcas_eje_direccional.dart';
import 'package:tiresoft/reportes/reporte_consolidado/widgets/widget_posicion_rueda_marca.dart';

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
  // Activador para el reporte
  bool isActivedReporteConsolidado = false;
  bool isActiveBTNConsulta = false;
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
  void dispose() {
    print('Finish: dispose()');
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
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 15.0),
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
                  const SizedBox(height: 25.0),
                  Container(
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
                            child: anioWidgetList()),
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
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 2,
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
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
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
                          onPressed: isActiveBTNConsulta
                              ? null
                              : () => generarReporteConsolidado(),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text("Exportar"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(right: 15.0, left: 15.0),
                            primary: Colors.red,
                            elevation: 6.0,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  ),
                  isActivedReporteConsolidado
                      ? WidgetEquiposInspeccionados(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isActivedReporteConsolidado
                      ? WidgetDistribucionMedida(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isActivedReporteConsolidado
                      ? WidgetPosicionRuedaMarca(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isActivedReporteConsolidado
                      ? WidgetMarcaEjeDireccional(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isActivedReporteConsolidado
                      ? WidgetMarcaEjeTraccion(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isActivedReporteConsolidado
                      ? WidgetMarcaEjeApoyo(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  isActivedReporteConsolidado
                      ? WidgetMalEstado(
                          cliente: widget._id_cliente,
                          anio: anioIdSelected,
                          mes_inicio: mesesIdselectedInit.toString(),
                          mes_fin: mesesIdselectedFinish.toString(),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
        isActiveBTNConsulta = true;
      });
    }
  }
}
