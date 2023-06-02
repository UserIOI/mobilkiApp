import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobilki_app/database/player.dart';
import 'package:mobilki_app/character_sheet.dart';
import 'database/boxes.dart';
import 'package:fluttertoast/fluttertoast.dart';


//* to delete investigator click and hold his/her card

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(PlayerAdapter());
  boxPlayers = await Hive.openBox<Player>('play');

  runApp(
    //* materialApp, so that Navigator has required context
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

List<dynamic> players = [];

int counter = 0;

//* gets keys of players present in DB and stores in List
void getPlayersFromDB() {
  players = boxPlayers.keys.toList();
  print("Players: $players");
}

void createPlayer(String playerName) {
  Player player = Player();
  player.name = playerName;
  boxPlayers.put(playerName, player);
  print("Player: $playerName has been created");
  updatePlayersList();
  print("Players: $players");
}

void updatePlayersList() {
  players = boxPlayers.keys.toList();
  counter = players.length;
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getPlayersFromDB();
    counter = players.length;
    super.initState();
  }

  //* for callback
  void deletePlayer(String playerName) {
    setState(() {
      boxPlayers.delete(playerName);
      print("Player: $playerName has been deleted");
      updatePlayersList();
      print("Players: $players");
    });
  }

  //* pop up dialog for creating new investigator
  final controller = TextEditingController();
  Future addInvestigatorDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Enter Name of the new Investigator",
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.text = "";
              },
              child: const Text("Cancel",
                  style: TextStyle(
                    color: Color.fromARGB(255, 208, 30, 17),
                  )),
            ),
            TextButton(
                onPressed: () {
                  String playerName = controller.text;
                  if (playerName == "") {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg:
                          "Hey - You must provide a name for your Investigator",
                      toastLength:
                          Toast.LENGTH_SHORT, // Duration of the toast message
                      gravity: ToastGravity
                          .CENTER, // Position of the toast message on the screen
                      backgroundColor: const Color.fromARGB(255, 56, 56,
                          56), // Background color of the toast message
                      textColor:
                          Colors.white, // Text color of the toast message
                    );

                    return;
                  }

                  if (boxPlayers.containsKey(playerName)) {
                    Fluttertoast.showToast(
                      msg: "Investigator $playerName already exists!",
                      toastLength:
                          Toast.LENGTH_SHORT, // Duration of the toast message
                      gravity: ToastGravity
                          .BOTTOM, // Position of the toast message on the screen
                      backgroundColor: const  Color.fromARGB(255, 56, 56,
                          56), // Background color of the toast message
                      textColor:
                          Colors.white, // Text color of the toast message
                    );
                    Navigator.of(context).pop();
                    controller.text = "";
                    return;
                  }

                  print(playerName);
                  setState(() {
                    createPlayer(playerName);
                  });
                  Navigator.of(context).pop();
                  controller.text = "";
                  Fluttertoast.showToast(
                    msg: "Investigator $playerName created!",
                    toastLength:
                        Toast.LENGTH_SHORT, // Duration of the toast message
                    gravity: ToastGravity
                        .BOTTOM, // Position of the toast message on the screen
                    backgroundColor: const Color.fromARGB(255, 56, 56,
                        56), // Background color of the toast message
                    textColor: Colors.white, // Text color of the toast message
                  );
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Color.fromARGB(255, 28, 169, 32)),
                )),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await addInvestigatorDialog();
            print("Clicked");
            print("listLength = $counter");
          },
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            children: [
              const Header(),
              InvestigatorsCards(onDeletePlayer: deletePlayer),
            ],
          ),
        ),
      ),
    );
  }
}

class InvestigatorsCards extends StatelessWidget {
  final Function(String) onDeletePlayer;
  const InvestigatorsCards({
    required this.onDeletePlayer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: players.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return InvestigatorCard(
              investigatorName: players[index],
              onDelete: () => onDeletePlayer(players[index]),
            );
          },
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 30, bottom: 20),
      child: Text(
        "Your Investigators",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class InvestigatorCard extends StatefulWidget {
  final String investigatorName;
  final VoidCallback onDelete;
  const InvestigatorCard({
    required this.investigatorName,
    required this.onDelete,
    super.key,
  });

  @override
  State<InvestigatorCard> createState() => _InvestigatorCardState();
}

class _InvestigatorCardState extends State<InvestigatorCard> {
  Future deleteInvestigatorDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Are you sure you want to delete this Investigator and all of its data?",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  widget.onDelete();
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Investigator ${widget.investigatorName} deleted!",
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: const Color.fromARGB(255, 56, 56,
                        56), // Background color of the toast message
                    textColor: Colors.white,
                  );
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Color.fromARGB(255, 28, 169, 32)),
                )),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Color.fromARGB(255, 208, 30, 17),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterSheet(widget.investigatorName),
          ),
        );
      },
      onLongPress: () {
        deleteInvestigatorDialog();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.amber,
        child: Center(
          child: Text(
            "${widget.investigatorName}",
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
