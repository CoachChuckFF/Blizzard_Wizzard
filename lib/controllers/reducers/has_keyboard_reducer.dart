import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';

final hasKeyboardReducer = combineReducers<bool>([
  new TypedReducer<bool, SetHasKeyboard>(_setHasKeyboard),
  new TypedReducer<bool, ClearHasKeyboard>(_clearHasKeyboard)
]);

bool _setHasKeyboard(bool state, action) {
  return true;
}

bool _clearHasKeyboard(bool state, action){
  return false;
}
