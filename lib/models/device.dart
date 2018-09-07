import 'dart:io';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/mac.dart';

class Device{

  Mac mac;

  String name;
  int typeId;
  bool isBlizzard;
  bool isConnected;
  bool isPatched;

  List<Fixture> fixtures;

  InternetAddress address;
  int activeTick = BlizzardWizzardConfigs.availableTimoutTick;

  ArtnetDataPacket dmxData = ArtnetDataPacket(); //can be more universes

  Device(List<int> mac, {this.name, 
    this.typeId, 
    this.isBlizzard = false, 
    this.address, 
    this.isConnected = false, 
    this.fixtures,
    this.isPatched = false})
  {

    if(this.fixtures == null){
      this.fixtures = List<Fixture>();
    }
    this.mac = Mac(mac);

  }

  bool compare(Device other){
    return (name == other.name &&
            address == other.address);
  }

  @override
  bool operator == (Object other) =>
      other is Device &&
        other.mac == mac;

}
