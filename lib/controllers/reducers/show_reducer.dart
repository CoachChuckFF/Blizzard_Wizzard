import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/show.dart';


final showReducer = combineReducers<Show>([
  new TypedReducer<Show, AddPatchDevice>(_addPatchDevice),
  new TypedReducer<Show, RemovePatchDevice>(_removePatchDevice),
  new TypedReducer<Show, ClearPatchDevice>(_clearPatchDevice),
  new TypedReducer<Show, AddPatchFixture>(_addPatchFixture),
]);

Show _addPatchDevice(Show state, AddPatchDevice action) {

  return state.copyWith(
    patchedDevices: Map.from(state.patchedDevices)..putIfAbsent(action.slot, () => action.device)
  ); 
}

Show _removePatchDevice(Show state, RemovePatchDevice action) {

  PatchedDevice devToRemove;

  return state.copyWith(
    patchedDevices: Map.from(state.patchedDevices)..removeWhere((index, device){
      if(action.slot == index){
        devToRemove = device;
      }
      return action.slot == index;
    }),
    patchedFixtures: Map.from(state.patchedFixtures)..removeWhere((index, fixture){
      if(devToRemove == null){
        return false;
      }
      return fixture.mac == devToRemove.mac;
    })
  ); 
}

Show _clearPatchDevice(Show state, ClearPatchDevice action) {

  return state.copyWith(
    patchedDevices: Map<int, PatchedDevice>(),
    patchedFixtures: Map<int, PatchedFixture>()
  ); 
}

Show _addPatchFixture(Show state, AddPatchFixture action) {

  return state.copyWith(
    patchedFixtures: Map.from(state.patchedFixtures)..putIfAbsent(action.slot, () => action.fixture)
  );
}
