import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/dmx_fader.dart';

class ChannelsPatchFaderPage extends StatefulWidget {
  final Color color;
  final List<int> channels;
  final ValueChanged<int> callback;
  final String name;

  ChannelsPatchFaderPage({this.color,this.name, this.callback, this.channels});

  @override
  createState() => ChannelsPatchFaderPageState();
}

class ChannelsPatchFaderPageState extends State<ChannelsPatchFaderPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Select Channels for ${widget.name}",
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
            widget.callback(PatchFaderState.devices);
          }
        ),
        BlizzardDialogButton(
          text: "Patch",
          color: Colors.green,
          onTap: (){
            widget.channels.sort();
            widget.callback(PatchFaderState.submit);
          },
          onLongPress: (){
            widget.channels.sort();
            widget.callback(PatchFaderState.submitAll);
          },
        ),
      ],
      content: GridView.count(
        crossAxisCount: 4,
        children: List.generate(512, (index){
          index++;
          bool isSelected = widget.channels.contains(index);
          return FaderButton(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: (isSelected) ? Colors.white : Colors.black,
                  fontSize: 21.0,
                )
              ),
            ),
            primaryColor: (isSelected) ? widget.color: Colors.white,
            onTap: (){
              if(isSelected){
                widget.channels.remove(index);
              } else {
                widget.channels.add(index);
              }
              setState(() {});
            },
            onDoubleTap: (){
              if(isSelected){
                widget.channels.clear();
              } else {
                widget.channels.clear();
                for(int i = 1; i < 513; i++){
                  widget.channels.add(i);
                }
              }
              setState(() {});
            },
          );
        })
      )
    );
  }
}
