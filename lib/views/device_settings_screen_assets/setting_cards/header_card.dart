import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/color_picker_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/dmx_control_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/keypad.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/preset_area.dart';


class HeaderCard extends StatelessWidget {
  final String header;

  HeaderCard(
    this.header,
  );

@override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
        header,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Roboto",
          fontSize: 21.0,
          color: Theme.of(context).accentColor
        ),
      ),
    );
  }
}
