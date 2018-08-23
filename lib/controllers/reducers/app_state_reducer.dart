import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/controllers/reducers/available_devices_reducer.dart';
import 'package:blizzard_wizzard/controllers/reducers/loading_reducer.dart';


// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: loadingReducer(state.isLoading, action),
    availableDevices: availableDevicesReducer(state.availableDevices, action),
  );
}
