import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';

final loadingReducer = combineReducers<bool>([
  new TypedReducer<bool, SetLoaded>(_setLoaded),
  new TypedReducer<bool, ClearLoaded>(_clearLoaded)
]);

bool _setLoaded(bool state, action) {
  return false;
}

bool _clearLoaded(bool state, action){
  return true;
}
