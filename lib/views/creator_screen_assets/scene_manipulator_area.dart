import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/channel_control_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/color_picker_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/dmx_control_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/keypad.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/preset_area.dart';


class SceneManipulatorArea extends StatelessWidget {
  final int state;
  final List<Device> devices;
  final Map<Device, List<Fixture>> deviceMap;

  SceneManipulatorArea({
    @required this.state,
    this.devices,
    this.deviceMap,
  });

@override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    StoreProvider.of<AppState>(context);

    switch(this.state){
      case LightingConfigState.color:
        return Center(
          child: Card(
            child: ColorPickerArea(
              width: width * 0.8, 
              heightToWidthRatio: 0.5,
              devices: this.deviceMap,
            ),
          ),
        );
      case LightingConfigState.preset:
        return PresetGrid(devices: this.deviceMap,);
      case LightingConfigState.dmx:
        return DMXControlArea(devices: this.devices);
      case LightingConfigState.keypad:
        return KeypadArea(devices: this.devices);
      case LightingConfigState.channels:
        return ChannelControlArea(devices: this.deviceMap);
      case LightingConfigState.settings:
        return Text("Settings");
      default:
        return Text("Error");
    }
  }
}
