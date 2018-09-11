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
  bool isArtnet; //otherwise sACN
  bool canSwitch;
  bool isMerging;
  bool isLTP;
  bool isDHCP;
  bool canDHCP;
  int indicatorState;
  int estaCode;
  int universe;


  List<Fixture> fixtures;

  InternetAddress address;
  int activeTick = BlizzardWizzardConfigs.availableTimoutTick;

  ArtnetDataPacket dmxData = ArtnetDataPacket(); //can be more universes

  Device(List<int> mac, 
    {this.name, 
    this.typeId, 
    this.isBlizzard = false, 
    this.address, 
    this.isConnected = false, 
    this.fixtures,
    this.isPatched = false,
    this.isMerging = false,
    this.isLTP = false,
    this.isArtnet = true,
    this.canSwitch = true,
    this.isDHCP = true,
    this.canDHCP = true,
    this.universe = 1,
    this.indicatorState = 0x03,
    this.estaCode = 0,
    })
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
