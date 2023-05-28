import 'package:flutter/material.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:mobilki_app/dices.dart';
import 'dices.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  double dragStartPosition = 0, dragEndPosition = 0, navBarHeight = 70;
  double deviceWidth = 0, deviceHeight = 0;
  final screens = [
    const Center(child: Text('Main', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Skills', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Equipment', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Notes', style: TextStyle(fontSize: 72))),
  ];
  @override
  Widget build(BuildContext context) => GestureDetector(
        onVerticalDragStart: (DragStartDetails details) => {
          deviceHeight = MediaQuery.of(context).size.height.toDouble(),
          deviceWidth = MediaQuery.of(context).size.width.toDouble(),
          dragStartPosition = details.globalPosition.dy.toDouble(),
        },
        onVerticalDragUpdate: (DragUpdateDetails details) => {
          dragEndPosition = details.globalPosition.dy,
        },
        onVerticalDragEnd: (DragEndDetails details) => {
          // print("start position "),
          // print(dragStartPosition),
          // print("end position "),
          // print(dragEndPosition),
          if (dragStartPosition > deviceHeight - navBarHeight &&
              dragStartPosition - dragEndPosition > 0.3 * deviceHeight)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => dices()),
              ),
            }
        },
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Scaffold(
            body: screens[index],
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: Color.fromARGB(185, 0, 153, 255),
                labelTextStyle: MaterialStateProperty.all(const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal)),
              ),
              child: NavigationBar(
                animationDuration: const Duration(seconds: 1),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                height: 70,
                backgroundColor: Color.fromARGB(255, 227, 171, 0),
                selectedIndex: index,
                onDestinationSelected: (index) =>
                    setState(() => this.index = index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.person, size: 30),
                    label: 'Main',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings, size: 30),
                    label: 'Skills',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.backpack_outlined, size: 30),
                    label: 'Equipment',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.note_add_sharp, size: 30),
                    label: 'Notes',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
