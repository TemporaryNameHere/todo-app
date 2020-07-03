import 'package:flutter/material.dart';

enum ListType { Text, Checkbox, Sublist }

@immutable
class DList {
  final String id;
  final String name;
  final List<DListItem> items;

  const DList({@required this.id, @required this.name, @required this.items});

  DList.from({
    @required DList oldList,
    String id,
    String name,
    List<DListItem> items,
  })  : id = id ?? oldList.id,
        name = name ?? oldList.name,
        items = items ?? oldList.items;
}

@immutable
class DListItem {
  final String id;
  final ListType type;
  final String text;

  const DListItem(this.id, this.type, this.text);

  DListItem.from({
    @required DListItem oldItem,
    String id,
    ListType type,
    String text,
  })  : id = id ?? oldItem.id,
        type = type ?? oldItem.type,
        text = text ?? oldItem.text;

  @override
  String toString() {
    var str = super.toString();
    return '${str.substring(13, str.length - 1)}:$id';
  }
}

@immutable
class DListCheckbox extends DListItem {
  final bool checked;

  DListCheckbox(id, type, text, this.checked) : super(id, type, text);

  @override
  String toString() => '${super.toString()}:$checked';
}

@immutable
class DSubList extends DListItem {
  final List<DListItem> sublist;

  DSubList(id, type, text, this.sublist) : super(id, type, text);
}
