import 'package:flutter/material.dart';
import 'package:mobilki_app/data/hive_database.dart';
import 'package:mobilki_app/database/boxes.dart';
import 'package:mobilki_app/note.dart';
import 'package:mobilki_app/newnotedialog.dart';

import 'database/player.dart';

late String playerName;

class notes extends StatefulWidget {
  String playerN;
  notes(this.playerN) {
    playerName = playerN;
  }
  @override
  State<StatefulWidget> createState() => _mainNotes();
}

//* Player from database */
late Player playerDB;
late int indexOfPlayer;

List<note> _items = [];

//* loading notes from db as lists and putting them as note object*/
List<note> loadNotes(Player player) {
  List<note> saveNotesFormatted = [];

  if (player.noteListTitle.isNotEmpty && player.noteListContent.isNotEmpty) {
    for (int i = 0; i < player.noteListTitle.length; i++) {
      note individualNote =
          note(player.noteListTitle[i], player.noteListContent[i]);
      saveNotesFormatted.add(individualNote);
    }
  }

  return saveNotesFormatted;
}

//* converting notes objects to List of strings for inputting to db (titles)*/
List<String> titleToList(List<note> items) {
  List<String> list = [];
  for (int i = 0; i < items.length; i++) {
    list.add(items[i].title);
  }
  return list;
}

//* converting notes objects to List of strings for inputting to db (content)*/
List<String> contentToList(List<note> items) {
  List<String> list = [];
  for (int i = 0; i < items.length; i++) {
    list.add(items[i].body);
  }
  return list;
}

void initializeNotes(String playerName) {
  if (boxPlayers.length != 0) {
    print(boxPlayers.length);
    for (int i = 0; i < boxPlayers.length; i++) {
      if (playerName == boxPlayers.keyAt(i)) {
        playerDB = boxPlayers.getAt(i);
        indexOfPlayer = i;
        _items = loadNotes(playerDB);
        print("player existing : ${playerDB.name}");
        print(_items.length);
        print(indexOfPlayer);
        return;
      }
    }
  }
  playerDB = Player();
  print("platyer aint existing : $playerName");
  playerDB.name = playerName;
  indexOfPlayer = boxPlayers.length + 1;
  boxPlayers.put(playerName, playerDB);
}

class _mainNotes extends State<notes> {
  @override
  void initState() {
    super.initState();
    initializeNotes(playerName);
  }

  late List<note> _data;

  Future<void> newNoteDialog() async {
    note newNote = note('', '');

    await goToNotePage(newNote);

    setState(() {
      // print("newNote");
      // print("${newNote.body}");
      _items.insert(0, newNote);
      // playerDB.noteList.clear;
      playerDB.noteListTitle = titleToList(_items);
      playerDB.noteListContent = contentToList(_items);
      boxPlayers.putAt(indexOfPlayer, playerDB);
      print("saved");
      print(playerDB.noteListContent.length);
      print(indexOfPlayer);
    });
  }

  Future<void> goToNotePage(note note) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => newnotedialog(
                  newNote: note,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, minimumSize: Size(110, 45)),
              child: const Text('NEW NOTE'),
              onPressed: () {
                setState(() {
                  newNoteDialog();
                });
              },
            ),
          ),
        ),
        Container(child: Steps()),
      ]),
    );
  }
}

Future<List<note>> getSteps() async {
  return Future<List<note>>.delayed(
      const Duration(milliseconds: 1), () => _items);
}

class Steps extends StatelessWidget {
  const Steps({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: FutureBuilder<List<note>>(
            future: getSteps(),
            builder:
                (BuildContext context, AsyncSnapshot<List<note>> snapshot) {
              if (snapshot.hasData) {
                return StepList(steps: snapshot.data ?? []);
              } else {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );
  }
}

class StepList extends StatefulWidget {
  final List<note> steps;
  const StepList({Key? key, required this.steps}) : super(key: key);
  @override
  State<StepList> createState() => _StepListState(steps: steps);
}

class _StepListState extends State<StepList> {
  void deleteNote(note note) {
    setState(() {
      _items.remove(note);
      // playerDB.noteList.clear;
      playerDB.noteListTitle = titleToList(_items);
      playerDB.noteListContent = contentToList(_items);
      boxPlayers.putAt(indexOfPlayer, playerDB);
      print(playerDB.noteListContent.length);
      print(indexOfPlayer);
    });
  }

  Future<void> editNote(note note) async {
    _items.remove(note);
    await goToNotePage(note);

    setState(() {
      print("object");
      _items.insert(0, note);
      // playerDB.noteList.clear;
      playerDB.noteListTitle = titleToList(_items);
      playerDB.noteListContent = contentToList(_items);
      boxPlayers.putAt(indexOfPlayer, playerDB);
      print(playerDB.noteListContent.length);
      print(indexOfPlayer);
    });
  }

  Future<void> goToNotePage(note note) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => newnotedialog(
                  newNote: note,
                )));
  }

  final List<note> _steps;
  _StepListState({required List<note> steps}) : _steps = steps;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _steps[index].isExpanded = !isExpanded;
        });
      },
      children: _steps.map<ExpansionPanel>((note step) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                title: Row(
              children: [
                Expanded(
                    child: Text(step.title, style: TextStyle(fontSize: 16))),
                TextButton(
                  onPressed: () => {editNote(step)},
                  child: Icon(
                    Icons.edit,
                    size: 25,
                  ),
                ),
                TextButton(
                  onPressed: () => {deleteNote(step)},
                  child: Icon(
                    Icons.delete,
                    size: 25,
                  ),
                )
              ],
            ));
          },
          body: ListTile(
            title: Text(step.body),
            //trailing: ,
          ),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }
}
