import 'package:flutter/material.dart';

class RecordInspectionDetail extends StatefulWidget {
  const RecordInspectionDetail({Key? key, required this.title})
      : super(key: key);

  final String title;
  static const listHeader = [
    'Pos 1',
    'Duales mal hermanados',
    'Observaciones',
    'Pos 4',
    'Pos 5',
    'Pos 6',
  ];

  @override
  State<RecordInspectionDetail> createState() => _RecordInspectionDetailState();
}

class _RecordInspectionDetailState extends State<RecordInspectionDetail> {
  var position = 0;
  var topHeader;
  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;
  bool checkbox4 = false;
  bool checkbox5 = false;
  bool checkbox6 = false;
  bool checkbox7 = false;
  bool checkbox8 = false;
  bool checkbox9 = false;

  Widget? applyWidget() {
    switch (position) {
      case 0:
        setState(() {
          topHeader = RecordInspectionDetail.listHeader[0];
        });
        // return widget if user click over pakistan in tab bar
        return form1();
      case 1:
        setState(() {
          topHeader = RecordInspectionDetail.listHeader[1];
        });
        return form2();
      //return list();
      case 2:
        setState(() {
          topHeader = RecordInspectionDetail.listHeader[2];
        });
        return form3();

      case 3:
        setState(() {
          topHeader = RecordInspectionDetail.listHeader[3];
        });
        return form4();
      // return Container(
      //   color: Colors.blue,
      //   child: Center(
      //     child: Text(topHeader),
      //   ),
      // );

      default:
        return Container(
          color: Colors.purple,
          child: Center(
            child: Text(topHeader),
          ),
        );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initial header name when activity start first time
    topHeader = RecordInspectionDetail.listHeader[0];
  }

  @override
  Widget build(BuildContext context) {
    topHeader = topHeader;

    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: AppBar(
        title: Text('AppBar'),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          ///header
          Container(
            alignment: Alignment.center,
            color: Colors.blueGrey,
            height: 90,
            child: Text(RecordInspectionDetail.listHeader[position]),
          ),

          /// tabBar
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: RecordInspectionDetail.listHeader.length,
                itemBuilder: (con, index) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      position = index;
                      topHeader = RecordInspectionDetail.listHeader[index];
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10),
                      child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          color: topHeader ==
                                  RecordInspectionDetail.listHeader[index]
                              ? Colors.black26
                              : Colors.transparent,
                          child:
                              Text(RecordInspectionDetail.listHeader[index])),
                    ),
                  );
                }),
          ),

          ///Widget
          Expanded(
            child: GestureDetector(
                onHorizontalDragEnd: (start) {
                  print('start : ${start.velocity.pixelsPerSecond.dx}');
                  if ((start.velocity.pixelsPerSecond.dx) < -700) {
                    if (position <
                            RecordInspectionDetail.listHeader.length - 1 &&
                        position >= 0)
                      setState(() {
                        position = position + 1;
                      });
                  } else {}

                  if ((start.velocity.pixelsPerSecond.dx) > 900) {
                    if (position <=
                            RecordInspectionDetail.listHeader.length - 1 &&
                        position > 0)
                      setState(() {
                        position = position - 1;
                      });
                  }
                  print(position);
                },
                child: applyWidget()),
          ),
        ],
      ),
    );
  }

  list() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          children: [
            for (var color in Colors.primaries)
              Container(color: color, height: 100.0)
          ],
        ),
      ),
    );
  }

  grid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 100.0);
      }).toList(),
    );
  }

  form1() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder(
            verticalInside: BorderSide(
                width: 1, color: Colors.blue, style: BorderStyle.solid)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                Text('Serie neumático'),
                Text('1096R4'),
              ]),
          TableRow(children: [
            Text('Marca'),
            Text('Yokohama'),
          ]),
          TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                Text('Modelo'),
                Text('Y33'),
              ]),
          TableRow(children: [
            Text('Diseño'),
            Text('Yasds'),
          ]),
          TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              children: [
                Text('Profundidad derecha'),
                TextFormField(
                  keyboardType: TextInputType.number,
                ),
              ]),
          TableRow(children: [
            Text('Profundidad izquierdo'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
          TableRow(children: [
            Text('Profundidad media'),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'mm'),
            ),
          ]),
          TableRow(children: [
            Text('Duales mal hermanados'),
            Column(
              children: [
                CheckboxListTile(
                  title: Text("Diseño"),
                  value: false,
                  onChanged: (newValue) {
                    setState(() {
                      // checkedValue = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
          ]),
          TableRow(children: [
            Text('Duales mal hermanados'),
            Column(
              children: [
                CheckboxListTile(
                  title: Text("Diseño"),
                  value: checkbox1,
                  onChanged: (newValue) {
                    setState(() {
                      checkbox1 = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: Text("Tamaño"),
                  value: checkbox1,
                  onChanged: (newValue) {
                    setState(() {
                      checkbox1 = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: Text("Tipo de construcción"),
                  value: checkbox1,
                  onChanged: (newValue) {
                    setState(() {
                      checkbox1 = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
              ],
            ),
          ])
        ],
      ),
    );
  }

  form2() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder(
            verticalInside: BorderSide(
                width: 1, color: Colors.blue, style: BorderStyle.solid)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Text('Posicion'),
            Text('Diseño'),
            Text('Tamaño'),
            Text('Tipo construcción'),
            Text('Medidad de neumático'),
          ]),
          TableRow(children: [
            Text('1'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('2'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('3'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('4'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('5'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('6'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
        ],
      ),
    );
  }

  form3() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder(
            verticalInside: BorderSide(
                width: 1, color: Colors.blue, style: BorderStyle.solid)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Text('Posicion'),
            Text('Des. Irregular'),
            Text('Para Reparar'),
            Text('Aro Defectuoso'),
            Text('Fallas en el flanco'),
          ]),
          TableRow(children: [
            Text('1'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('2'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('3'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('4'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('5'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
          TableRow(children: [
            Text('6'),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            CheckboxListTile(
              value: false,
              onChanged: (newValue) {
                setState(() {
                  // checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ]),
        ],
      ),
    );
  }

  form4() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder.symmetric(
            inside: BorderSide(width: 1, color: Colors.green),
            outside: BorderSide(width: 1)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Text('Posicion'),
            Text('Rem izq.'),
            Text('Rem der.'),
            Text('Rem cent.'),
            Text('Presion'),
          ]),
          TableRow(children: [
            Text('1'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
          TableRow(children: [
            Text('2'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
          TableRow(children: [
            Text('3'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
          TableRow(children: [
            Text('4'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
          TableRow(children: [
            Text('5'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
          TableRow(children: [
            Text('6'),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
            ),
          ]),
        ],
      ),
    );
  }
}
