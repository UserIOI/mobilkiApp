import 'package:mobilki_app/call_of_cthulhu/character_sheet/equipment/equipment_view.dart';

import 'main_screen.dart';
import 'package:flutter/material.dart';
import 'package:dice_icons/dice_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobilki_app/notes.dart';
import 'package:mobilki_app/dices.dart';
import 'dices.dart';

import 'database/boxes.dart';
import 'database/player.dart';
//import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/skills_view.dart';

//* Tutaj przy wyborze postaci bedzie trzeba update zrobic na nazwie aby ja wrzucic do notes i aby wziac danego gracza notatki*/
final String playerName = 'Abrakadabra';
void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(PlayerAdapter());
  print("aa");
  boxPlayers = await Hive.openBox<Player>('play1');
  print("bb");
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  double dragStartPosition = 0, dragEndPosition = 0, navBarHeight = 70;
  double deviceWidth = 0, deviceHeight = 0;
  final screens = [
    Main(playerName),
    SkillsView(playerName: playerName),
    EquipmentView(playerName: playerName),
    notes(playerName),
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
      );
}
