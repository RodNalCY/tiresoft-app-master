import 'package:flutter/material.dart';
import 'package:tiresoft/login/models/user.dart';
import 'package:tiresoft/navigation/navigation_drawer_widget.dart';

class HeaderDrawerPage extends StatefulWidget {
  final List<User> info_user;
  const HeaderDrawerPage(this.info_user, {Key? key}) : super(key: key);

  @override
  State<HeaderDrawerPage> createState() => _HeaderDrawerPageState();
}

class _HeaderDrawerPageState extends State<HeaderDrawerPage> {
  final urlImage =
      "https://blogs.elespectador.com/wp-content/uploads/2018/11/John-Freddy-Vega-Cofundador-Platzi.jpg";

  @override
  Widget build(BuildContext context) {
    print(widget.info_user[0].u_firma);

    return Scaffold(
      drawer: NavigationDrawerWidget(widget.info_user),
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
                  const SizedBox(height: 50.0),
                  CircleAvatar(
                      radius: 90.0,
                      backgroundImage:
                          NetworkImage(widget.info_user[0].u_img_logo)),
                  const SizedBox(height: 24.0),
                  Divider(color: Colors.white70),
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
                  const SizedBox(height: 24.0),
                ]),
              )
            ],
          )),
    );
  }

  Widget buildDetailUser(BuildContext context,
      {required String text, required IconData icon}) {
    final _color = Colors.white;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        selectedTileColor: Colors.white24,
        leading: Icon(icon, color: _color),
        title: Text(
          text,
          style: TextStyle(color: _color, fontSize: 16.0),
        ),
        onTap: () {},
      ),
    );
  }
}
