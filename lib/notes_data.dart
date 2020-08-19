import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  static final Data _data = Data._internal();
  factory Data.getInstance() => _data;
  Data._internal();

  List<Note> notes = new List();
  List<String> arrangement = new List();

  Future init() async {
    await _fetchNotes();
  }

  Future _fetchNotes() async {
    final sp = await SharedPreferences.getInstance();

    String arrange = sp.getString("arrangement");

    if (arrange == null || arrange == "") return;

    for (String idString in arrange.split(",")) {
      arrangement.add(idString);
    }

    String tempId = "0";

    while (true) {
      String temp = sp.getString(tempId);
      if (temp == null) break;

      var almostNote = temp.split("^~#");

      notes.add(new Note(
        title: almostNote[0],
        color: Color(int.parse(
                almostNote[1].substring(almostNote[1].indexOf("x") + 1,
                    almostNote[1].indexOf("x") + 9),
                radix: 16) +
            0xFF000000),
        created: DateTime.parse(almostNote[2]),
        modified: DateTime.parse(almostNote[3]),
        text: almostNote[4],
      ));

      tempId = (int.parse(tempId) + 1).toString();
    }
  }

  Future updateNotes() async {
    final sp = await SharedPreferences.getInstance();

    _updateArrangement();

    for (Note note in notes) {
      String temp = "";
      temp += note.title + "^~#";
      temp += note.color.toString() + "^~#";
      temp += note.created.toString() + "^~#";
      temp += note.modified.toString() + "^~#";
      temp += note.text + "^~#";

      sp.setString(notes.indexOf(note).toString(), temp);
    }
  }

  Note getNote(int id) => this.notes[id];

  Future _updateArrangement() async {
    final sp = await SharedPreferences.getInstance();

    String arrange = "";
    for (String a in arrangement) {
      arrange += a + ",";
    }
    if (arrange != "") arrange = arrange.substring(0, arrange.length - 1);
    sp.setString("arrangement", arrange);
  }

  Future addOrModifyNote(
      {@required bool add,
      int id,
      String title,
      String text,
      Color color,
      DateTime created,
      DateTime modified}) async {
    if (add) {
      this.notes.add(new Note(
            title: title ?? "",
            text: text ?? "",
            color: color,
            created: created,
            modified: modified,
          ));
      arrangement.insert(0, (notes.length - 1).toString());
      _updateArrangement();
    } else {
      this.notes[id] = Note(
        title: title ?? "",
        text: text ?? "",
        color: color,
        created: created,
        modified: modified,
      );
    }
  }

  void deleteNotes(int id) async {
    final sp = await SharedPreferences.getInstance();

    arrangement.remove(id.toString());
    _updateArrangement();

    sp.remove(id.toString());
  }

  void moveNotes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    var temp = arrangement.removeAt(oldIndex);
    arrangement.insert(newIndex, temp);

    _updateArrangement();
  }
}

class Note {
  String title;
  Color color;
  DateTime created;
  DateTime modified;
  String text;

  Note(
      {@required this.title,
      @required this.color,
      @required this.created,
      @required this.modified,
      @required this.text});
}
