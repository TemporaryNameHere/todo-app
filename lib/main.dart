import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/list.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:flutter/rendering.dart'; // for debug
import 'package:flutter_redux/flutter_redux.dart';

import 'store/store.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: createStore(),
      child: GestureDetector(
        onTap: () {
          var focus = FocusScope.of(context);

          // Not sure if this check is necessary, it seems to always be false
          if (!focus.hasPrimaryFocus) {
            // Should use .unfocus() but it does literally nothing so fuck it
            focus.requestFocus(FocusNode());
          }
        },
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
              child: ListScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
