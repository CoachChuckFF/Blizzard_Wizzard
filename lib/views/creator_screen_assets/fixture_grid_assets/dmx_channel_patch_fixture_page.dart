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

class DMXChannelPatchFixturePage extends StatefulWidget {
 
  final ValueChanged<int> callback;
  final Fixture fixture;

  DMXChannelPatchFixturePage({this.callback, this.fixture});

  @override
  createState() => DMXChannelPatchFixturePageState();
}


class DMXChannelPatchFixturePageState extends State<DMXChannelPatchFixturePage> {
  int channels = 1;


  @override
  initState() {
    super.initState();
    channels = 1;
    if(widget.fixture.profile.length == 0){
      widget.fixture.profile = List<ChannelMode>()..add(ChannelMode());
    } else if(widget.fixture.profile.first.channels.length != 0){
      channels = widget.fixture.profile.first.channels.length;
    }
  }

  Widget build(BuildContext context) {
    return ListViewAlertDialog(
      title: Text('Patch-a-Fixture - Channels',
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
                    "How many DMX channels does this fixture require?",
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
            child: Card(
                child: NumberPicker.integer(
                listViewWidth: double.infinity,
                initialValue: channels,
                minValue: 1,
                maxValue: 512,
                onChanged: (channels){
                  setState(() {
                    this.channels = channels;               
                  });
                })
            ),
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
                          widget.callback(PatchFixtureState.main);
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
                          widget.fixture.channelMode = 0;
                          widget.fixture.profile.first.name = "$channels Channel Mode";
                          widget.fixture.profile.first.channels = List<Channel>(channels);

                          widget.callback(PatchFixtureState.manufacturer);
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
                    widget.callback(PatchFixtureState.exit);
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