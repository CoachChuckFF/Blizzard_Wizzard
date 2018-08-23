import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:blizzard_wizzard/views/items/controller_items/config_button_bar.dart';
import 'package:blizzard_wizzard/views/items/config_items/config_cards/dmx_control_card.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:flutter/material.dart';
import 'package:lw_color_picker/lw_color_picker.dart';

class SceneConfigArea extends StatelessWidget {
  final int state;
  SceneConfigArea({
    @required this.state,
  });

@override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    switch(this.state){
      case LightingConfigState.colorState:
        return Center(
          child: Card(
            child: LWColorPicker(width: width * 0.89, heightToWidthRatio: 0.6,),
          ),
        );
      case LightingConfigState.dmxState:
        return DMXControlCard(
          Profile(
            [0x00,0x00,0x00,0x00,0x00,0x00]
          )..address = InternetAddress("192.168.1.1"),
          (string) => print(string)
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
