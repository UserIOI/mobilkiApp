import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart';

List<int> numbers = [4, 6, 8, 10, 12, 20, 100];

class dices extends StatefulWidget {
  @override
  State<dices> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<dices> {
  double dragStartPosition = 0, dragEndPosition = 0, navBarHeight = 70;
  double deviceWidth = 0, deviceHeight = 0;
  bool clearing = false;
  int d4 = 0, d6 = 0, d8 = 0, d10 = 1, d12 = 0, d20 = 0, d100 = 1, wynik = 0;

  void throwDices() {
    //** Bla bla bla */
    wynik = d4 + d6 + d8 + d10 + d12 + d20 + d100;
  }

  void clearDices() {
    d4 = 0;
    d6 = 0;
    d8 = 0;
    d10 = 0;
    d12 = 0;
    d20 = 0;
    d100 = 0;
    throwDices();
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                      padding: const EdgeInsets.all(25),
                      child: widget,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
