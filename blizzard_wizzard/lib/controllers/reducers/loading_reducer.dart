import 'package:blizzard_wizzard/models/actions.dart';
import 'package:redux/redux.dart';

final loadingReducer = combineReducers<bool>([
  new TypedReducer<bool, SetLoaded>(_setLoaded),
  new TypedReducer<bool, ClearLoaded>(_clearLoaded)
]);

bool _setLoaded(bool state, action) {
  return true;
}

bool _clearLoaded(bool state, action){
  return false;
}
