import 'package:flutter/material.dart';
import 'package:teachersapp/notes_data.dart';
import 'package:teachersapp/notes_home_page.dart';

Data d = Data.getInstance();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await d.init();
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticky Notes',
      theme: ThemeData(
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
