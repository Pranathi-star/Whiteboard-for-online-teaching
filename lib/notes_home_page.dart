import 'package:flutter/material.dart';
import 'package:teachersapp/notes_data.dart';

import 'note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Data d = Data.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text("Sticky Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var navResult = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteEditing(
                        id: (d.notes.length == 0) ? 0 : d.notes.length,
                        trueForAdd: true,
                      )));

          if (navResult) setState(() {});
        },
      ),
      body: d.arrangement.isNotEmpty
          ? ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  d.moveNotes(oldIndex, newIndex);
                });
              },
              scrollDirection: Axis.vertical,
              children: <Widget>[
                for (String arrange in d.arrangement)
                  Container(
                    key: ValueKey(arrange),
                    child: Card(
                      elevation: 2,
                      color: d.getNote(int.parse(arrange)).color,
                      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: ListTile(
                        title: Text(d.getNote(int.parse(arrange)).title),
                        subtitle: Text(d.getNote(int.parse(arrange)).text),
                        contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        onTap: () async {
                          var navResult = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteEditing(
                                        id: (int.parse(arrange)),
                                        trueForAdd: false,
                                      )));

                          if (navResult) setState(() {});
                        },
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("Add notes.")],
              ),
            ),
    );
  }
}
