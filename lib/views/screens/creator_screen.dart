import 'package:flutter/material.dart';
import 'package:lw_color_picker/lw_color_picker.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/dmx_control_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_button_bar.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_manipulator_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_manipulator_button_bar.dart';


class CreatorScreen extends StatefulWidget {
  @override
  createState() => CreatorScreenState();
}

class CreatorScreenState extends State<CreatorScreen> {
  int configState;

  @override
  void initState() {
    super.initState();
    configState = LightingConfigState.colorState;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: FixtureGrid(5),
        ),
        Expanded(
          flex: 1,
          child: SceneButtonBar(),
        ),
        Expanded(
          flex: 1,
          child: SceneManipulatorButtonBar(
            state: configState,
            callback: (state){
              setState(() {
                configState = state;                
              });
            },
          ),
        ),
        Expanded(
          flex: 6,
          child: SceneManipulatorArea(state: configState)
        )
      ],
    );

  }

}
