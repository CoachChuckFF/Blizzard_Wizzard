import 'dart:typed_data';
import 'package:blizzard_wizzard/models/mac.dart';

class Fixture{

  static int idCount = 1;

  Mac mac;
  String name;
  bool isConnected;

  Profile profile;
  int patchAddress = 1;
  int universe = 1;
  int id = 0;


  Fixture(List<int> mac, {this.id, this.name, this.profile, this.universe, 
    this.isConnected, this.patchAddress}){
    if(this.id == null){
      this.id = idCount++;
    } else {
      if(this.id >= idCount){
        idCount = this.id + 1;
      }
    }

    this.mac = Mac(mac);
  }

  bool compare(Fixture other){
    return (name == other.name &&
            mac == other.mac);
  }

  @override
  bool operator == (Object other) =>
      other is Fixture &&
        other.mac == mac &&
        other.name == name &&
        other.id == id;

}

class Profile{
  final int redChannel;
  final int greenChannel;
  final int blueChannel;
  final int uvChannel;

  const Profile({this.redChannel = -1, this.greenChannel = -1, this.blueChannel = -1, this.uvChannel = -1});
}
