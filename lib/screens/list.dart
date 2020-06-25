import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:todo_app/data_types/list_items.dart';
import 'package:todo_app/store/store.dart';

class ListScreenViewModel {
  final DList list;
  final void Function(DListItem) addItem;

  ListScreenViewModel(this.list, this.addItem);

  ListScreenViewModel.from(Store<AppState> store)
      : this(
          store.state.allListsState
              .allLists[store.state.allListsState.activeListId],
          (DListItem item) => store.dispatch(
            AddItemAction(store.state.allListsState.activeListId, item),
          ),
        );
}

class ListScreen extends StatefulWidget {
  ListScreen({Key key}) : super(key: key);

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
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ListScreenViewModel>(
      converter: (store) => ListScreenViewModel.from(store),
      builder: (context, viewModel) => Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                viewModel.list.name,
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
            ),
            Row(),
            FlatButton(
              child: Text('Create item'),
              onPressed: () => viewModel.addItem(
                DListCheckbox('3', ListType.Text, 'shit', false),
              ),
            ),
            Container(
              child: viewModel.list == null
                  ? Text("You haven't selected a list!")
                  : ListView.builder(
                      itemBuilder: (ctx, index) =>
                          ListItem(item: viewModel.list.items[index]),
                      itemCount: viewModel.list.items.length,
                    ),
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
