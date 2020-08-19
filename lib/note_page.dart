import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teachersapp/notes_data.dart';

class NoteEditing extends StatefulWidget {
  final bool trueForAdd;
  final int id;

  NoteEditing({Key key, this.id, this.trueForAdd});

  @override
  _NoteEditingState createState() => _NoteEditingState();
}

class _NoteEditingState extends State<NoteEditing> {
  Data d = Data.getInstance();
  bool editing = false;

  String title;
  Color color = Colors.purple[100];
  DateTime created;
  DateTime modified;
  String text;

  @override
  Widget build(BuildContext context) {
    created = created ?? DateTime.now();

    if (!widget.trueForAdd && !editing) {
      this.title = d.getNote(widget.id).title;
      this.color = d.getNote(widget.id).color;
      this.created = d.getNote(widget.id).created;
      this.modified = d.getNote(widget.id).modified;
      this.text = d.getNote(widget.id).text;
    }

    editing = true;

    return WillPopScope(
      onWillPop: () async {
        modified = DateTime.now();

        if ((title != "" && title != null) || (text != "" && text != null)) {
          await d.addOrModifyNote(
            add: widget.trueForAdd,
            id: widget.id,
            title: title,
            color: color,
            created: created,
            modified: modified,
            text: text,
          );
        }

        Navigator.pop(context, true);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: NoteAppBar(),
        backgroundColor: this.color,
        body: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NoteTitle(),
              NoteContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget NoteTitle() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.75),
        child: TextField(
          controller: TextEditingController(text: this.title),
          decoration: InputDecoration(
            hintText: "Title",
            border: InputBorder.none,
            isDense: true,
            counter: SizedBox(
              height: 0,
            ),
          ),
          maxLength: 64,
          onChanged: (String s) {
            this.title = s;
          },
        ),
      );

  Widget NoteContent() => Expanded(
        child: TextField(
          controller: TextEditingController(text: this.text),
          decoration: InputDecoration(
            hintText: "Note",
            border: InputBorder.none,
            isDense: true,
          ),
          maxLines: null,
          autofocus: true,
          expands: true,
          onChanged: (String s) {
            this.text = s;
          },
        ),
      );

  Widget NoteAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black54),
      actions: <Widget>[
        Center(
          child: widget.trueForAdd
              ? null
              : Tooltip(
                  message:
                      "Created ${DateFormat('dd MMM yy kk:mm').format(this.created)}\nModified ${DateFormat('dd MMM yy kk:mm').format(this.modified)}",
                  child: Text(
                      "Modified ${DateFormat('dd MMM yy kk:mm').format(this.modified)}"),
                ),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          tooltip: 'Delete note',
          onPressed: () {
            d.deleteNotes(widget.id);
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
