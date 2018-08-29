import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/show.dart';


final showReducer = combineReducers<Show>([
  new TypedReducer<Show, AddPatchDevice>(_addPatchDevice),
]);

Show _addPatchDevice(Show state, AddPatchDevice action) {

  return state.copyWith(
    patchedDevices: Map.from(state.patchedDevices)..putIfAbsent(action.slot, () => PatchedDevice(
      mac: action.mac,
      name: action.name))
  ); 
}
