import 'package:flutter/material.dart';
import 'package:mobilki_app/data/hive_database.dart';
import 'package:mobilki_app/note.dart';
import 'package:mobilki_app/newnotedialog.dart';

class notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _mainNotes();
}

final db = HiveDatabase();

List<note> _items = [];

void initializeNotes() {
  _items = db.loadNotes();
}

class _mainNotes extends State<notes> {
  @override
  void initState() {
    super.initState();
    initializeNotes();
    print(_items.length);
  }

  late List<note> _data;

  Future<void> newNoteDialog() async {
    note newNote = note('', '');

    await goToNotePage(newNote);

    setState(() {
      // print("newNote");
      // print("${newNote.body}");
      _items.insert(0, newNote);
      db.saveNotes(_items);
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
      db.saveNotes(_items);
    });
  }

  Future<void> editNote(note note) async {
    _items.remove(note);
    await goToNotePage(note);

    setState(() {
      print("object");
      _items.insert(0, note);
      db.saveNotes(_items);
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
