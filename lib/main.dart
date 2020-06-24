import 'package:flutter/material.dart';
import 'data_types/list_items.dart';
import 'screens/list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/rendering.dart'; // for debug
import 'package:flutter_redux/flutter_redux.dart';

import 'store/store.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        //debugShowMaterialGrid: true,
        theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Colors.red,
          textTheme: GoogleFonts.rubikTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        home: Scaffold(
          body: SafeArea(
            child: ListScreen(
              name: 'Min lista',
            ),
          ),
        ),
      ),
    );
  }
}
