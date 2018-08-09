import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/views/items/available_device_list.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:d_artnet/d_artnet.dart';

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

  _tapThing(int id){
    Profile p = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((profile) => profile.id == id);

    if(p != null){
      print("Tapped: ${p.name}");
      print(p.address.toString());
      ArtnetDataPacket d = ArtnetDataPacket();
      d.setDmxValue(33, 0xFF);
      d.setDmxValue(35, 0xFF);
      tron.server.sendPacket(d.udpPacket, p.address);
    }
  }
}
