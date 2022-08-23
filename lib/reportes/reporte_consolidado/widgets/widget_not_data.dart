import 'package:flutter/material.dart';

class WidgetNotData extends StatelessWidget {
  final String title;

  const WidgetNotData({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.cancel,
        size: 40.0,
      ),
      title: Text(title),
      subtitle: Text("No existen datos para el gráfico."),
    );
  }
}
