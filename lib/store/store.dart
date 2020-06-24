import 'package:redux/redux.dart';

import '../data_types/list_items.dart';

class AppState {
  final Map<String, DList> allLists;
  final String activeListId;

  AppState({this.allLists = const {}, this.activeListId});
}

class AddItemAction {
  final String listId;

  final DListItem item;

  AddItemAction(this.listId, this.item);
}

AppState reducer(AppState state, dynamic action) {
  if (action is AddItemAction) {
    var list = state.allLists[action.listId];

    return AppState(allLists: {
      action.listId: DList.from(
        oldList: list,
        items: [...list.items, action.item],
      ),
    });
  }

  return state;
}

final store = Store(reducer, initialState: AppState());
