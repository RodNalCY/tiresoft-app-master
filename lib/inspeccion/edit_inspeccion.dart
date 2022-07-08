import 'package:flutter/material.dart';
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
                        iconSize: 80,
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
                      Container(
                        padding: EdgeInsets.all(10),
                        child: separacionDualesWidget(),
                      ),
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              readOnly: true,
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Tapa'),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Accesibilidad'),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Motivo'),
            ),
          ),
        ],
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
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              readOnly: true,
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ok'),
            ),
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
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              readOnly: true,
              controller: null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'optimizar'),
            ),
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
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: null,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Estado de tuercas'),
                  ),
                ),
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
