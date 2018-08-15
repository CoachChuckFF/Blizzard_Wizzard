import 'dart:io';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/models/models.dart';

class Profile{

  static int idCount = 0;

  final List<int> mac;

  String name;
  int typeId;
  InternetAddress address;
  bool isBlizzard;

  int channelMode = 0;
  int patchAddress = 0;
  int activeTick = BlizzardWizzardConfigs.availableTimoutTick;
  int universe;
  int id;


  Profile(this.mac){
    id = idCount++;
  }

  bool compare(Profile other){
    return (name == other.name &&
            address == other.address);
  }

  @override
  bool operator == (Object other) =>
      other is Profile &&
        other.mac.length == 6 &&
        other.mac[0] == mac[0] &&
        other.mac[1] == mac[1] &&
        other.mac[2] == mac[2] &&
        other.mac[3] == mac[3] &&
        other.mac[4] == mac[4] &&
        other.mac[5] == mac[5];

}