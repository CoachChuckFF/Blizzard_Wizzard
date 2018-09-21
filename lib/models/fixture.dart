class Fixture{

  static int idCount = 1;

  String name;
  String brand;

  List<ChannelMode> profile;
  int patchAddress = 1;
  int channelMode = 0;

  ChannelMode getCurrentChannels(){
    return this.profile[this.channelMode];
  }

  Fixture({this.name, this.profile = const <ChannelMode>[],
    this.patchAddress, this.channelMode, this.brand}){

  }

  bool compare(Fixture other){
    return (name == other.name);
  }

  @override
  bool operator == (Object other) =>
      other is Fixture &&
        other.name == name;
}

class ChannelMode{
  String name;
  List<Channel> channels;

  ChannelMode({this.name, this.channels = const <Channel>[]});

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

  Channel({this.name, this.number, this.segments = const<Segment>[]});
}

class Segment{
  String name;
  int start;
  int end;
  
  Segment({this.name, this.start, this.end});
}