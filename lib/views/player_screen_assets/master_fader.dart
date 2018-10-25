import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/vertical_slider.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/blizzard_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';

class MasterFader extends StatefulWidget {
  final double value;
  final double max;

  MasterFader({this.value = 0, this.max = 255});

  @override
  createState() => MasterFaderState();
}


class MasterFaderState extends State<MasterFader> {
  double _value;

  MasterFaderState();

  @override
  initState() {
    super.initState();
    _value = (widget.value >= widget.max) ? widget.max : widget.value;
  }

  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: FaderButton(
              child: Text(
                "MF",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                )
              ),
              primaryColor: Colors.red,
            )
          ),
          (_value != 0) ?
          Expanded(
            child: FaderButton(
              child: Text(
                "Zero",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold
                )
              ),
              primaryColor: Colors.red,
              onTap: (){
                setState((){
                  _value = 0;
                });
              },
            )
          ) :
          Expanded(
            child: FaderButton(
              child: Text(
                "Full",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                )
              ),
              primaryColor: Colors.red,
              onTap: (){
                setState((){
                  _value = widget.max;
                });
              },
            )
          ),
          Expanded(
            flex: 11,
            child: BlizzardFader(
              activeColor: Colors.red,
              inactiveColor: Colors.black,
              callback: (newValue){
                setState(() {
                  _value = newValue; 
                  print(_value);         
                });
              },
              max: widget.max,
              value: _value,
            )
          ),
          Expanded(
            child: FaderButton(
              child: Text(
                "${(_value/widget.max*100).truncate()}%",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                )
              ),
              primaryColor: Colors.red,
            )
          ),
        ]
      )
    );
  }
}
