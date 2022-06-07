import 'package:flutter/material.dart';
import 'package:tiresoft/scrap/Models/Scrapt.dart';

class ListScraptDetails extends StatefulWidget {
  final Scrapt _scrapt;
  final String texto;
  ListScraptDetails(this._scrapt, this.texto, {Key? key}) : super(key: key);

  @override
  State<ListScraptDetails> createState() => _ListScraptDetailsState();
}

class _ListScraptDetailsState extends State<ListScraptDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Neumático: " + widget.texto),
          backgroundColor: Color(0xff212F3D),
        ),
        body: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text.rich(
                    TextSpan(
                      text: 'Marca: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._scrapt.s_marca,
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
                            text: widget._scrapt.s_modelo,
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
                      text: 'Medida: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._scrapt.s_medida,
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
                      text: 'Motivo Scrap: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._scrapt.s_motivo_scrap,
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
                      text: 'Remanete Final: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._scrapt.s_remanente_final,
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
                      text: 'Remanente Límite: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._scrapt.s_remanente_limite,
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
                      text: 'Fecha Scrap: ', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: widget._scrapt.s_fecha_scrap,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17.0)),
                      ],
                    ),
                    style: TextStyle(fontSize: 16.0)),
              ),
              SizedBox(height: 10.0)
            ])));
  }
}
