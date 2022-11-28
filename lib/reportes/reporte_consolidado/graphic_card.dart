import 'package:flutter/material.dart';

class GraphicCard extends StatelessWidget {
  final String title;
  final Widget widget;

  const GraphicCard({Key? key, required this.title, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 17.0),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 225, 245, 252),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: widget,
          ),
        ],
      ),
    );
  }
}
