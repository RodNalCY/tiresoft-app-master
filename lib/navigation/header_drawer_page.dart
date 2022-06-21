import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';

class HeaderDrawerPage extends StatefulWidget {
  final List<User> info_user;
  final String _global_cliente_name;
  const HeaderDrawerPage(this.info_user, this._global_cliente_name, {Key? key})
      : super(key: key);

  @override
  State<HeaderDrawerPage> createState() => _HeaderDrawerPageState();
}

class _HeaderDrawerPageState extends State<HeaderDrawerPage> {
  @override
  void deactivate() {
    super.deactivate();
    print("3-Method deactivate()");
  }

  @override
  void dispose() {
    super.dispose();
    print("4-Method dispose()");
  }

  @override
  Widget build(BuildContext context) {
    String link_firma = "";

    if (widget.info_user[0].u_firma != "") {
      link_firma =
          "https://tiresoft2.lab-elsol.com/" + widget.info_user[0].u_firma;
    } else {
      link_firma =
          "https://bitsofco.de/content/images/2018/12/Screenshot-2018-12-16-at-21.06.29.png";
    }
    print(link_firma);
    return Scaffold(
      drawer:
          NavigationDrawerWidget(widget.info_user, widget._global_cliente_name),
      appBar: AppBar(
        backgroundColor: Color(0xff212F3D),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.radio_button_checked,
              color: Colors.greenAccent,
            ),
            SizedBox(width: 10.0),
            Text("Usuario")
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
          color: Color(0xff212F3D),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(children: [
                  const SizedBox(height: 20.0),
                  CircleAvatar(
                      radius: 75.0,
                      backgroundImage:
                          AssetImage(widget.info_user[0].u_img_logo)),
                  const SizedBox(height: 20.0),
                  Divider(color: Colors.white70),
                  buildDetailUser(context,
                      text: widget._global_cliente_name, icon: Icons.home_work),
                  buildDetailUser(context,
                      text: widget.info_user[0].u_role_name,
                      icon: Icons.fingerprint),
                  buildDetailUser(context,
                      text: widget.info_user[0].u_name +
                          " " +
                          widget.info_user[0].u_lastname,
                      icon: Icons.person_outline),
                  buildDetailUser(context,
                      text: widget.info_user[0].u_email,
                      icon: Icons.mail_outline),
                  buildDetailUser(context,
                      text: widget.info_user[0].u_telefono,
                      icon: Icons.stay_primary_portrait),
                  buildDetailUser(context,
                      text: widget.info_user[0].u_created, icon: Icons.today),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: [
                        Text(
                          "Firma",
                          style: TextStyle(color: Colors.white),
                        ),
                        Image.network(
                          link_firma,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        Text(
                          "Firma",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            ],
          )),
    );
  }

  Widget buildDetailUser(BuildContext context,
      {required String text, required IconData icon}) {
    final _color = Colors.white;
    return ListTile(
      selectedTileColor: Colors.white24,
      leading: Icon(icon, color: _color),
      title: Text(
        text,
        style: TextStyle(color: _color, fontSize: 16.0),
      ),
      onTap: () {},
    );
  }
}
