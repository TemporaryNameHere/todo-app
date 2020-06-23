import 'package:flutter/material.dart';

enum ListType {
  Text,
  Checkbox,
  Sublist
}

class ListItem {
  final String id;
  final ListType type;
  final String text;

  ListItem(this.id, this.type, this.text);

  Widget build(BuildContext context) {
    return Container(
      child: Text(
        this.text,
        style: new TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}

class ListCheckbox extends ListItem {
  final bool checked;

  ListCheckbox(id, type, text, this.checked) : super(id, type, text);
}

class SubList extends ListItem {
  final List<ListItem> sublist;

  SubList(id, type, text, this.sublist) : super(id, type, text);
}

class ListScreen extends StatefulWidget {
  ListScreen({Key key}) : super(key: key);

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
  final List<ListItem> list = [];

  void createItem() {
    setState(() {
      list.add(new ListItem("2", ListType.Text, "I am number two"));
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
          Text("Min lista"),
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
