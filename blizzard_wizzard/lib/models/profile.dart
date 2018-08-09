import 'dart:io';
import 'package:blizzard_wizzard/architecture/globals.dart';

class Profile{

  static int idCount = 0;

  String name;
  String type;
  InternetAddress address;

  int universe;
  int id;
  int channelMode = 0;
  int activeTick = BlizzardWizzardConfigs.availableTimoutTick;

  Profile(this.name, this.type, this.address, this.universe){
    id = idCount++;
  }

    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          name == other.name &&
          type == other.type &&
          address == other.address;

}