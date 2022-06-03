import 'package:flutter/material.dart';
import 'package:tiresoft/neumaticos/models/neumatico.dart';

class ListNeumaticosDetails extends StatefulWidget {
  final String texto;
  final Neumatico _neumatico;
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
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Rodnal"),
              Text("Cabello"),
              Text("Yacolca")
            ],
          ),
        ));
  }
}
