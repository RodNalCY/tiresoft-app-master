import 'package:flutter/material.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';

class ListNeumaticosDetails extends StatefulWidget {
  final Neumatico _neumatico;
  final String texto;

  ListNeumaticosDetails(this._neumatico, this.texto, {Key? key})
      : super(key: key);

  @override
  State<ListNeumaticosDetails> createState() => _ListNeumaticosDetailsState();
}

class _ListNeumaticosDetailsState extends State<ListNeumaticosDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Neumatico: " + widget.texto),
          backgroundColor: Color(0xff212F3D),
        ),
        body: Container(
          color: Color.fromARGB(255, 227, 235, 243),
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text.rich(
                    TextSpan(
                      text: 'Marca: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._neumatico.n_marca,
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
                            text: widget._neumatico.n_modelo,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17.0)),
                      ],
                      style: TextStyle(fontSize: 16.0)),
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text.rich(TextSpan(
                    text: 'Medida: ', // default text style
                    children: <TextSpan>[
                      TextSpan(
                          text: widget._neumatico.n_medida,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0)),
                    ],
                    style: TextStyle(fontSize: 16.0))),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text.rich(
                  TextSpan(
                      text: 'Condición: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._neumatico.n_condicion,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17.0)),
                      ],
                      style: TextStyle(fontSize: 16.0)),
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text.rich(
                    TextSpan(
                      text: 'Estado: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._neumatico.n_estado,
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
                      text: 'Vehiculo: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._neumatico.n_vehiculo,
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
                      text: 'Fecha de Registro: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._neumatico.n_f_registro,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17.0)),
                      ],
                      style: TextStyle(fontSize: 16.0)),
                ),
              ),
              SizedBox(height: 50.0),
              MaterialButton(
                minWidth: 150.0,
                height: 40.0,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Se envio a Scrap : " + widget._neumatico.n_serie)));
                },
                color: Color(0xff212F3D),
                child:
                    Text('Enviar Scrap', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ));
  }
}
