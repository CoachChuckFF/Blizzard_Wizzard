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
import 'package:blizzard_wizzard/views/fixes/list_view_alert_dialog.dart';

class ManufacturerPatchFixturePage extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final ValueChanged<int> callback;
  final Fixture fixture;

  ManufacturerPatchFixturePage({this.callback, this.fixture});

  String _validate(String text){
    return "Hi";
  }

   void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  Widget build(BuildContext context) {
    return Form(
      child: ListViewAlertDialog(
        title: Text('Patch-a-Fixture - Manufacturer',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Robot",
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Card(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Who is the Manufacturer of this device",
                      style: TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                  )
                )
              ),
            ),    
            Expanded(
              flex: 6,
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Blizzard Pro",
                  labelText: "Manufacturer Name",
                  isDense: true,
                ),
                maxLength: BlizzardWizzardConfigs.longNameLength,
                maxLengthEnforced: true,
                validator: _validate,
                onSaved: (name){},
              ),
            ),  
            Expanded(
              flex: 1,
              child: Container()
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Colors.red,
                      child: Container(
                        child: InkWell(
                          child: Center(
                            child: Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: "Robot",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: (){
                            callback(PatchFixtureState.dmxChannels);
                          },
                        ),
                      )
                    )
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.green,
                      child: Container(
                        child: InkWell(
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: "Robot",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: (){
                            _submit();
                          },
                        ),
                      )
                    )
                  )
                ]
              )
            ),
            Expanded(
              flex: 1,
              child: Material(
                color: Colors.blue,
                child: Container(
                  child: InkWell(
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontFamily: "Robot",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: (){
                      callback(PatchFixtureState.exit);
                    },
                  ),
                )
              )
            ),
          ]
        )
      ),
    );
  }
}

