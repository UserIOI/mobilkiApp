import 'package:flutter/material.dart';

List<int> numbers = [4, 6, 8, 10, 12, 20, 100];

class dices extends StatefulWidget {
  @override
  State<dices> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<dices> {
  double dragStartPosition = 0, dragEndPosition = 0, navBarHeight = 70;
  double deviceWidth = 0, deviceHeight = 0;
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
              const Center(
                child: Text('Wynik', style: TextStyle(fontSize: 40)),
              ),
              Container(
                color: Colors.amber,
                height: 300.0,
                width: 300.0,
                //** Jakos rozwiazac te dodawanie kostek do rzutu
                //** Jakies img kostek albo cos i onClick +1 kostka pod kostami jakis counter ile ich jest, podstawowe beda ze 1xD100 i 1xD10 */
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //** Rozmiar buttonów oraz wyrzej dać widgety */
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CLEAR'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
