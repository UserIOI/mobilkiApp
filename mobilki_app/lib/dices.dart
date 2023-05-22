import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobilki_app/dice.dart';

List<int> numbers = [4, 6, 8, 10, 12, 20, 100];

class dices extends StatefulWidget {
  @override
  State<dices> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<dices> {
  //GlobalKey<diceWidget> keyK = GlobalKey<diceWidget>();
  double dragStartPosition = 0, dragEndPosition = 0, navBarHeight = 70;
  double deviceWidth = 0, deviceHeight = 0;
  bool clearing = false;
  int d4 = 0, d6 = 0, d8 = 0, d10 = 1, d12 = 0, d20 = 0, d100 = 1, wynik = 0;
  List<dice> _columnChildren = [];
  List<List<double>> cordinates = [];
  String idk = 'd20/d20_1.png';

  String baseForAssets = 'assets/images/';

  //** Zmienne przechowujace obrazy kosci */
  var images4 = ['d4/d4_1.png', 'd4/d4_2.png', 'd4/d4_3.png', 'd4/d4_4.png'];
  var images6 = [
    'd6/d6_1.png',
    'd6/d6_2.png',
    'd6/d6_3.png',
    'd6/d6_4.png',
    'd6/d6_5.png',
    'd6/d6_6.png'
  ];
  var images8 = [
    'd8/d8_1.png',
    'd8/d8_2.png',
    'd8/d8_3.png',
    'd8/d8_4.png',
    'd8/d8_5.png',
    'd8/d8_5.png',
    'd8/d8_5.png',
    'd8/d8_5.png'
  ];
  var images10 = [
    'd10/d10_1.png',
    'd10/d10_2.png',
    'd10/d10_3.png',
    'd10/d10_4.png',
    'd10/d10_5.png',
    'd10/d10_6.png',
    'd10/d10_7.png',
    'd10/d10_8.png',
    'd10/d10_9.png',
    'd10/d10_10.png'
  ];
  var images12 = [
    'd12/d12_1.png',
    'd12/d12_2.png',
    'd12/d12_3.png',
    'd12/d12_4.png',
    'd12/d12_5.png',
    'd12/d12_6.png',
    'd12/d12_7.png',
    'd12/d12_8.png',
    'd12/d12_9.png',
    'd12/d12_10.png',
    'd12/d12_11.png',
    'd12/d12_12.png'
  ];
  var images20 = [
    'd20/d20_1.png',
    'd20/d20_2.png',
    'd20/d20_3.png',
    'd20/d20_4.png',
    'd20/d20_5.png',
    'd20/d20_6.png',
    'd20/d20_7.png',
    'd20/d20_8.png',
    'd20/d20_9.png',
    'd20/d20_10.png',
    'd20/d20_11.png',
    'd20/d20_12.png',
    'd20/d20_13.png',
    'd20/d20_14.png',
    'd20/d20_15.png',
    'd20/d20_16.png',
    'd20/d20_17.png',
    'd20/d20_18.png',
    'd20/d20_19.png',
    'd20/d20_20.png'
  ];
  var images100 = [
    'd100/d100_00.png',
    'd100/d100_10.png',
    'd100/d100_20.png',
    'd100/d100_30.png',
    'd100/d100_40.png',
    'd100/d100_50.png',
    'd100/d100_60.png',
    'd100/d100_70.png',
    'd100/d100_80.png',
    'd100/d100_90.png',
  ];
  Random random = Random();
  late int i = random.nextInt(500) - 70, j = random.nextInt(500) - 70;
  //** Mapa do przechowywania setow obrazow w zaleznosci od kosci */
  late Map imgSelector = {
    4: images4,
    6: images6,
    8: images8,
    10: images10,
    12: images12,
    20: images20,
    100: images100,
  };

  roll() {
    for (var x in _columnChildren) {
      x.getKey();
    }
  }

  bool checkCollision(List<double> obj1, List<double> obj2) {
    double x1 = obj1[0], y1 = obj1[1];
    double x2 = obj2[0], y2 = obj2[1];
    double obj1Right = x1 + 80;
    double obj1Bottom = y1 + 80;
    double obj2Right = x2 + 80;
    double obj2Bottom = y2 + 80;

    if (obj1Right >= x2 &&
        x1 <= obj2Right &&
        obj1Bottom >= y2 &&
        y1 <= obj2Bottom) {
      return true; // Collision detected
    } else {
      return false; // No collision
    }
  }

  bool checkAllCollisions(List<List<double>> objects) {
    for (int i = 0; i < objects.length; i++) {
      for (int j = i + 1; j < objects.length; j++) {
        if (checkCollision(objects[i], objects[j])) {
          return true; // Collision detected
        }
      }
    }
    return false; // No collision
  }

  void findCords() {
    Random random = Random();
    int it = 15;
    while (i > 0) {
      i = random.nextInt(500) - 70;
      j = random.nextInt(500) - 70;
      cordinates.add([i.toDouble(), j.toDouble()]);
      if (!checkAllCollisions(cordinates)) {
        print("$i $j");
        break;
      } else {
        cordinates.remove([i, j]);
      }
    }
  }

  void throwDices() {
    Random random = Random();
    setState(() {
      _columnChildren.clear();
    });
    cordinates.clear();
    wynik = d4 + d6 + d8 + d10 + d12 + d20 + d100;
    int x = d4;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 4,
          x: i,
          y: j,
        ));
        x--;
      });
    }
    x = d6;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 6,
          x: i,
          y: j,
        ));
        i += 100;
        j += 100;
        x--;
      });
    }
    x = d8;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 8,
          x: i,
          y: j,
        ));
        i += 100;
        j += 100;
        x--;
      });
    }
    x = d10;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 10,
          x: i,
          y: j,
        ));
        i += 100;
        j += 100;
        x--;
      });
    }
    x = d12;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 12,
          x: i,
          y: j,
        ));
        i += 100;
        j += 100;
        x--;
      });
    }
    x = d20;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 20,
          x: i,
          y: j,
        ));
        i += 100;
        j += 100;
        x--;
      });
    }
    x = d100;
    while (x > 0) {
      findCords();
      setState(() {
        _columnChildren.add(dice(
          key: UniqueKey(),
          nrKosci: 100,
          x: i,
          y: j,
        ));
        i += 100;
        j += 100;
        x--;
      });
    }

    roll();

    i = 0;
    j = 0;
  }

  void clearDices() {
    d4 = 0;
    d6 = 0;
    d8 = 0;
    d10 = 0;
    d12 = 0;
    d20 = 0;
    d100 = 0;
    i = 0;
    j = 0;
    setState(() {
      _columnChildren.clear();
      wynik = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) => {
        deviceHeight = MediaQuery.of(context).size.height.toDouble(),
        deviceWidth = MediaQuery.of(context).size.width.toDouble(),
        dragStartPosition = details.globalPosition.dy.toDouble(),
      },
      onVerticalDragUpdate: (DragUpdateDetails details) => {
        dragEndPosition = details.globalPosition.dy,
      },
      onVerticalDragEnd: (DragEndDetails details) => {
        if (dragEndPosition - dragStartPosition > 0.2 * deviceHeight)
          {
            Navigator.pop(context),
          }
      },
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              //** To wywalic */
              Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                color: Colors.deepPurple,
                child: Stack(
                  children: _columnChildren,
                ),
              ),
              //** XXXXXXXXXXX */
              Center(
                  child: Text(
                "$wynik",
                style: TextStyle(fontSize: 40),
              )),
              Container(
                color: Colors.amber,
                height: 160.0,
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(children: [
                            Text("d4"),
                            ElevatedButton(
                              child: Text('$d4'),
                              onPressed: () {
                                setState(() {
                                  d4 = d4 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                        Container(
                          child: Column(children: [
                            Text("d6"),
                            ElevatedButton(
                              child: Text('$d6'),
                              onPressed: () {
                                setState(() {
                                  d6 = d6 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                        Container(
                          child: Column(children: [
                            Text("d8"),
                            ElevatedButton(
                              child: Text('$d8'),
                              onPressed: () {
                                setState(() {
                                  d8 = d8 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                        Container(
                          child: Column(children: [
                            Text("d10"),
                            ElevatedButton(
                              child: Text('$d10'),
                              onPressed: () {
                                setState(() {
                                  d10 = d10 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(children: [
                            Text("d12"),
                            ElevatedButton(
                              child: Text('$d12'),
                              onPressed: () {
                                setState(() {
                                  d12 = d12 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                        Container(
                          child: Column(children: [
                            Text("d20"),
                            ElevatedButton(
                              child: Text('$d20'),
                              onPressed: () {
                                setState(() {
                                  d20 = d20 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                        Container(
                          child: Column(children: [
                            Text("d100"),
                            ElevatedButton(
                              child: Text('$d100'),
                              onPressed: () {
                                setState(() {
                                  d100 = d100 + 1;
                                });
                              },
                            )
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
                //** Dodac unity ???
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //** Rozmiar buttonów oraz wyrzej dać widgety */
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        clearDices();
                      });
                    },
                    child: const Text('CLEAR'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        throwDices();
                      });
                    },
                    child: const Text('THROW'),
                  ),
                ],
              ),
            ]
                .map((widget) => Padding(
                      padding: const EdgeInsets.all(2),
                      child: widget,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
