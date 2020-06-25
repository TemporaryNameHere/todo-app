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

  final TextEditingController controller;

  DListItem(this.id, this.type, this.text)
      : controller = TextEditingController(text: text);

  @override
  String toString() {
    var str = super.toString();
    return '${str.substring(13, str.length - 1)}:$id';
  }

  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
      ),
    );
  }
}

class DListCheckbox extends DListItem {
  final bool checked;

  DListCheckbox(id, type, text, this.checked) : super(id, type, text);

  @override
  String toString() => '${super.toString()}:$checked';
}

class DSubList extends DListItem {
  final List<DListItem> sublist;

  DSubList(id, type, text, this.sublist) : super(id, type, text);
}
