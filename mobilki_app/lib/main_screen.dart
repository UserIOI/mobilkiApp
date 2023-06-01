import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki_app/database/boxes.dart';
import 'package:mobilki_app/database/player.dart';

late String playerName;

class Main extends StatefulWidget {
  String playerNAME;
  Main(this.playerNAME, {super.key}) {
    playerName = playerNAME;
  }

  @override
  State<Main> createState() => _MainState();
}

late Player player;

String? investigatorImagePath;

late Map<String, String?> investigatorAboutData;

List<String> characteristic = [
  "STR",
  "CON",
  "DEX",
  "INT",
  "SIZ",
  "POW",
  "APP",
  "EDU",
];

late List<int> characteristicLevel;

//* if player exists - loads all data of player,
//* otherwise creates new player and assigns default values
void loadPlayerData(String playerName) {
  if (boxPlayers.isEmpty) {
    print("box's empty :(");
    return;
  }

  print("BoxPlayer length : ${boxPlayers.length}");

  if (hasPlayer(playerName)) {
    player = boxPlayers.get(playerName);
    investigatorImagePath = player.investigatorImagePath;
    investigatorAboutData = player.investigatorAboutData;
    characteristicLevel = player.characteristicLevel;
    print("Player ${player.name} loaded");
    return;
  }

  print("No player data present");
  player = Player();
  player.name = playerName;
  boxPlayers.put(playerName, player);
  print("Player $playerName has been created");
  investigatorImagePath = player.investigatorImagePath;
  investigatorAboutData = player.investigatorAboutData;
  characteristicLevel = player.characteristicLevel;
}

//* saves investigatorAboutData to DB
void saveInvestigatorAboutData() {
  if (!hasPlayer(playerName)) {
    return;
  }
  player = boxPlayers.get(playerName);
  player.investigatorAboutData = investigatorAboutData;
  boxPlayers.put(playerName, player);
  print("Saved investigatorAboutData to DB - player: $playerName");
}

//* saves characteristic level to DB
void saveCharacteristicLevel() {
  if (!hasPlayer(playerName)) {
    return;
  }
  player = boxPlayers.get(playerName);
  player.characteristicLevel = characteristicLevel;
  boxPlayers.put(playerName, player);
  print("Saved characteristicLevel to DB - player: $playerName");
}

//* saves investigator's image path do DB
void saveInvestigatorImagePath() {
  if (!hasPlayer(playerName)) {
    return;
  }
  player = boxPlayers.get(playerName);
  player.investigatorImagePath = investigatorImagePath;
  boxPlayers.put(playerName, player);
  print("Saved picture path do DB - player: $playerName");
}

bool hasPlayer(String playerName) {
  if (!boxPlayers.containsKey(playerName)) {
    print("Unable to retrive player: $playerName");
    return false;
  }
  return true;
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    loadPlayerData(playerName);
  }

  //* sets path for investigator's image
  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) {
        return;
      }

      investigatorImagePath = image.path;
    } on PlatformException catch (e) {
      print("Can not pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //handles dialog  pop up
    final controller = TextEditingController();
    Future<String?> openDialog(String title) => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: (_) => Navigator.of(context).pop(controller.text),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.text = ""; //clear textfield xd but works
                  Navigator.of(context).pop(null);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: const Text("Confirm")),
            ],
          ),
        );

    Future profilePictureSelectionDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Select investigator's picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    await pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  backgroundColor: const Color.fromARGB(255, 134, 88, 46),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: const Icon(Icons.photo_size_select_actual_rounded),
                ),
                const Divider(
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    await pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  backgroundColor: const  Color.fromARGB(255, 134, 88, 46),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.text = ""; //clear textfield xd but works
                  Navigator.of(context).pop(null);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Card(
            margin: const EdgeInsets.all(20),
            color: const Color.fromARGB(255, 225, 216, 190),
            child: Column(
              children: [
                const FittedBox(
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(30),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Investigator Data',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await profilePictureSelectionDialog();
                              setState(() {
                                if (investigatorImagePath != null) {
                                  saveInvestigatorImagePath();
                                }
                              });
                            },
                            child: player.investigatorImagePath != null
                                ? Image.file(
                                    File(player.investigatorImagePath!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.photo_camera_front_outlined,
                                      size: 100,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                    label: "Name", data: player.name
                                    //investigatorAboutData["Name"]
                                    ),
                                // onTap: () async {
                                //   final data = await openDialog("Name");
                                //   setState(() {
                                //     if (data != null) {
                                //       investigatorAboutData["Name"] = data;
                                //       saveInvestigatorAboutData();
                                //     }
                                //   });
                                // },
                              ),
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                  label: "Occupation",
                                  data: investigatorAboutData["Occupation"],
                                ),
                                onTap: () async {
                                  final data = await openDialog("Occupation");
                                  setState(() {
                                    if (data != null) {
                                      investigatorAboutData["Occupation"] =
                                          data;
                                      saveInvestigatorAboutData();
                                    }
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
                                    if (data != null) {
                                      investigatorAboutData["Age"] = data;
                                      saveInvestigatorAboutData();
                                    }
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
                                    if (data != null) {
                                      investigatorAboutData["Residence"] = data;
                                      saveInvestigatorAboutData();
                                    }
                                  });
                                },
                              ),
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                  label: "Place of birth",
                                  data: investigatorAboutData["PlaceOfBirth"],
                                ),
                                onTap: () async {
                                  final data =
                                      await openDialog("Place of birth");
                                  setState(() {
                                    if (data != null) {
                                      investigatorAboutData["PlaceOfBirth"] =
                                          data;
                                      saveInvestigatorAboutData();
                                    }
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
                const FittedBox(
                  child: Card(
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    elevation: 5,
                    child: Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Text(
                        "Characteristics",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 50,
                      left: 50,
                    ),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 5 / 3,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: characteristic.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 11, bottom: 11),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 235, 162, 28)),
                          child: ListTile(
                            title: Text(
                              characteristic[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                              characteristicLevel[index].toString(),
                              style: const TextStyle(fontSize: 24),
                            ),
                            onTap: () async {
                              final data =
                                  await openDialog(characteristic[index]);
                              final dataInt = int.tryParse(data.toString());
                              if (data != null &&
                                  dataInt != null &&
                                  dataInt <= 100 &&
                                  dataInt >= 0) {
                                setState(() {
                                  characteristicLevel[index] =
                                      int.parse(data.toString());
                                  saveCharacteristicLevel();
                                });
                              } else {
                                controller.text = "";
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
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
      margin: const EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        '$label: $data',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
