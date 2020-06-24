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

Store<AppState> createStore({AppState initialState = const AppState.initial()}) => Store(reducer, initialState: initialState );
