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
  final void Function() removeItem;
  final void Function(String) editItemText;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  TextEditingController _controller;
  FocusNode _textFieldFocusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.item.text);
    _textFieldFocusNode = FocusNode(debugLabel: 'ListItem:${widget.item.id}');

    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) return;

      widget.editItemText(_controller.text);
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _textFieldFocusNode.dispose();

    super.dispose();
  }

  bool _enabled = true;

  bool _dragging = false;
  double _dragPosition = 0;
  double _dragThreshold;

  void onDragFinished(_) {
    if (_dragPosition.abs() > _dragThreshold) {
      widget.removeItem();
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
      onTap: () => _textFieldFocusNode.requestFocus(),
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
        child: IgnorePointer(
          ignoring: !_textFieldFocusNode.hasFocus,
          child: TextField(
            enabled: _enabled,
            focusNode: _textFieldFocusNode,
            controller: _controller,
          ),
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
