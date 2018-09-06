import 'dart:typed_data';
import 'package:blizzard_wizzard/models/mac.dart';

class Fixture{

  static int idCount = 1;

  Mac mac;
  String name;
  String brand;
  bool isConnected;

  List<ChannelMode> profile;
  int patchAddress = 1;
  int channelMode = 0;
  int id = 0;

  ChannelMode getCurrentChannels(){
    return this.profile[this.channelMode];
  }

  Fixture(List<int> mac, {this.id, this.name, this.profile,
    this.isConnected, this.patchAddress, this.channelMode}){
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

class ChannelMode{
  String name;
  List<Channel> channels;

  ChannelMode({this.name, this.channels});

  /* Returns -1 on failure */
  int getChannelOffset(String name){
    if(this.channels != null){
      Channel temp = this.channels.firstWhere((channel){
        return channel.name == name;
      }, orElse: (){return null;});

      if(temp != null){
        return temp.number;
      }
    }
    return -1;
  }
}

class Channel{
  String name;
  int number;
  List<Segment> segments;

  bool hasSegments(){
    if(this.segments != null){
      if(this.segments.length != 0){
        return true;
      }
    }

    return false;
  }

  Channel({this.name, this.number, this.segments});
}

class Segment{
  String name;
  int start;
  int end;
  
  Segment({this.name, this.start, this.end});
}