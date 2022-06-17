import 'package:flutter/material.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';

class HeaderDrawerPage extends StatelessWidget {
  const HeaderDrawerPage({Key? key}) : super(key: key);
  final urlImage =
      "https://blogs.elespectador.com/wp-content/uploads/2018/11/John-Freddy-Vega-Cofundador-Platzi.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Header"),
        centerTitle: true,
      ),
      body: Image.network(urlImage,
          width: double.infinity, height: double.infinity, fit: BoxFit.cover),
    );
  }
}
