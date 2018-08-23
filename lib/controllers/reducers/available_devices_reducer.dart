import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';


final availableDevicesReducer = combineReducers<List<Fixture>>([
  new TypedReducer<List<Fixture>, TickDownAvailableDevice>(_tickDownAvailableDevices),
  new TypedReducer<List<Fixture>, TickResetAvailableDevice>(_tickResetAvailableDevice),
  new TypedReducer<List<Fixture>, AddAvailableDevice>(_addAvailableDevice),
  new TypedReducer<List<Fixture>, RemoveAvailableDevice>(_removeAvailableDevice),
  new TypedReducer<List<Fixture>, UpdateAvailableDevice>(_updateAvailableDevice)
]);

List<Fixture> _tickDownAvailableDevices(List<Fixture> state, TickDownAvailableDevice action) {
  return state
        .map<Fixture>((fixture){
          if(fixture.id == action.fixture.id){
            fixture.activeTick--;
          }

          return fixture;
        })
        .toList();
}

List<Fixture> _tickResetAvailableDevice(List<Fixture> state, TickResetAvailableDevice action){
  return state
        .map<Fixture>((fixture){
          if(fixture.id == action.fixture.id){
            fixture.activeTick = BlizzardWizzardConfigs.availableTimoutTick;
          }

          return fixture;
        })
        .toList();
}

List<Fixture> _addAvailableDevice(List<Fixture> state, AddAvailableDevice action){
  return new List.from(state)..add(action.fixture);
}

List<Fixture> _removeAvailableDevice(List<Fixture> state, RemoveAvailableDevice action){
  return state.where((fixture) => fixture.id != action.fixture.id).toList();
}

List<Fixture> _updateAvailableDevice(List<Fixture> state, UpdateAvailableDevice action){
  return state
      .map<Fixture>((fixture) => fixture.id == action.fixture.id ? action.fixture : fixture)
      .toList();

}
