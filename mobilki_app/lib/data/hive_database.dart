import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../note.dart';

class HiveDatabase {
  int index;
  HiveDatabase(this.index);
  final _myBox = Hive.box('player1');
  List<note> loadNotes() {
    List<note> saveNotesFormatted = [];

    if (_myBox.get("ALL_NOTES") != null) {
      List<dynamic> savedNotes = _myBox.get("ALL_NOTES");
      for (int i = 0; i < savedNotes.length; i++) {
        note individualNote = note(savedNotes[i][0], savedNotes[i][1]);
        saveNotesFormatted.add(individualNote);
      }
    }

    return saveNotesFormatted;
  }

  void saveNotes(List<note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [];

    for (var note in allNotes) {
      String title = note.title;
      String content = note.body;

      allNotesFormatted.add([title, content]);
    }
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}
