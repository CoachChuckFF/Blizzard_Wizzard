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
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/cue_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/dmx_fader.dart';

class MainPatchFaderPage extends StatelessWidget {
  final ValueChanged<int> callback;
  final int index;

  MainPatchFaderPage({this.callback, this.index});

  Widget build(BuildContext context) {
    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Patch Fader $index",
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
          text: "Cancel",
          color: Colors.blue,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              child: InkWell(
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.subscriptions,
                      size: 50.0,
                    ),
                    title: Text(
                      "Patch Cue",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  )
                ),
                onTap: (){
                  callback(PatchFaderState.cue);
                },
              )
            ),
          ),
          Expanded(
            child: Card(
              child: InkWell(
                child:Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.timeline,
                      size: 50.0,
                    ),
                    title: Text(
                      "Patch DMX Channels",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  callback(PatchFaderState.devices);
                },
              ),
            )
          ),
        ]
      )
    );
  }
}