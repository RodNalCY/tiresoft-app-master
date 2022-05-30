import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final String title;
  final Widget content;

  // ignore: use_key_in_widget_constructors
  const CustomCart(this.title, this.content);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 148, 22, 0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 246, 251, 253),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))),
                child: content),
          ],
        ));
  }
}
