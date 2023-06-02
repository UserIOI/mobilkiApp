import 'package:flutter/material.dart';
import 'package:mobilki_app/note.dart';
import 'package:flutter/src/widgets/text.dart' as tt;

class newnotedialog extends StatefulWidget {
  note newNote;

  newnotedialog({super.key, required this.newNote});

  @override
  State<StatefulWidget> createState() => _newnotedialog(newNote);
}

// ignore: camel_case_types
class _newnotedialog extends State<newnotedialog> {
  note newNote;
  final titleData = TextEditingController();
  final contentData = TextEditingController();

  _newnotedialog(this.newNote) {
    titleData.text = newNote.title;
    contentData.text = newNote.body;
  }

  void saveNote() {
    newNote.title = titleData.text;
    newNote.body = contentData.text;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleData.dispose();
    contentData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Flexible(
        child: Scaffold(
          appBar: AppBar(
            title: tt.Text("Note"),
          ),
          body: Column(children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: titleData,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: contentData,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Content',
                ),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, minimumSize: Size(100, 45)),
                onPressed: () => {saveNote()},
                child: const tt.Text("SAVE")),
          ]),
        ),
      );
}
