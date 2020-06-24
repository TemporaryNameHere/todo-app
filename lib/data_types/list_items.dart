import 'package:flutter/material.dart';

enum ListType { Text, Checkbox, Sublist }

class DList {
  final String id;
  final String name;
  final List<DListItem> items;

  const DList({@required this.id, @required this.name, @required this.items});

  DList.from({
    @required DList oldList,
    id,
    name,
    items,
  })  : id = id ?? oldList.id,
        name = name ?? oldList.name,
        items = items ?? oldList.items;
}

class DListItem {
  final String id;
  final ListType type;
  final String text;

  DListItem(this.id, this.type, this.text);

  @override
  String toString() => 'DListItem:$id';

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
