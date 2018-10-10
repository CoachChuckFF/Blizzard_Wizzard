import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/models/show.dart';


final showReducer = combineReducers<Show>([
  new TypedReducer<Show, UpdateShow>(_updateShow),
  new TypedReducer<Show, AddPatchDevice>(_addPatchDevice),
  new TypedReducer<Show, RemovePatchDevice>(_removePatchDevice),
  new TypedReducer<Show, ClearPatchDevice>(_clearPatchDevice),
  new TypedReducer<Show, AddPatchFixture>(_addPatchFixture),
  new TypedReducer<Show, RemovePatchFixture>(_removePatchFixture),
  new TypedReducer<Show, ClearPatchFixture>(_clearPatchFixture),
  new TypedReducer<Show, UpdateSceneList>(_updateSceneList),
]);

Show _updateShow(Show state, UpdateShow action){
  return action.show;
}

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
    patchedFixtures: Map.from(state.patchedFixtures)..[action.slot] = action.fixture
  );
}

Show _removePatchFixture(Show state, RemovePatchFixture action) {

  return state.copyWith(
    patchedFixtures: Map.from(state.patchedFixtures)..remove(action.slot)
  ); 
}

Show _clearPatchFixture(Show state, ClearPatchFixture action) {

  return state.copyWith(
    patchedFixtures: Map<int, PatchedFixture>()
  ); 
}

Show _updateSceneList(Show state, UpdateSceneList action){
  int index = 0;

  return state.copyWith(
    cues: state.cues.map<Cue>((cue){
      if(index++ == action.cueIndex){
        return cue.copyWith(
          scenes: action.scenes
        );
      }
      return cue;
    }).toList()
  );
}