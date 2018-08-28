import 'dart:io';
import 'dart:typed_data';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';

class Fixture{

  static int idCount = 1;

  Mac mac;
  String name;
  bool isBlizzard;
  bool isConnected;

  int patchAddress = 1;
  int universe;
  int id = 0;

  ByteData dmx = ByteData(512);
  List<int> redChannels;
  List<int> greenChannels;
  List<int> blueChannels;
  List<int> uvChannels;

  Fixture(List<int> mac, {this.id, this.name, this.redChannels, 
    this.blueChannels, this.greenChannels, this.uvChannels, this.universe, 
    this.isConnected, this.patchAddress}){
    if(this.id == 0){
      this.id = idCount++;
    } else {
      if(this.id >= idCount){
        idCount = this.id + 1;
      }
    }

    if(redChannels == null){
      redChannels = List<int>();
    }

    if(greenChannels == null){
      greenChannels = List<int>();
    }

    if(blueChannels == null){
      blueChannels = List<int>();
    }

    if(uvChannels == null){
      uvChannels = List<int>();
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