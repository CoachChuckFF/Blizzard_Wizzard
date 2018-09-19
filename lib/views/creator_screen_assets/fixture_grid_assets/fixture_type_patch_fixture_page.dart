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

class FixtureTypePatchFixturePage extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final ValueChanged<int> callback;
  final Fixture fixture;

  FixtureTypePatchFixturePage({this.callback, this.fixture});

  String _validate(String text){
    if(text == ""){
      return "Please enter in a name";
    }
    return null;
  }

   bool _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListViewAlertButtonsDialog(
        title: Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "What type of fixture is this?",
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
              callback(PatchFixtureState.manufacturer);
            }
          ),
          BlizzardDialogButton(
            text: "Next",
            color: Colors.green,
            onTap: (){
              if(_submit()){
                callback(PatchFixtureState.firstChannel);
              }
            }
          ),
        ],
        content: ListView(
          children: <Widget>[
            Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor 
                    ),
                    initialValue: fixture.name ?? "",
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Fixture Type",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.all(5.0)
                    ),
                    maxLength: BlizzardWizzardConfigs.longNameLength,
                    maxLengthEnforced: true,
                    validator: _validate,
                    onSaved: (text){
                      this.fixture.name = text;
                    },
                  ),
                )
              )
            )
          ]
        ),
      )
    );
  }
}

