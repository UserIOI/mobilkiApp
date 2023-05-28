import 'package:flutter/material.dart';
import 'package:mobilki_app/note.dart';
import 'package:mobilki_app/newnotedialog.dart';

class notes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _mainNotes();
}

var _items = [
  note('Step 0: Install Flutter',
      'Install Flutter development tools according to the official documentation.'),
  note('note 1: Create a project',
      'Open your terminal, run `flutter create <project_name>` to create a new project.'),
  note('note 2: Run the app',
      'Change your terminal directory to the project directory, enter `flutter run`.'),
];

class _mainNotes extends State<notes> {
  late List<note> _data;

  void newNoteDialog() {
    setState(() {
      _items.insert(
          0,
          note('Idk ale dodaje messege ${_items.length}',
              'bla bla bla bla bla bla bla'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 20),
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
      const Duration(milliseconds: 50), () => _items);
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
    });
  }

  void editNote(note note) {}

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
