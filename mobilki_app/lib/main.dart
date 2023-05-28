import 'package:flutter/material.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:mobilki_app/notes.dart';
//import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  final screens = [
    //Main()
    //Skills()
    const Center(child: Text('Main', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Skills', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Equipment', style: TextStyle(fontSize: 72))),
    notes(),
  ];
  @override
  Widget build(BuildContext context) => GestureDetector(
        //onHorizontalDragStart: _onHorizontalDragStartHandler,
        //onVerticalDragStart: _onVerticalDragStartHandler,
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
                // NavigationDestination(
                //   icon: Icon(DiceIcons.dice5, size: 30),
                //   label: 'Dices',
                // ),
              ],
            ),
          ),
        ),
      );
}

void _onVerticalDragStartHandler() {
  print("aaaaa");
}

void _onHorizontalDragStartHandler() {
  print("bbbbbb");
}

// class MyApp1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Model Viewer")),
//         body: Image(),
//       ),
//     );
//   }
// }
