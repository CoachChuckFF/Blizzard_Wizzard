import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/views/items/available_device_items/available_device_list.dart';
import 'package:blizzard_wizzard/views/screens/config_wizzard_screen.dart';
import 'package:blizzard_wizzard/views/items/controller_items/fixture_grid.dart';
import 'package:blizzard_wizzard/views/items/controller_items/scene_button_bar.dart';
import 'package:blizzard_wizzard/views/items/controller_items/scene_config_area.dart';
import 'package:blizzard_wizzard/views/items/controller_items/config_button_bar.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:lw_color_picker/lw_color_picker.dart';


class ControllerScreen extends StatefulWidget {
  @override
  createState() => ControllerScreenState();
}

class ControllerScreenState extends State<ControllerScreen> {
  int configState;
  final int pageState = PageState.sceneCreateState;

  @override
    void initState() {
      super.initState();
      configState = LightingConfigState.colorState;
    }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold (
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('Blizzard Pro'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.lightbulb_outline),
            
            tooltip: 'Connected Devices',
            onPressed: ()=>print("thing"),
          ),
          new IconButton(
            icon: new Icon(Icons.add),
            color: (pageState == PageState.sceneCreateState) ?
              Colors.deepPurpleAccent : Colors.white,
            tooltip: 'Scene Maker',
            onPressed: ()=>print("thing"),
          ),
          new IconButton(
            icon: new Icon(Icons.edit),
            tooltip: 'Scene Editor',
            onPressed: ()=>print("thing"),
          ),
          new IconButton(
            icon: new Icon(Icons.play_circle_outline),
            tooltip: 'Player',
            onPressed: ()=>print("thing"),
          ),
          new IconButton(
            icon: new Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: ()=>print("thing"),
          ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool wide = (orientation == Orientation.landscape);

            return Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: PatchesCard(5),
                ),
                Expanded(
                  flex: 1,
                  child: SceneButtonBar(),
                ),
                Expanded(
                  flex: 1,
                  child: ConfigButtonBar(
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
                  child: SceneConfigArea(state: configState)
                )
              ],
            );
          },
        ), 
      ),
    );
  }

}
