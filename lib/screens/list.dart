import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nanoid/nanoid.dart';
import 'package:redux/redux.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todo_app/components/base_item.dart';
import 'package:todo_app/data_types/list_items.dart';
import 'package:todo_app/store/store.dart';

class ListScreenViewModel {
  final DList list;
  final void Function(DListItem) addItem;
  final void Function(String) removeItem;
  final void Function(String, String) editItemText;
  final void Function(num, num) reorderItems;

  ListScreenViewModel(
    this.list,
    this.addItem,
    this.removeItem,
    this.editItemText,
    this.reorderItems,
  );

  ListScreenViewModel.from(Store<AppState> store)
      : this(
          store.state.allListsState
              .allLists[store.state.allListsState.activeListId],
          (DListItem item) => store.dispatch(
            AddItemAction(store.state.allListsState.activeListId, item),
          ),
          (String id) => store.dispatch(
            RemoveItemAction(store.state.allListsState.activeListId, id),
          ),
          (String id, String newText) => store.dispatch(
            EditItemTextAction(
              store.state.allListsState.activeListId,
              id,
              newText,
            ),
          ),
          (num oldIndex, num newIndex) => store.dispatch(ReorderItemsAction(
            store.state.allListsState.activeListId,
            oldIndex,
            newIndex,
          ))
        );
}

class ListScreen extends StatefulWidget {
  ListScreen({Key key}) : super(key: key);

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
              onPressed: () {
                var id = nanoid(14);
                return viewModel.addItem(
                  DListCheckbox(id, ListType.Text, id, false),
                );
              },
            ),
            Container(
              child: viewModel.list == null
                  ? Text("You haven't selected a list!")
                  : CustomScrollView(
                      controller: ScrollController(),
                      slivers: <Widget>[
                        ReorderableSliverList(
                          onReorder: viewModel.reorderItems,
                          delegate: ReorderableSliverChildBuilderDelegate(
                            (ctx, index) {
                              var item = viewModel.list.items[index];

                              return BaseListItem(
                                key: Key(item.id),
                                item: item,
                                removeItem: () => viewModel.removeItem(item.id),
                                editItemText: (String text) =>
                                    viewModel.editItemText(item.id, text),
                              );
                            },
                            childCount: viewModel.list.items.length,
                          ),
                        ),
                      ],
                    ),
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
