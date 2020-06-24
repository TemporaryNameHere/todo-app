import 'package:flutter/material.dart';

class DList {
  String id;
  String name;
  List<DListItem> items;

  DList({@required this.id, @required this.name, @required this.items});

  DList.from({
    @required DList oldList,
    this.id,
    this.name,
    this.items,
  }) {
    id ??= oldList.id;
    name ??= oldList.name;
    items ??= oldList.items;
  }
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
        text,
        style: TextStyle(
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
