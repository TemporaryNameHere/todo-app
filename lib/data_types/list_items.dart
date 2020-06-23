import 'package:flutter/material.dart';

class DList {
  String id;
  String name;
  List<DListItem> items;

  DList({@required this.id, @required this.name, @required this.items});

  static from({
    @required DList oldList,
    String id,
    String name,
    List<DListItem> items,
  }) =>
      new DList(
        id: id ?? oldList.id,
        name: name ?? oldList.name,
        items: items ?? oldList.items,
      );
}

enum ListType { Text, Checkbox, Sublist }

class DListItem {
  final String id;
  final ListType type;
  final String text;

  DListItem(this.id, this.type, this.text);

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

class DListCheckbox extends DListItem {
  final bool checked;

  DListCheckbox(id, type, text, this.checked) : super(id, type, text);
}

class DSubList extends DListItem {
  final List<DListItem> sublist;

  DSubList(id, type, text, this.sublist) : super(id, type, text);
}
