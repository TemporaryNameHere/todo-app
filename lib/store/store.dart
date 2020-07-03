import 'package:redux/redux.dart';

import '../data_types/list_items.dart';

class AllListsState {
  final String activeListId;
  final Map<String, DList> allLists;

  const AllListsState(this.activeListId, this.allLists);

  // TODO: Reduce to actual initial state
  const AllListsState.initial()
      : activeListId = '123',
        allLists = const {
          '123': DList(
            id: '123',
            name: 'Min lisa',
            items: <DListItem>[],
          )
        };
}

class AppState {
  final AllListsState allListsState;

  const AppState(this.allListsState);

  const AppState.initial() : allListsState = const AllListsState.initial();
}

class AddItemAction {
  final String listId;
  final DListItem item;

  const AddItemAction(this.listId, this.item);
}

class RemoveItemAction {
  final String listId;
  final String id;

  const RemoveItemAction(this.listId, this.id);
}

class EditItemTextAction {
  final String listId;
  final String id;
  final String newText;

  const EditItemTextAction(this.listId, this.id, this.newText);
}

class ReorderItemsAction {
  final String listId;
  final num oldIndex;
  final num newIndex;

  const ReorderItemsAction(this.listId, this.oldIndex, this.newIndex);
}

var allListsReducer = combineReducers<AllListsState>([
  // AddItemAction
  TypedReducer<AllListsState, AddItemAction>((state, action) {
    var newAllLists = {...state.allLists};
    var list = newAllLists[action.listId];

    newAllLists[action.listId] = DList.from(
      oldList: list,
      items: [...list.items, action.item],
    );

    return AllListsState(state.activeListId, newAllLists);
  }),

  // RemoveItemAction
  TypedReducer<AllListsState, RemoveItemAction>((state, action) {
    var newAllLists = {...state.allLists};
    var list = newAllLists[action.listId];
    var items = [...list.items];

    var index = items.indexWhere((item) => item.id == action.id);
    if (index == -1) return state;
    items.removeAt(index);

    newAllLists[action.listId] = DList.from(
      oldList: list,
      items: items,
    );

    return AllListsState(state.activeListId, newAllLists);
  }),

  // EditItemTextAction
  TypedReducer<AllListsState, EditItemTextAction>((state, action) {
    var newAllLists = state.allLists;
    var list = newAllLists[action.listId];
    var items = [...list.items];

    var index = items.indexWhere((item) => item.id == action.id);
    if (index == -1) return state;

    var item = items[index];
    var newItem;
    if (item is DListCheckbox) {
      newItem = DListCheckbox(
        item.id,
        item.type,
        action.newText,
        item.checked,
      );
    } else if (item is DSubList) {
      newItem = DSubList(
        item.id,
        item.type,
        action.newText,
        item.sublist,
      );
    } else if (item is DListItem) {
      newItem = DListItem(
        item.id,
        item.type,
        action.newText,
      );
    }

    items[index] = newItem;
    newAllLists[action.listId] = DList.from(
      oldList: list,
      items: items,
    );

    return AllListsState(state.activeListId, newAllLists);
  }),

  // ReorderItemsAction
  TypedReducer<AllListsState, ReorderItemsAction>((state, action) {
    var newAllLists = {...state.allLists};
    var list = newAllLists[action.listId];

    var item = list.items.removeAt(action.oldIndex);
    list.items.insert(action.newIndex, item);

    newAllLists[action.listId] = DList.from(
      oldList: list,
      items: list.items,
    );

    return AllListsState(state.activeListId, newAllLists);
  }),
]);

AppState reducer(AppState state, dynamic action) =>
    AppState(allListsReducer(state.allListsState, action));

Store<AppState> createStore({
  AppState initialState = const AppState.initial(),
}) =>
    Store(reducer, initialState: initialState);
