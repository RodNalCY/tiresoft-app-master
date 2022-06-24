import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';
import 'package:tiresoft/scrap/demo_view.dart';
import 'package:tiresoft/scrap/record_scrap_screen.dart';
import 'package:tiresoft/scrap_directo/register_scrap_directo.dart';

class ScrapRegisterHome extends StatefulWidget {
  List<User> _user;
  String _id_cliente;
  String _name_cliente;

  ScrapRegisterHome(this._id_cliente, this._user, this._name_cliente,
      {Key? key})
      : super(key: key);

  @override
  State<ScrapRegisterHome> createState() => _ScrapRegisterHomeState();
}

class _ScrapRegisterHomeState extends State<ScrapRegisterHome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      RecordScrapScreen(widget._id_cliente, widget._user, widget._name_cliente),
      RegisterScrapDirecto(
          widget._id_cliente, widget._user, widget._name_cliente)
    ];

    return MaterialApp(
        home: Scaffold(
            // drawer: NavigationDrawerWidget(widget._user, widget._name_cliente),
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                backgroundColor: Color(0xff212F3D),
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white38,
                iconSize: 27.0,
                unselectedFontSize: 12.0,
                // showUnselectedLabels: false,
                onTap: (index) => setState(() => currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_backup_restore),
                    label: 'Instalado',
                    // backgroundColor: Colors.redAccent
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_circle_down),
                    label: 'Directo',
                    // backgroundColor: Colors.blueAccent
                  )
                ])));
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
