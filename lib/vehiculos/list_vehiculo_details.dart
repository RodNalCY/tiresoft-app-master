import 'package:flutter/material.dart';
import 'package:tiresoft/vehiculos/models/vehiculo.dart';

class ListVehiculoDetails extends StatefulWidget {
  Vehiculo _vehiculo;
  String _placa;

  ListVehiculoDetails(this._vehiculo, this._placa, {Key? key})
      : super(key: key);

  @override
  State<ListVehiculoDetails> createState() => _ListVehiculoDetailsState();
}

class _ListVehiculoDetailsState extends State<ListVehiculoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Neumatico: " + widget._placa),
        backgroundColor: Color(0xff212F3D),
      ),
      body: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Codigo: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_codigo,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Tipo: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_tipo,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Marca: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_marca,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Modelo: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_modelo,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Configuración: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_configuracion,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Aplicación: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_aplicacion,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Planta: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_planta,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Estado: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_estado,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Fabricación: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_anio_fabricacion,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                  TextSpan(
                    text: 'Fecha Registro: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._vehiculo.v_f_registro,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                  ),
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(height: 50.0),
            MaterialButton(
              minWidth: 150.0,
              height: 40.0,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Se envio a Scrap : " + widget._vehiculo.v_placa)));
              },
              color: Color(0xff212F3D),
              child: Text('Desintalar', style: TextStyle(color: Colors.white)),
            ),
          ])),
    );
  }
}
