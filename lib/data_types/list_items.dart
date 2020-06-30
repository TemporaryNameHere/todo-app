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

class ListItem extends StatefulWidget {
  ListItem({
    Key key,
    @required this.item,
    @required this.removeItem,
    @required this.editItemText,
  }) : super(key: key);

  final DListItem item;
  final void Function(String) removeItem;
  final void Function(String, String) editItemText;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.item.text);
    _focusNode = FocusNode(debugLabel: 'ListItem:${widget.item.id}');

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) return;

      widget.editItemText(widget.item.id, _controller.text);
    });
  }

  TextEditingController _controller;
  FocusNode _focusNode;

  bool _dragging = false;
  double _dragPosition = 0;
  double _dragThreshold;

  void onDragFinished(_) {
    if (_dragPosition.abs() > _dragThreshold) {
      widget.removeItem(widget.item.id);
    } else {
      // Animate back to original position
      setState(() {
        _dragging = false;
        _dragPosition = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _dragThreshold ??= MediaQuery.of(context).size.width / 2;

    return GestureDetector(
      onPanStart: (_) => _dragging = true,
      onPanUpdate: (details) =>
          setState(() => _dragPosition += details.delta.dx),
      onPanEnd: onDragFinished,
      child: AnimatedContainer(
        color: _dragPosition.abs() > _dragThreshold
            ? Colors.red
            : Colors.transparent,
        curve: Curves.ease,
        duration: _dragging ? Duration.zero : Duration(milliseconds: 250),
        transform:
            Transform.translate(offset: Offset.fromDirection(0, _dragPosition))
                .transform,
        child: TextField(
          focusNode: _focusNode,
          controller: _controller,
        ),
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
