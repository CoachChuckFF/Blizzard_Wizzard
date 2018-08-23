import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/views/screens/fixture_settings_screen.dart';
import 'package:blizzard_wizzard/views/manager_screen_assets/available_device_list.dart';



class ManagerScreen extends StatefulWidget {
  @override
  createState() => ManagerScreenState();
}

class ManagerScreenState extends State<ManagerScreen> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Fixture>>(
      converter: (store) => store.state.availableDevices,
      builder: (context, availableDevices) {
        return AvailableDevicesList(
          availableDevices: availableDevices,
          onTap: _tapThing,
        );
      },
    );
  }

  _tapThing(int id){
    Fixture fixture = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((fixture) => fixture.id == id);

    if(fixture != null){
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) {
            return FixtureSettingsScreen(fixture: fixture);
          },
        ),
      );
    }
  }
}