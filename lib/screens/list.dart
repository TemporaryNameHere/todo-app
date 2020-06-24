import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:todo_app/data_types/list_items.dart';
import 'package:todo_app/store/store.dart';

class ListScreenViewModel {
  final DList list;
  final void Function(DListItem) dispatch;

  ListScreenViewModel(this.list, this.dispatch);

  ListScreenViewModel.from(Store<AppState> store)
      : this(
          store.state.allLists[store.state.activeListId],
          (DListItem item) => store.dispatch(
            AddItemAction(store.state.activeListId, item),
          ),
        );
}

class ListScreen extends StatefulWidget {
  ListScreen({Key key, this.name}) : super(key: key);

  final String name;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<DListItem> list = [];

  void createItem() {
    setState(() {
      list.add(DListItem('2', ListType.Text, 'I am number two'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DList>(
      converter: (store) => store.state.allLists[store.state.activeListId],
      builder: (context, viewModel) => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
            ),
            Row(),
            FlatButton(
              child: Text('Create item'),
              onPressed: createItem,
            ),
            Container(
              child: ListView.builder(
                itemBuilder: (ctx, index) => list[index].build(ctx),
                itemCount: list.length,
              ),
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
