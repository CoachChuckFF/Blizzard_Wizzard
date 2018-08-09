import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:redux/redux.dart';

final availableDevicesReducer = combineReducers<List<Profile>>([
  new TypedReducer<List<Profile>, TickDownAvailableDevice>(_tickDownAvailableDevices),
  new TypedReducer<List<Profile>, TickResetAvailableDevice>(_tickResetAvailableDevice),
  new TypedReducer<List<Profile>, AddAvailableDevice>(_addAvailableDevice),
  new TypedReducer<List<Profile>, RemoveAvailableDevice>(_removeAvailableDevice),
  new TypedReducer<List<Profile>, UpdateAvailableDevice>(_updateAvailableDevice)
]);

List<Profile> _tickDownAvailableDevices(List<Profile> state, TickDownAvailableDevice action) {
  return state
        .map<Profile>((profile){
          if(profile.id == action.profile.id){
            profile.activeTick--;
          }

          return profile;
        })
        .toList();
}

List<Profile> _tickResetAvailableDevice(List<Profile> state, TickResetAvailableDevice action){
  return state
        .map<Profile>((profile){
          if(profile.id == action.profile.id){
            profile.activeTick = BlizzardWizzardConfigs.availableTimoutTick;
          }

          return profile;
        })
        .toList();
}

List<Profile> _addAvailableDevice(List<Profile> state, AddAvailableDevice action){
  return new List.from(state)..add(action.profile);
}

List<Profile> _removeAvailableDevice(List<Profile> state, RemoveAvailableDevice action){
  return state.where((profile) => profile.id != action.profile.id).toList();
}

List<Profile> _updateAvailableDevice(List<Profile> state, UpdateAvailableDevice action){
  return state
      .map<Profile>((profile) => profile.id == action.profile.id ? action.profile : profile)
      .toList();

}
