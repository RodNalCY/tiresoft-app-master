import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/models/navigation_item_model.dart';
import 'package:tiresoft/navigation/provider/navigation_change_provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final List<User> _user;
  const NavigationDrawerWidget(this._user, {Key? key}) : super(key: key);

  static final _padding = EdgeInsets.symmetric(horizontal: 5.0);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  String _name = "";
  String _name_length = "";
  String _email = "";
  String _email_length = "";
  String _urlLogo = "";
  @override
  Widget build(BuildContext context) {
    print("Drawer >>>");
    _name_length = widget._user[0].u_name + " " + widget._user[0].u_lastname;
    _email_length = widget._user[0].u_email;
    _urlLogo = widget._user[0].u_img_logo;

    if (_name_length.length > 15) {
      _name = (widget._user[0].u_name + " " + widget._user[0].u_lastname)
              .substring(0, 15) +
          "...";
    } else {
      _name = _name_length;
    }

    if (_email_length.length > 27) {
      _email = (widget._user[0].u_email).substring(0, 27) + "...";
    } else {
      _email = _email_length;
    }

    return ChangeNotifierProvider(
      create: (context) => NavigationChangeProvider(),
      child: Drawer(
        child: Container(
            color: Color(0xff212F3D),
            child: ListView(
              children: [
                buildHeader(context,
                    urlImage: _urlLogo, name: _name, email: _email),
                Container(
                  padding: NavigationDrawerWidget._padding,
                  child: Column(children: [
                    const SizedBox(height: 24.0),
                    buildOneMenuItem(context,
                        text: 'Registrar Inspección',
                        item: NavigationItemModel.registro_inspeccion,
                        icon: Icons.control_point),
                    const SizedBox(height: 16.0),
                    buildOneMenuItem(context,
                        text: 'Reporte Inspección',
                        item: NavigationItemModel.reporte_inspeccion,
                        icon: Icons.format_list_bulleted),
                    const SizedBox(height: 16.0),
                    buildOneMenuItem(context,
                        text: 'Reporte Vehiculos',
                        item: NavigationItemModel.reporte_vehiculo,
                        icon: Icons.toys),
                    const SizedBox(height: 16.0),
                    buildOneMenuItem(context,
                        text: 'Reporte Neumáticos',
                        item: NavigationItemModel.reporte_neumatico,
                        icon: Icons.data_saver_off),
                    const SizedBox(height: 16.0),
                    buildOneMenuItem(context,
                        text: 'Asignar Neumático a Scrap',
                        item: NavigationItemModel.asignar_neumatico_scrap,
                        icon: Icons.control_point),
                    const SizedBox(height: 16.0),
                    buildOneMenuItem(context,
                        text: 'Reporte de Scrap',
                        item: NavigationItemModel.reporte_scrap,
                        icon: Icons.format_list_bulleted),
                    const SizedBox(height: 150.0),
                    Divider(color: Colors.white70),
                    buildOneMenuItem(context,
                        text: 'Cerrar',
                        item: NavigationItemModel.salir,
                        icon: Icons.exit_to_app),
                    const SizedBox(height: 24.0),
                  ]),
                )
              ],
            )),
      ),
    );
  }

  Widget buildOneMenuItem(BuildContext context,
      {required NavigationItemModel item,
      required String text,
      required IconData icon}) {
    final provider = Provider.of<NavigationChangeProvider>(context);
    final currentItem = provider.navigationItemModel;
    final isSelected = item == currentItem;
    final _color = isSelected ? Colors.orangeAccent : Colors.white;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.white24,
        leading: Icon(icon, color: _color),
        title: Text(
          text,
          style: TextStyle(color: _color, fontSize: 15.0),
        ),
        onTap: () => selectedItemMenuView(context, item),
      ),
    );
  }

  selectedItemMenuView(BuildContext context, NavigationItemModel item) {
    final provider =
        Provider.of<NavigationChangeProvider>(context, listen: false);
    provider.setNavigationItem(item);
  }

  Widget buildHeader(BuildContext context,
      {required String urlImage, required String name, required String email}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/tiresoft-background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              selectedItemMenuView(context, NavigationItemModel.header),
          child: Container(
            padding: NavigationDrawerWidget._padding
                .add(EdgeInsets.symmetric(vertical: 40.0)),
            child: Row(children: [
              CircleAvatar(radius: 30.0, backgroundImage: AssetImage(urlImage)),
              SizedBox(width: 20.0),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.only(
                    top: 4.0, bottom: 4.0, right: 7.0, left: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    const SizedBox(height: 4.0),
                    Text(email,
                        style: TextStyle(fontSize: 14.0, color: Colors.white)),
                  ],
                ),
              ),
              // Spacer(),
              // CircleAvatar(
              //   radius: 30.0,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ]),
          ),
        ),
      ),
    );
  }
}
