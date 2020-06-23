import 'package:flutter/material.dart';

import '../data_types/list_items.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key key, this.name}) : super(key: key);

  final String name;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<DListItem> list = [];

  void createItem() {
    setState(() {
      list.add(new DListItem("2", ListType.Text, "I am number two"));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.name,
              style: new TextStyle(
                fontSize: 48,
              ),
            ),
          ),
          Row(),
          FlatButton(
            child: Text("Create item"),
            onPressed: this.createItem,
          ),
          Container(
            child: ListView.builder(
              itemBuilder: (ctx, index) => this.list[index].build(ctx),
              itemCount: this.list.length,
            ),
            height: 500,
          ),
        ],
      ),
    );
  }
}
