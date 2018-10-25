import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/dmx_fader.dart';

class CuePatchFaderPage extends StatelessWidget {
  final List<Cue> cues;
  final ValueChanged<int> callback;
  final int index;

  CuePatchFaderPage({this.callback, this.index, this.cues});

  Widget build(BuildContext context) {
    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Select Cue",
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        )
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Back",
          color: Colors.red,
          onTap: (){
            callback(-1);
          }
        ),
      ],
      content: ListView.builder(
        itemCount: cues.length,
        itemBuilder: (context, index){
          return FaderButton(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                cues[index].name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                )
              ),
            ),
            onTap: (){
              callback(cues[index].id);
            },
          );
        }
      )
    );
  }
}