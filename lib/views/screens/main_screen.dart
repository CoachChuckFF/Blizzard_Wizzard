import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/views/items/available_device_list.dart';
import 'package:blizzard_wizzard/models/models.dart';

class MainScreen extends StatefulWidget {
  @override
  createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold (

      appBar: AppBar(
        title: Text('Blizzard Wizzard'),
      ),
      body: new StoreConnector<AppState, List<Profile>>(
        converter: (store) => store.state.availableDevices,
        builder: (context, availableDevices) {
          return AvailableDevicesList(
            availableDevices: availableDevices,
            onTap: _tapThing,
          );
        },
      ),
    );
  }

  _tapThing(Profile p){
    print("Tapped: " + p.name);
  }
}
