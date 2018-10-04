import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/channel_type.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/controllers/fixture_manager.dart';

class VerifyPatchFixturePage extends StatefulWidget {
  final ValueChanged<int> callback;
  final Fixture fixture;

  VerifyPatchFixturePage({this.callback, this.fixture});

  @override
  createState() => VerifyPatchFixturePageState();

}

class VerifyPatchFixturePageState extends State<VerifyPatchFixturePage> {
  List<bool> showSegments;

  @override
  initState() {
    super.initState();
    showSegments = List<bool>.filled(widget.fixture.profile.first.channels.length, false);

  }

  Widget build(BuildContext context) {

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Verify everything looks right!",
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
            widget.callback(PatchFixtureState.firstChannel);
          }
        ),
        BlizzardDialogButton(
          text: "Save",
          color: Colors.green,
          onTap: (){
            sid.saveUserFixture(widget.fixture);
            widget.callback(PatchFixtureState.patchFromCreate);
          }
        ),
      ],
      content: ListView(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Type:",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.fixture.name,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 21.0,
                          )
                        ),
                      ),
                    ]
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Brand:",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.fixture.brand,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 21.0,
                          )
                        ),
                      ),
                    ]
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Channels:",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.fixture.profile.first.channels.length.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 21.0,
                          )
                        ),
                      ),
                    ]
                  )
                ),
              ]
            )
          ),
          Card(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.fixture.profile.first.channels.length,
              itemBuilder: (BuildContext context, int index) {
                Channel channel = widget.fixture.profile.first.channels[index];
                ChannelType channelType = ChannelTypes.getTypeFromName(channel.name);

                if(showSegments[index] && channel.segments.length != 0){
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color: channelType.color,
                            shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              )
                            )
                          )
                        ),
                        title: Text(
                          "${channel.name}",
                          style: TextStyle(

                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_drop_up,
                          ),
                          onPressed: (){
                            setState(() {
                              showSegments[index] = false;                      
                            });
                          },
                        ),
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: widget.fixture.profile.first.channels[index].segments.length,
                        itemBuilder: (BuildContext context, int jndex) {
                          Segment segment = channel.segments[jndex];
                          return ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container()
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Tooltip(
                                    message: segment.name,
                                    preferBelow: false,
                                    child: Text(
                                      segment.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Tooltip(
                                        message: "Start Value",
                                        child: Text(
                                          segment.start.toString(),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Tooltip(
                                        message: "End Value",
                                        child: Text(
                                          segment.end.toString(),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ]
                            ),
                          );
                        }
                      )
                    ],
                  );
                } else {
                  return ListTile(
                    leading: Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        color: channelType.color,
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          )
                        )
                      )
                    ),
                    title: Text(
                      "${channel.name}",
                      style: TextStyle(

                      ),
                    ),
                    trailing: (channel.segments.length != 0) ?
                    IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                      ),
                      onPressed: (){
                        setState(() {
                          showSegments[index] = true;                      
                        });
                      },
                    ) : null
                  );
                }
              }
            ),
          )
        ],
      ),
    );
  }
}

