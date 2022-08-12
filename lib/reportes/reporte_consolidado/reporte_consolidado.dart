import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';

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
  String _dropdownValueAnio = 'Año';
  String _dropdownValueMesInit = 'Mes Inicial';
  String _dropdownValueMesFinal = 'Mes Final';

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
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                          color: Color(0xff212F3D),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      '(FEBRERO a ABRIL - 2022)',
                      style:
                          TextStyle(color: Color(0xff212F3D), fontSize: 14.0),
                    ),
                  ),
                ),
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
                        child: DropdownButton<String>(
                          value: _dropdownValueAnio,
                          icon: const Icon(
                            Icons.expand_more,
                            color: Colors.blue,
                          ),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          underline: Container(
                            height: 1,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownValueAnio = newValue!;
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
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _dropdownValueMesInit,
                          icon:
                              const Icon(Icons.expand_more, color: Colors.blue),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          underline: Container(
                            height: 1,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownValueMesInit = newValue!;
                            });
                          },
                          items: <String>[
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
                            ' Octubre',
                            'Noviembre',
                            'Diciembre'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _dropdownValueMesFinal,
                          icon:
                              const Icon(Icons.expand_more, color: Colors.blue),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          underline: Container(
                            height: 1,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownValueMesFinal = newValue!;
                            });
                          },
                          items: <String>[
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
                            ' Octubre',
                            'Noviembre',
                            'Diciembre'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(right: 45.0, left: 45.0),
                      primary: Colors.blue,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Consultar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
