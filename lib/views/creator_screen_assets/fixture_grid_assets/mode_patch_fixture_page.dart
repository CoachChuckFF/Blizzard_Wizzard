import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/ws_fixtures.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/controllers/fixture_manager.dart';

class ModePatchFixturePage extends StatelessWidget {
 
  final ValueChanged<int> callback;
  final Fixture fixture;

  ModePatchFixturePage({this.callback, this.fixture});

  Widget build(BuildContext context) {
    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Channel Mode",
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
            callback(PatchFixtureState.library);
          }
        ),
      ],
      content: Column(
        children: <Widget>[
          Tooltip(
            message: (fixture.brand == "Blizzard Lighting" ||
            fixture.brand == "Blizzard Pro") ? 
              "Proudly crafted by ${fixture.brand}" :
              "Made by ${fixture.brand}",
            preferBelow: false,
            child: ListTile(
              selected: true,
              title: Text(
                fixture.name,
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fixture.profile.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Text(
                      fixture.profile[index].name,
                      style: TextStyle(
                        fontSize: 21.0,
                      )
                    ),
                    onTap: (){
                      fixture.channelMode = index;
                      callback(PatchFixtureState.patchFromLibrary);
                    },
                  )
                );
              }
            ),
          )
        ]
      ),
    );
  }
}

