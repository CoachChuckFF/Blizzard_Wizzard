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

class CueFader extends StatefulWidget {
  final Color activeColor = Colors.deepOrange;
  final Color inactiveColor = Colors.black;

  CueFader();

  createState() => CueFaderState();
}


class CueFaderState extends State<CueFader> {
  String name;
  bool pause;
  double value;

  CueFaderState();

  @override
  initState() {
    super.initState();
    value = 0;
    name = "Cue";
    pause = true;
  }

  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: BlizzardSizes.vertSliderPadding*2 + BlizzardSizes.vertSliderThumb,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FaderButton(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  )
                ),
                primaryColor: widget.activeColor,
              )
            ),
            Expanded(
              child: FaderButton(
                child: Text(
                  "<",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34.0,
                  )
                ),
                primaryColor: widget.activeColor,
              )
            ),
            Expanded(
              child: FaderButton(
                child: Text(
                  ">",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34.0,
                  )
                ),
                primaryColor: widget.activeColor,
              )
            ),
            Expanded(
              child: FaderButton(
                child: Icon(
                  (pause) ?
                  Icons.pause:
                  Icons.play_arrow,
                  color: Colors.white
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  setState((){
                    pause = !pause;
                  });
                },
              )
            ),
            Expanded(
              child: FaderButton(
                child: Text(
                  "Reset",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  )
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  setState((){
                    value = 0;
                  });
                },
              )
            ),
            Expanded(
              flex: 8,
              child: BlizzardFader(
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                callback: (newValue){
                  setState(() {
                    value = newValue;          
                  });
                },
                max: 255,
                value: value,
              )
            ),
            Expanded(
              child: FaderButton(
                child: Text(
                  "${(value/(BlizzardWizzardConfigs.dmxMaxChannelValue)*100).truncate()}%",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  )
                ),
                primaryColor: widget.activeColor,
              )
            ),
          ]
        )
      )
    );
  }
}
