import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/vertical_slider.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/blizzard_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';

class GeneralFader extends StatefulWidget {

  GeneralFader();

  @override
  createState() => GeneralFaderState();
}


class GeneralFaderState extends State<GeneralFader> {
  String name;
  double value;


  GeneralFaderState();

  @override
  initState() {
    super.initState();
    value = 0;
    name = "Test";
  }

Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: FaderButton(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                )
              ),
              primaryColor: Colors.red,
            )
          ),
          (value != 0) ?
          Expanded(
            child: FaderButton(
              child: Text(
                "Blackout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                )
              ),
              primaryColor: Colors.black,
              onTap: (){
                setState((){
                  value = 0;
                });
              },
            )
          ) :
          Expanded(
            child: FaderButton(
              child: Text(
                "Full",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                )
              ),
              primaryColor: Colors.red,
              onTap: (){
                setState((){
                  value = 255;
                });
              },
            )
          ),
          Expanded(
            flex: 8,
            child: BlizzardFader(
              activeColor: Colors.red,
              inactiveColor: Colors.black,
              callback: (newValue){
                setState(() {
                  value = newValue;          
                });
              },
              max: 255,
              value: value,
            )
          ),
        ]
      )
    );
  }
}
