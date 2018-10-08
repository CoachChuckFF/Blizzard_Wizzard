import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_list_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_selector_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_list_area.dart';

class EditorScreen extends StatefulWidget {
  @override
  createState() => EditorScreenState();
}

class EditorScreenState extends State<EditorScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return SceneListArea();
    return Column(
      children: <Widget>[
        Expanded( //main lists
          flex: 13,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Theme(
                        data: ThemeData(
                          primarySwatch: Colors.green
                        ),
                        child: ShowSelectorArea(
                          name: "Hello World"  
                        ),
                      )
                    ),
                    Expanded(
                      flex: 13,
                      child: Theme(
                        data: ThemeData(
                          primarySwatch: Colors.red
                        ),
                        child: CueListArea(),
                      )
                    )
                  ]
                )
              ),
              Expanded(
                flex: 6,
                child: SceneListArea(
                  key: Key("Scenes")
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
