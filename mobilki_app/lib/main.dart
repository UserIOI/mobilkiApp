import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dice_icons/dice_icons.dart';
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
    const Main(),
    //Skills()
    const Center(child: Text('Skills', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Equipment', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Notes', style: TextStyle(fontSize: 72))),
    const Center(child: Text('Dices', style: TextStyle(fontSize: 72)))
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

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Map<String, String?> investigatorAboutData = {
    "Name": "",
    "Occupation": "",
    "Age": "",
    "Residence": "",
    "PlaceOfBirth": "",
  };

  @override
  Widget build(BuildContext context) {
    Future<String?> openDialog(String title) => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              autofocus: true,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    //aboutData[title] =
                    Navigator.of(context).pop(controller.text);
                    
                  },
                  child: Text("Confirm"))
            ],
          ),
        );

    return MaterialApp(
      home: Card(
        margin: EdgeInsets.all(20),
        color: Color.fromARGB(255, 225, 216, 190),
        child: Column(
          children: [
            FittedBox(
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(30),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Investigator Data',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            FittedBox(
              child: Card(
                elevation: 5,
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Placeholder(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: InvestigatorAboutInfo(
                                label: "Name",
                                data: investigatorAboutData["Name"]),
                            onTap: () async {
                              final data = await openDialog("Name");
                              setState(() {
                                investigatorAboutData["Name"] = data;
                              });
                            },
                          ),
                          GestureDetector(
                            child: InvestigatorAboutInfo(
                              label: "Occupation",
                              data: investigatorAboutData["Occupation"],
                            ),
                            onTap: () async {
                              final data = await openDialog("Occupation");
                              setState(() {
                                investigatorAboutData["Occupation"] = data;
                              });
                            },
                          ),
                          GestureDetector(
                            child: InvestigatorAboutInfo(
                                label: "Age",
                                data: investigatorAboutData["Age"]),
                            onTap: () async {
                              final data = await openDialog("Age");
                              setState(() {
                                investigatorAboutData["Age"] = data;
                              });
                            },
                          ),
                          GestureDetector(
                            child: InvestigatorAboutInfo(
                              label: "Residence",
                              data: investigatorAboutData["Residence"],
                            ),
                            onTap: () async {
                              final data = await openDialog("Residence");
                              setState(() {
                                investigatorAboutData["Residence"] = data;
                              });
                            },
                          ),
                          GestureDetector(
                            child: InvestigatorAboutInfo(
                              label: "Place of birth",
                              data: investigatorAboutData["Place of birth"],
                            ),
                            onTap: () async {
                              final data = await openDialog("Place of birth");
                              setState(() {
                                investigatorAboutData["Place of birth"] = data;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FittedBox(
              child: Card(
                margin: EdgeInsets.only(top: 13, bottom: 13),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Characteristics",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Flexible(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 50,
                  right: 50,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    color: Color.fromARGB(255, 211, 150, 52),
                    height: 30,
                    width: 120,
                    child: Center(
                      child: ListTile(leading: Icon(Icons.abc)),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class InvestigatorAboutInfo extends StatelessWidget {
  final String label;
  final String? data;
  const InvestigatorAboutInfo({
    required this.label,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      margin: EdgeInsets.only(
        top: 3,
      ),
      child: Text('$label: $data'),
    );
  }
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
