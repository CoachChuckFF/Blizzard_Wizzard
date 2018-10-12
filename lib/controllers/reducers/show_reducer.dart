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
  new TypedReducer<Show, SetCurrentScene>(_setCurrentScene),
  new TypedReducer<Show, UpdateSceneList>(_updateSceneList),
  new TypedReducer<Show, AddScene>(_addScene),
  new TypedReducer<Show, RemoveScene>(_removeScene),  
  new TypedReducer<Show, UpdateScene>(_updateScene),
  new TypedReducer<Show, SetCurrentCue>(_setCurrentCue),
  new TypedReducer<Show, UpdateCueList>(_updateCueList),
  new TypedReducer<Show, AddCue>(_addCue),
  new TypedReducer<Show, RemoveCue>(_removeCue),  
  new TypedReducer<Show, UpdateCue>(_updateCue),
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

Show _setCurrentScene(Show state, SetCurrentScene action){
  return state.copyWith(
    currentScene: action.currentScene
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

Show _addScene(Show state, AddScene action){
  int index = 0;

  return state.copyWith(
    cues: state.cues.map<Cue>((cue){
      if(index++ == action.cueIndex){
        return cue.copyWith(
          scenes: List.from(cue.scenes)..add(action.scene)
        );
      }
      return cue;
    }).toList()
  );
}

Show _removeScene(Show state, RemoveScene action){
  int index = 0;

  return state.copyWith(
    cues: state.cues.map<Cue>((cue){
      if(index++ == action.cueIndex){
        return cue.copyWith(
          scenes: List.from(cue.scenes)..removeAt(action.sceneIndex)
        );
      }
      return cue;
    }).toList()
  );
}

Show _updateScene(Show state, UpdateScene action){
  int index = 0;
  int jndex = 0;

  return state.copyWith(
    cues: state.cues.map<Cue>((cue){
      if(index++ == action.cueIndex){
        return cue.copyWith(
          scenes: cue.scenes.map<Scene>((scene){
            if(jndex++ == action.sceneIndex){
              return action.scene;
            }
            return scene;
          }).toList()
        );
      }
      return cue;
    }).toList()
  );
}

Show _setCurrentCue(Show state, SetCurrentCue action){
  return state.copyWith(
    currentCue: action.currentCue
  );
}

Show _updateCueList(Show state, UpdateCueList action){
  return state.copyWith(
    cues: action.cues
  );
}

Show _addCue(Show state, AddCue action){
  return state.copyWith(
    cues: List.from(state.cues)..add(action.cue)
  );
}

Show _removeCue(Show state, RemoveCue action){
  return state.copyWith(
    cues: List.from(state.cues)..removeAt(action.cueIndex)
  );
}

Show _updateCue(Show state, UpdateCue action){
  int index = 0;

  return state.copyWith(
    cues: state.cues.map<Cue>((cue){
      if(index++ == action.cueIndex){
        return action.cue;
      }
      return cue;
    }).toList()
  );
}