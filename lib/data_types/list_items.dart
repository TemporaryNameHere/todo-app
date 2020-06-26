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
    id,
    name,
    items,
  })  : id = id ?? oldList.id,
        name = name ?? oldList.name,
        items = items ?? oldList.items;
}

@immutable
class DListItem {
  final String id;
  final ListType type;
  final String text;

  DListItem(this.id, this.type, this.text);

  @override
  String toString() {
    var str = super.toString();
    return '${str.substring(13, str.length - 1)}:$id';
  }
}

class ListItem extends StatefulWidget {
  ListItem({Key key, @required this.item}) : super(key: key);

  final DListItem item;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.item.text);
  }

  TextEditingController controller;

  bool dragging = false;
  double dragPosition = 0;
  double dragThreshold = 10000;

  void onDragFinished(details) {
    if (dragPosition.abs() > dragThreshold) {
      return; // Delete
    } else {
      // Animate back to original position
      setState(() {
        dragging = false;
        dragPosition = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => dragging = true,
      onPanUpdate: (details) =>
          setState(() => dragPosition += details.delta.dx),
      onPanEnd: onDragFinished,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: dragging ? Duration.zero : Duration(milliseconds: 250),
        transform:
            Transform.translate(offset: Offset.fromDirection(0, dragPosition))
                .transform,
        child: TextField(controller: controller),
      ),
    );
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
