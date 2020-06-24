import 'package:redux/redux.dart';

import '../data_types/list_items.dart';

class AllListsState {
  final String activeListId;
  final Map<String, DList> allLists;

  AllListsState(this.activeListId, this.allLists);

  // TODO: Reduce to actual initial state
  AllListsState.initial()
      : activeListId = '123',
        allLists = const {
          '123': DList(
            id: '123',
            name: 'Min lista',
            items: <DListItem>[],
          )
        };
}

class AppState {
  final AllListsState allListsState;

  AppState(this.allListsState);

  AppState.initial() : allListsState = AllListsState.initial();
}

class AddItemAction {
  final String listId;
  final DListItem item;

  AddItemAction(this.listId, this.item);
}

AllListsState allListsReducer(AllListsState state, dynamic action) {
  if (action is AddItemAction) {
    var list = state.allLists[action.listId];

    return AllListsState(state.activeListId, {
      action.listId: DList.from(
        oldList: list,
        items: [...list.items, action.item],
      ),
    });
  }

  return state;
}

AppState reducer(AppState state, dynamic action) =>
    AppState(allListsReducer(state.allListsState, action));

final store = Store(reducer, initialState: AppState.initial());
