import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class ColorProfile{
  final Color color;
  final Color splash;
  final String name;

  const ColorProfile(this.color, this.splash, this.name);
}

class ColorPresets{
  static const List<ColorProfile> presets = [
    const ColorProfile(Colors.red, Colors.redAccent, "Firetruck Red"),
    const ColorProfile(Colors.orange, Colors.orangeAccent, "Orange Orange"),
    const ColorProfile(Colors.yellow, Colors.yellowAccent, "Empire Yellow"),
    const ColorProfile(Colors.green, Colors.greenAccent, "Money Green"),
    const ColorProfile(Colors.cyan, Colors.cyanAccent, "Joel Blue"),
    const ColorProfile(Colors.blue, Colors.blueAccent, "Blizzard"),
    const ColorProfile(Colors.indigo, Colors.indigoAccent, "Indi Gogo"),
    const ColorProfile(Colors.purple, Colors.purpleAccent,"People Eater Purple"),
    const ColorProfile(Colors.black, Colors.white, "'Like My Soul' Black"),
    const ColorProfile(Colors.white, Colors.black, "Fresh Linen Scent"), 
  ]; 
}

class PresetGrid extends StatefulWidget {
  Map<Device, List<Fixture>> devices;

  PresetGrid({@required this.devices});

  @override
  createState() => PresetGridState();
}

class PresetGridState extends State<PresetGrid> {

  PresetGridState();

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
    widget.devices.keys.forEach((device){
      widget.devices[device].forEach((fixture){
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
