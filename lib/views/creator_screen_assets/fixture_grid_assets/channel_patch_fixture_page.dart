import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/channel_type.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/channel_type_picker.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class ChannelPatchFixturePage extends StatefulWidget {
 
  final ValueChanged<int> callback;
  final Fixture fixture;
  final int index;

  ChannelPatchFixturePage({this.callback, this.fixture, this.index});

  @override
  createState() => ChannelPatchFixturePageState();
}


class ChannelPatchFixturePageState extends State<ChannelPatchFixturePage> {
  ChannelTypeReturnValue channelType;

  @override
  initState() {
    int typeIndex;
    super.initState();

    if(widget.fixture.profile.first.channels[widget.index] == null){
      widget.fixture.profile.first.channels[widget.index] = Channel(number: widget.index);
      typeIndex = 0;
    } else {
      typeIndex = ChannelTypes.getIndexFromName(widget.fixture.profile.first.channels[widget.index].name);
    }

    channelType = ChannelTypeReturnValue.copyFromType(ChannelTypes.types[typeIndex], typeIndex);
  }

  Widget build(BuildContext context) {

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Configure Channel ${widget.index + 1}",
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
            widget.callback((widget.index == 0) ? 
            PatchFixtureState.fixtureType : 
            PatchFixtureState.prevChannel);
          }
        ),
        BlizzardDialogButton(
          text: "Next",
          color: Colors.green,
          onTap: (){

            widget.callback(
              (widget.index >= widget.fixture.profile.first.channels.length - 1) ?
              PatchFixtureState.verify : 
              PatchFixtureState.nextChannel
            );
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
                  initialValue: (channelType.needsName) ? 
                    (widget.fixture.profile.first.channels[widget.index].name ?? "Channel ${widget.index + 1}") :
                    channelType.name,
                  enabled: channelType.needsName,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: (channelType.needsName) ? Theme.of(context).primaryColor : Colors.grey
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Channel Name",
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.all(5.0)
                  ),
                  maxLength: BlizzardWizzardConfigs.longNameLength,
                  maxLengthEnforced: true,
                  validator: (string){return null;},
                  onSaved: (text){
                    widget.fixture.brand = text;
                  },
                ),
              )
            )
          ),
          ChannelTypePicker.integer(
            initialValue: channelType.index,
            onChanged: (channelType){
              setState(() {
                this.channelType = channelType;   
              });
            },
          )
        ]
      )
    );
  }
}