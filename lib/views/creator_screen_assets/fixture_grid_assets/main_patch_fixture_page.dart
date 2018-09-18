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

class MainPatchFixturePage extends StatelessWidget {
 
  final ValueChanged<int> callback;

  MainPatchFixturePage({this.callback});

  Widget build(BuildContext context) {
    return ListViewAlertDialog(
      title: Text('Patch-a-Fixture',
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
            flex: 4,
            child: Card(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.library_books,
                    size: 50.0,
                  ),
                  title: Text(
                    "Play the 'Can you find the correct fixture profile?' Game!",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: (){
                    callback(PatchFixtureState.library);
                  },
                )
              )
            ),
          ),
          Expanded(
            flex: 4,
            child: Card(
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.create,
                    size: 50.0,
                  ),
                  title: Text(
                    "Create and save a new fixture from scratch! - It's fun!",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: (){
                    callback(PatchFixtureState.dmxChannels);
                  },
                ),
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Container()
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