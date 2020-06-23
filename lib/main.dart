import 'package:flutter/material.dart';
import 'screens/list.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.red,
        textTheme: GoogleFonts.rubikTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: ListScreen(
            name: "Min lista",
          ),
        ),
      ),
    );
  }
}
