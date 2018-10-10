import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_list_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_list_area.dart';

class EditorScreen extends StatefulWidget {
  @override
  createState() => EditorScreenState();
}

class EditorScreenState extends State<EditorScreen> {
  String tempShow;
  int _cueIndex;

  @override
  void initState() {
    super.initState();

    _cueIndex = 2;

    tempShow = "Hello world!";
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
                        child: ShowArea(
                          name: tempShow,
                          nameChanged: (name){
                            setState(() {
                              if(name == null){
                                print("delete $tempShow");
                              } else {
                                tempShow = name; 
                              }                             
                            });
                          },  
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
                child: StoreConnector<AppState, List<Scene>>(
                  converter: (store) => (store.state.show.cues.length == 0) ?
                    null :
                    store.state.show.cues[_cueIndex].scenes,
                  builder: (context, scenes) {
                    return SceneListArea(
                      key: Key("Scenes"),
                      scenes: scenes,
                      cueIndex: _cueIndex,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
