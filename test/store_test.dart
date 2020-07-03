import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data_types/list_items.dart';

import 'package:todo_app/store/store.dart';

void main() {
  group('AddItemAction + reducer', () {
    test('should add items to list', () {
      var activeListId = '123';
      var store = createStore(
        initialState: AppState(
          AllListsState(activeListId, {
            activeListId: DList(
              id: activeListId,
              name: 'Min lisa',
              items: <DListItem>[],
            ),
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

      list = store.state.allListsState.allLists[activeListId];

      expect(list.items.length, 2);
      expect(list.items[0], itemOne);
      expect(list.items[1], itemTwo);
    });
  });

  group('RemoveItemAction + reducer', () {
    test('should remove items from list', () {
      var activeListId = '123';
      var items = <DListItem>[
        DListItem('0', ListType.Text, 'First'),
        DListItem('1', ListType.Text, 'Second'),
        DListItem('2', ListType.Text, 'Third'),
        DListItem('3', ListType.Text, 'Fourth'),
      ];

      var store = createStore(
        initialState: AppState(
          AllListsState(activeListId, {
            activeListId: DList(
              id: activeListId,
              name: 'Min lisa',
              items: items,
            ),
          }),
        ),
      );

      store.dispatch(RemoveItemAction(
        activeListId,
        items[0].id,
      ));

      var list = store.state.allListsState.allLists[activeListId];

      expect(list.items.length, 3);
      expect(list.items[0].id, '1');

      store.dispatch(RemoveItemAction(
        activeListId,
        items[2].id,
      ));

      list = store.state.allListsState.allLists[activeListId];

      expect(list.items.length, 2);
      expect(list.items[0].id, '1');
      expect(list.items[1].id, '3');
    });
  });

  group('EditItemTextAction + reducer', () {
    test('should edit the text of an item in a list', () {
      var activeListId = '123';
      var items = <DListItem>[
        DListItem('0', ListType.Text, 'First'),
        DListItem('1', ListType.Text, 'Second'),
        DListItem('2', ListType.Text, 'Third'),
        DListItem('3', ListType.Text, 'Fourth'),
      ];

      var store = createStore(
        initialState: AppState(
          AllListsState(activeListId, {
            activeListId: DList(
              id: activeListId,
              name: 'Min lisa',
              items: items,
            ),
          }),
        ),
      );

      var newText = 'New text!';
      store.dispatch(EditItemTextAction(
        activeListId,
        items[0].id,
        newText,
      ));

      var list = store.state.allListsState.allLists[activeListId];

      expect(list.items[0].text, newText);

      store.dispatch(EditItemTextAction(
        activeListId,
        items[2].id,
        newText,
      ));

      list = store.state.allListsState.allLists[activeListId];

      expect(list.items[2].text, newText);
    });
  });

  group('ReorderItemsAction + reducer', () {
    var assertOrder = (DList list, List<String> order) {
      var i = 0;
      order.forEach((item) {
        expect(list.items[i].id, order[i]);
        i++;
      });
    };

    test('should reorder items in list', () {
      var activeListId = '123';
      var items = <DListItem>[
        DListItem('0', ListType.Text, 'First'),
        DListItem('1', ListType.Text, 'Second'),
        DListItem('2', ListType.Text, 'Third'),
        DListItem('3', ListType.Text, 'Fourth'),
      ];

      var store = createStore(
        initialState: AppState(
          AllListsState(activeListId, {
            activeListId: DList(
              id: activeListId,
              name: 'Min lisa',
              items: items,
            ),
          }),
        ),
      );

      store.dispatch(ReorderItemsAction(
        activeListId,
        0,
        3,
      ));

      var list = store.state.allListsState.allLists[activeListId];

      assertOrder(list, [
        '1',
        '2',
        '3',
        '0',
      ]);

      store.dispatch(ReorderItemsAction(
        activeListId,
        2,
        3,
      ));

      list = store.state.allListsState.allLists[activeListId];

      assertOrder(list, [
        '1',
        '2',
        '0',
        '3',
      ]);
    });
  });
}
