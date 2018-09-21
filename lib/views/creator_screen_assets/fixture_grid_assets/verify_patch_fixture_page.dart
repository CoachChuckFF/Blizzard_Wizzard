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
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class VerifyPatchFixturePage extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final ValueChanged<int> callback;
  final Fixture fixture;

  VerifyPatchFixturePage({this.callback, this.fixture});

  Widget build(BuildContext context) {

      child: ListViewAlertButtonsDialog(
        title: Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Verify everything looks right",
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
              callback(PatchFixtureState.firstChannel);
            }
          ),
          BlizzardDialogButton(
            text: "Save",
            color: Colors.green,
            onTap: (){
              if(_submit()){
                callback(PatchFixtureState.patch);
              }
            }
          ),
        ],
        content: ListView(
          children: <Widget>[
            Card(
              child: Text(fixture.name)
            ),
            Card(
              child: Text(fixture)
            )
          ]
        ),
      );

  }
}

