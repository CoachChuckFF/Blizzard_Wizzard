import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class LibraryPatchFixturePage extends StatelessWidget {
 
  final ValueChanged<int> callback;

  LibraryPatchFixturePage({this.callback});

  Widget build(BuildContext context) {
    return ListViewAlertDialog(
      title: Text('Patch-a-Fixture - Library',
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
            flex: 1,
            child: Container()
          ),
          Expanded(
            flex: 8,
            child: Card(
              child: Center(
                child: Text("Game coming soon!"),
              )
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
                          callback(PatchFixtureState.main);
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
                          //TODO add next
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
    );
  }
}