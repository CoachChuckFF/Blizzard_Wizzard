import 'dart:io';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/models/models.dart';

class Profile{

  static int idCount = 0;

  final String name;
  final int typeId;
  final InternetAddress address;
  final bool isBlizzard;

  int universe;
  int id;
  int channelMode = 0;
  int activeTick = BlizzardWizzardConfigs.availableTimoutTick;

  Profile(this.name, this.typeId, this.address, this.isBlizzard, this.universe){
    id = idCount++;
  }

    @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is Profile &&
          name == other.name &&
          typeId == other.typeId &&
          address == other.address;

}