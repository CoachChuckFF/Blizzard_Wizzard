import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class ChannelControlArea extends StatefulWidget {
  final List<Device> devices;

  ChannelControlArea({@required this.devices});

  @override
  createState() => ChannelControlAreaState(_populateChannels());
}

class ChannelControlAreaState extends State<ChannelControlArea> {
  List<String> channels;

  ChannelControlAreaState(this.channels);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          
          Expanded(
            child: GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
              itemCount: ColorPresets.presets.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 33.0,
                  child: Tooltip(
                    message: ColorPresets.presets[index].name,
                    child: RaisedButton(
                      color: ColorPresets.presets[index].color,
                      elevation: 5.0,
                      splashColor: ColorPresets.presets[index].splash,
                      onPressed: () {
                        _updateColor(ColorPresets.presets[index].color);
                      },
                    ),
                  )
                );
              },
            ) 
          )
        ],
      )
    );
  }

  void _updateColor(Color color){
    widget.devices.forEach((device){
      device.fixtures.forEach((fixture) {
        int redChannel, greenChannel, blueChannel, dimmerChannel;
      
        redChannel = fixture.getCurrentChannels().getChannelOffset("Red");
        greenChannel = fixture.getCurrentChannels().getChannelOffset("Green");
        blueChannel = fixture.getCurrentChannels().getChannelOffset("Blue");
        dimmerChannel = fixture.getCurrentChannels().getChannelOffset("Dimmer");

        if(redChannel != -1){
          device.dmxData.setDmxValue(redChannel + fixture.patchAddress, color.red);
        }
        if(greenChannel != -1){
          device.dmxData.setDmxValue(greenChannel + fixture.patchAddress, color.green);
        }
        if(blueChannel != -1){
          device.dmxData.setDmxValue(blueChannel + fixture.patchAddress, color.blue);
        }
        if(dimmerChannel != -1){
          device.dmxData.setDmxValue(dimmerChannel + fixture.patchAddress, (color.computeLuminance() * 255).toInt());
        }
      });
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });
  }

}
