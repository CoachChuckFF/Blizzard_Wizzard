import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';


final availableDevicesReducer = combineReducers<List<Device>>([
  new TypedReducer<List<Device>, TickDownAvailableDevice>(_tickDownAvailableDevices),
  new TypedReducer<List<Device>, TickResetAvailableDevice>(_tickResetAvailableDevice),
  new TypedReducer<List<Device>, AddAvailableDevice>(_addAvailableDevice),
  new TypedReducer<List<Device>, RemoveAvailableDevice>(_removeAvailableDevice),
  new TypedReducer<List<Device>, UpdateAvailableDevice>(_updateAvailableDevice)
]);

List<Device> _tickDownAvailableDevices(List<Device> state, TickDownAvailableDevice action) {
  return state
        .map<Device>((device){
          if(device == action.device){
            device.activeTick--;
          }

          return device;
        })
        .toList();
}

List<Device> _tickResetAvailableDevice(List<Device> state, TickResetAvailableDevice action){
  return state
        .map<Device>((device){
          if(device == action.device){
            device.activeTick = BlizzardWizzardConfigs.availableTimoutTick;
          }

          return device;
        })
        .toList();
}

List<Device> _addAvailableDevice(List<Device> state, AddAvailableDevice action){
  return new List.from(state)..add(action.device);
}

List<Device> _removeAvailableDevice(List<Device> state, RemoveAvailableDevice action){
  return state.where((device) => device != action.device).toList();
}

List<Device> _updateAvailableDevice(List<Device> state, UpdateAvailableDevice action){
  return state
      .map<Device>((device) => device == action.device ? action.device : device)
      .toList();

}
