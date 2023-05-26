import 'dart:io';
import 'dart:math';

import 'package:flutter/gestures.dart';
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
  late double deviceWidth = MediaQuery.of(context).size.width.toDouble(),
      deviceHeight = MediaQuery.of(context).size.height.toDouble();
  bool clearing = false;
  int d4 = 0, d6 = 0, d8 = 0, d10 = 1, d12 = 0, d20 = 0, d100 = 1, wynik = 0;
  List<dice> _columnChildren = [];
  List<List<double>> cordinates = [];

  Random random = Random();
  int i = 0, j = 0;

  bool checkCollision(List<double> obj1, List<double> obj2) {
    double x1 = obj1[0], y1 = obj1[1];
    double x2 = obj2[0], y2 = obj2[1];

    if ((x1 - x2).abs() < 70 && (y1 - y2).abs() < 70) {
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
    while (true) {
      i = random.nextInt((MediaQuery.of(context).size.width - 75).toInt());
      j = random
          .nextInt((MediaQuery.of(context).size.height * 0.6 - 75).toInt());
      cordinates.add([i.toDouble(), j.toDouble()]);
      if (!checkAllCollisions(cordinates)) {
        print("$i $j");
        break;
      } else {
        print("removed");
        cordinates.removeLast();
      }
    }
  }

  void throwDices() {
    i = 0;
    j = 0;
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
        x--;
      });
    }
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
              Container(
                height: MediaQuery.of(context).size.height * 0.68,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                        color: Color.fromARGB(255, 23, 23, 24), width: 3)),
                child: Stack(
                  children: _columnChildren,
                ),
              ),
              // Text(
              //   "$wynik",
              //   style: TextStyle(fontSize: deviceHeight * 0.04),
              // ),
              Container(
                color: Colors.amber,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
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
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(110, 45)),
                    onPressed: () {
                      setState(() {
                        clearDices();
                      });
                    },
                    child: const Text('CLEAR'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(110, 45)),
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
                      padding: const EdgeInsets.all(4),
                      child: widget,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
