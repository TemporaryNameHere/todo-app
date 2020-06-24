import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data_types/list_items.dart';

import 'package:todo_app/store/store.dart';

void main() {
  test('test^2', () {
    var activeListId = '123';
    var store = createStore(
      initialState: AppState(
        AllListsState(activeListId, {
          activeListId: DList(
            id: activeListId,
            name: 'Min lisa',
            items: <DListItem>[],
          )
        }),
      ),
    );

    var itemOne = DListItem('1', ListType.Text, 'Shiit');

    store.dispatch(AddItemAction(activeListId, itemOne));

    var list = store.state.allListsState.allLists[activeListId];

    expect(list.items.length, 1);
    expect(list.items[0], itemOne);

    var itemTwo = DListItem('2', ListType.Text, 'Shiittier');

    store.dispatch(AddItemAction(activeListId, itemTwo));

    expect(list.items.length, 2);
    expect(list.items[0], itemOne);
    expect(list.items[1], itemTwo);
  });
}
