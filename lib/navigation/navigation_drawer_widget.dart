import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/models/navigation_item_model.dart';
import 'package:tiresoft/navigation/provider/navigation_change_provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final List<User> _user;
  final String _global_client_name;
  const NavigationDrawerWidget(this._user, this._global_client_name, {Key? key})
      : super(key: key);

  static final _padding = EdgeInsets.symmetric(horizontal: 2.0);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  String _name = "";
  String _email = "";
  String _cliente = "";
  String _logo_url = "";

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Drawer >>>");

    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    _logo_url = widget._user[0].u_img_logo;

    if ((widget._user[0].u_name + " " + widget._user[0].u_lastname).length >
        15) {
      _name = (widget._user[0].u_name + " " + widget._user[0].u_lastname)
              .substring(0, 15) +
          "...";
    } else {
      _name = widget._user[0].u_name + " " + widget._user[0].u_lastname;
    }

    if (widget._user[0].u_email.length > 25) {
      _email = (widget._user[0].u_email).substring(0, 25) + "...";
    } else {
      _email = widget._user[0].u_email;
    }

    if (widget._global_client_name.length > 25) {
      _cliente = (widget._global_client_name).substring(0, 25) + "...";
    } else {
      _cliente = widget._global_client_name;
    }

    return Drawer(
      child: Container(
        color: Color(0xff212F3D),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: safeArea,
              width: double.infinity,
              child: buildHeader(context,
                  urlImage: _logo_url,
                  name: _name,
                  email: _email,
                  client: _cliente),
            ),
            const SizedBox(height: 20.0),
            buildOneMenuItem(context,
                text: 'Nueva Inspección',
                item: NavigationItemModel.registro_inspeccion,
                icon: Icons.add_circle),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Reporte Inspección',
                item: NavigationItemModel.reporte_inspeccion,
                icon: Icons.checklist),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Reporte Vehiculos',
                item: NavigationItemModel.reporte_vehiculo,
                // icon: Icons.toys
                icon: Icons.checklist),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Reporte Neumáticos',
                item: NavigationItemModel.reporte_neumatico,
                // icon: Icons.data_saver_off
                icon: Icons.sort),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Nuevo Scrap',
                item: NavigationItemModel.register_scrap_home,
                icon: Icons.add_circle),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Reporte de Scrap',
                item: NavigationItemModel.reporte_scrap,
                icon: Icons.checklist),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Reporte mal estado',
                item: NavigationItemModel.reporte_neumatico_mal_estado,
                icon: Icons.checklist),
            const SizedBox(height: 5.0),
            buildOneMenuItem(context,
                text: 'Reporte Consolidado',
                item: NavigationItemModel.reporte_consolidado,
                icon: Icons.apps),
            Spacer(),
            //const SizedBox(height: 24.0),
            Divider(color: Colors.white70),
            buildOneMenuItem(context,
                text: 'Cerrar',
                item: NavigationItemModel.salir,
                icon: Icons.exit_to_app),
          ],
        ),
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
    final _color =
        isSelected ? Color.fromARGB(255, 84, 237, 248) : Colors.white38;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.black26,
        leading: Icon(icon, color: _color),
        // dense: true,
        horizontalTitleGap: 3.0,
        title: Text(
          text,
          style: TextStyle(color: _color, fontSize: 14.5),
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
      {required String urlImage,
      required String name,
      required String email,
      required String client}) {
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
              CircleAvatar(radius: 35.0, backgroundImage: AssetImage(urlImage)),
              SizedBox(width: 10.0),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, right: 10.0, left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    const SizedBox(height: 1.0),
                    Text(email,
                        style: TextStyle(fontSize: 13.0, color: Colors.white)),
                    const SizedBox(height: 7.0),
                    Text(client,
                        style: TextStyle(fontSize: 13.0, color: Colors.white)),
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
