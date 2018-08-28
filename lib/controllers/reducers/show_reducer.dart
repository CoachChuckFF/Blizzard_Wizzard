import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/show.dart';


final showReducer = combineReducers<Show>([
  new TypedReducer<Show, AddPatchDevice>(_addPatchDevice),
]);

Show _addPatchDevice(Show state, AddPatchDevice action) {

  return state.copyWith(
    patchedDevices: Map.from(state.patchedDevices)..putIfAbsent(action.slot, () => action.mac)
  ); 
}
