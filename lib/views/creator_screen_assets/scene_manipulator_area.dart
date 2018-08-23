import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lw_color_picker/lw_color_picker.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/dmx_control_area.dart';


class SceneManipulatorArea extends StatelessWidget {
  final int state;
  SceneManipulatorArea({
    @required this.state,
  });

@override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    /*TODO
      takeout
    */
    List<Fixture> testFixtures = List<Fixture>();
    testFixtures.add(Fixture(
            [0x00,0x00,0x00,0x00,0x00,0x00]
          )..address = InternetAddress("255.255.255.255"),
        );

    switch(this.state){
      case LightingConfigState.colorState:
        return Center(
          child: Card(
            child: LWColorPicker(width: width * 0.89, heightToWidthRatio: 0.6,),
          ),
        );
      case LightingConfigState.dmxState:
        return DMXControlArea(
          testFixtures
        );
      case LightingConfigState.settingsState:
        return Text("Keypad");
      case LightingConfigState.settingsState:
        return Text("Settings");
      default:
        return Text("Error");
    }
  }
}
