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

class DevicesPatchFaderPage extends StatefulWidget {
  final List<Device> devices;
  final ValueChanged<int> callback;
  final List<Mac> macs;
  final int index;

  DevicesPatchFaderPage({this.callback, this.index, this.devices, this.macs});

  @override
  createState() => DevicesPatchFaderPageState();
}

class DevicesPatchFaderPageState extends State<DevicesPatchFaderPage> {


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
              "Select Devices",
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
            widget.callback(PatchFaderState.main);
          }
        ),
        BlizzardDialogButton(
          text: "Next",
          color: Colors.green,
          onTap: (){
            widget.callback(PatchFaderState.channels);
          }
        ),
      ],
      content: ListView.builder(
        itemCount: widget.devices.length,
        itemBuilder: (context, index){

          bool isSelected = widget.macs.contains(widget.devices[index].mac);

          return FaderButton(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                widget.devices[index].name,
                style: TextStyle(
                  color: (isSelected) ? Colors.white : Colors.black,
                  fontSize: 21.0,
                )
              ),
            ),
            primaryColor: (isSelected) ? Colors.blue : Colors.white,
            onTap: (){
              if(isSelected){
                widget.macs.remove(widget.devices[index].mac);
              } else {
                widget.macs.add(widget.devices[index].mac);
              }
              setState(() {});
            },
            onDoubleTap: (){
              if(isSelected){
                widget.macs.clear();
              } else {
                widget.devices.forEach((dev){
                  if(!widget.macs.contains(dev.mac)){
                    widget.macs.add(dev.mac);
                  }
                });
              }
              setState(() {});
            },
          );
        }
      )
    );
  }
}
