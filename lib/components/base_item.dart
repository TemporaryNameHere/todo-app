import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data_types/list_items.dart';

class BaseListItem extends StatefulWidget {
  final DListItem item;
  final void Function() removeItem;
  final void Function(String) editItemText;
  final Widget widgetBefore;

  BaseListItem({
    Key key,
    @required this.item,
    @required this.removeItem,
    @required this.editItemText,
    this.widgetBefore,
  }) : super(key: key);

  @override
  _BaseListItemState createState() => _BaseListItemState();
}

class _BaseListItemState extends State<BaseListItem> {
  TextEditingController _controller;
  FocusNode _textFieldFocusNode;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.item.text);
    _textFieldFocusNode = FocusNode(debugLabel: 'ListItem:${widget.item.id}');

    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus) return;

      widget.editItemText(_controller.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _textFieldFocusNode.dispose();
    _controller.dispose();

    super.dispose();
  }

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

  Color get backgroundColor {
    return _dragPosition.abs() > _dragThreshold
        ? Colors.red
        : Colors.transparent;
  }

  Matrix4 get horizontalOffset {
    return Transform.translate(offset: Offset.fromDirection(0, _dragPosition))
        .transform;
  }

  @override
  Widget build(BuildContext context) {
    _dragThreshold ??= MediaQuery.of(context).size.width / 2;

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
      color: backgroundColor,
      height: 50,
      child: GestureDetector(
        onTap: () => _textFieldFocusNode.requestFocus(),
        onPanStart: (_) => _dragging = true,
        onPanUpdate: (details) =>
            setState(() => _dragPosition += details.delta.dx),
        onPanEnd: onDragFinished,
        child: Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[widget.widgetBefore ?? Icon(Icons.ac_unit)],
                ),
                height: 50,
                width: 50,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration:
                    _dragging ? Duration.zero : Duration(milliseconds: 250),
                transform: horizontalOffset,
                child: IgnorePointer(
                  ignoring: !_textFieldFocusNode.hasFocus,
                  child: TextField(
                    focusNode: _textFieldFocusNode,
                    controller: _controller,
                    autocorrect: true,
                    minLines: 1,
                    maxLines: 10,
                    decoration: InputDecoration.collapsed(hintText: null),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
