import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScrapDirecto extends StatefulWidget {
  final String _cliente_id;
  final String _cliente_name;
  final List<User> _user;

  RegisterScrapDirecto(this._cliente_id, this._user, this._cliente_name,
      {Key? key})
      : super(key: key);

  @override
  State<RegisterScrapDirecto> createState() => _RegisterScrapDirectoState();
}

class _RegisterScrapDirectoState extends State<RegisterScrapDirecto> {
  @override
  Widget build(BuildContext context) {
    print("REGISTRO SCRAP DIRECTO");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavigationDrawerWidget(widget._user, widget._cliente_name),
      appBar: AppBar(
        title: Text("Neumático Directo"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff212F3D),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("4-Method dispose()");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("3-Method deactivate()");
  }
}
