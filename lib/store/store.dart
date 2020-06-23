import 'package:redux/redux.dart';

import '../data_types/list_items.dart';

class AppState {
  final List<List<ListItem>> allLists;

  AppState({this.allLists = const []});
}

AppState reducer(AppState state, dynamic action) {
  if (action is AddItemAction) {
    return new AppState(allLists: [...state.allLists, action.item]);
  }
  return new AppState();
}

class AddItemAction {
  final ListItem item;
  AddItemAction(this.item);
}

final store = new Store(reducer, initialState: new AppState());
