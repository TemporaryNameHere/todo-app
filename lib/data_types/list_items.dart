
enum ListType { Text, Checkbox, Sublist }class ListItem {
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
