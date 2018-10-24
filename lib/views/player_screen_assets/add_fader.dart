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

class AddFader extends StatelessWidget {
  final int index;

  AddFader(this.index);

  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: BlizzardSizes.vertSliderPadding * 2 + BlizzardSizes.vertSliderThumb,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FaderButton(
                child: Text(
                  "S$index",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  )
                ),
                primaryColor: Colors.blue,
              )
            ),
            Expanded(
              flex: 13,
              child: Center(
                child: IconButton(
                  iconSize: 50.0,
                  color: Colors.blue,
                  icon: Icon(
                    Icons.add_box,
                  ),
                  onPressed: (){
                    print("Tap");
                  },
                ),
              )
            )
          ],
        ),
      )
    );
  }
}