import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_list_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_selector_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/que_list_area.dart';

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
                      flex: 2,
                      child: ShowSelectorArea(),
                    ),
                    Expanded(
                      flex: 13,
                      child: QueListArea(),
                    )
                  ]
                )
              ),
              Expanded(
                flex: 5,
                child: SceneListArea(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
