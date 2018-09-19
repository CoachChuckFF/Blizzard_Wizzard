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

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "How many DMX channels does this fixture require?",
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
            widget.callback(PatchFixtureState.main);
          }
        ),
        BlizzardDialogButton(
          text: "Next",
          color: Colors.green,
          onTap: (){
            widget.fixture.channelMode = 0;
            widget.fixture.profile.first.name = "$channels Channel Mode";
            widget.fixture.profile.first.channels = List<Channel>(channels);

            widget.callback(PatchFixtureState.manufacturer);
          }
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              child: Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.copyWith(
                    headline: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold
                    ),
                    body1: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    )
                  )
                ),
                child: NumberPicker.integer(
                listViewWidth: double.infinity,
                itemExtent: 100.0,
                initialValue: channels,
                minValue: 1,
                maxValue: 512,
                onChanged: (channels){
                  setState(() {
                    this.channels = channels;               
                  });
                }),
              )
            ),
          ),  
        ]
      )
    );
  }
}