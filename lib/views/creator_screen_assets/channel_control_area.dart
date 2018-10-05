import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/channel_type.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class ChannelControlArea extends StatelessWidget {
  final Map<Device, List<Fixture>> devices;
  List<ChannelValue> channels;


  ChannelControlArea({this.devices});

  _updateChannels(Channel channel, int val){
    devices.keys.forEach((device){
      devices[device].forEach((fixture){
        int index = fixture.getCurrentChannels().channels.indexOf(channel);
        if(index != -1){
          device.dmxData.setDmxValue(fixture.getCurrentChannels().channels[index].number + fixture.patchAddress, val);
        }
      });
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });
  }

  _init(){
    bool first = true;

    channels = List<ChannelValue>();

    devices.values.forEach((fixtureList){
      fixtureList.forEach((fixture){
        if(first){
          first = false;
          fixture.getCurrentChannels().channels.forEach((channel){
            Device device = devices.keys.firstWhere((index){
              return devices[index] == fixtureList;
            });
            channels.add(ChannelValue(
              channel,
              device.dmxData.dmx[channel.number + fixture.patchAddress - 1],
            ));
          });
        } else {
          channels.removeWhere((channelName){
            return fixture.getCurrentChannels().channels.indexWhere((channel){
              return channelName.channel == channel;
            }) == -1;
          });
          channels.forEach((channelName){
            if(fixture.getCurrentChannels().channels.firstWhere((channel){return channel == channelName.channel;}) == null){
              channels.remove(channelName);
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    _init();
    print(channels);

    if(channels.length == 0){
      return Center(
        child: Text(
          "No Channels Possible"
        )
      );
    }

    return Card(
      child: ListView.builder(   
        itemCount: channels.length,
        itemBuilder: (BuildContext context, int index){

          return Card(
            child: ChannelSlider(
              value: channels[index].value,
              channel: channels[index].channel,
              callback: (val){
                _updateChannels(channels[index].channel, val);
              },
            )                        
          );
        },
      ),
    );
  }
}

class ChannelSlider extends StatefulWidget {
  final int value;
  final Channel channel;
  final ValueChanged<int> callback;

  ChannelSlider({this.value, this.callback, this.channel});

  @override
  createState() => ChannelSliderState();
}

class ChannelSliderState extends State<ChannelSlider> {
  int _value;
  ChannelType _type;

  @override
  initState(){
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    Segment segment = widget.channel.segments.firstWhere((seg){
      return (_value >= seg.start && _value <= seg.end);
    }, orElse: (){return null;});

    _type = ChannelTypes.getTypeFromName(widget.channel.name);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Center(
            child: Text(
            "${widget.channel.name} : $_value",
              style: TextStyle(
                fontSize: 18.0,
              )
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container()
            ),
            Expanded(
              flex: 8,
              child: Slider(
                max: 255.0,
                min: 0.0,
                divisions: 256,
                label: (segment == null) ?
                  _value.toString() : 
                  "$_value - ${segment.name}",
                value: _value.toDouble(),
                activeColor: _type.color,
                inactiveColor: _type.color.withOpacity(0.3),
                onChanged: (value){
                  if(value < 0.0){
                    _value = 0;
                  } else if(value >= 255.0){
                    _value = 255;
                  } else {
                    _value = value.truncate();
                  }

                  widget.callback(_value);
                  setState(() {});
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container()
            ),
          ]
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,10.0),
          child: Center(
            child: Text(
            (segment == null) ?
              "" : segment.name,
            ),
          ),
        )
      ],
    );
  }
}

class ChannelValue {
  final Channel channel;
  final int value;

  ChannelValue(this.channel, this.value);
}
