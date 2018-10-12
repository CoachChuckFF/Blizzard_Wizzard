import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/models/show.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_list_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_list_area.dart';

class EditorScreen extends StatefulWidget {
  @override
  createState() => EditorScreenState();
}

class EditorScreenState extends State<EditorScreen> {
  String tempShow;
  Key _sceneKey;
  int _keyIndex;

  @override
  void initState() {
    super.initState();

    _keyIndex = 0;
    _sceneKey = Key("SCENE_KEY_${_keyIndex++}");
    tempShow = "Hello world!";
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
                        child: StoreConnector<AppState, Show>(
                          converter: (store) => store.state.show,
                          builder: (context, show) {
                            return CueListArea(
                              cues: show.cues,
                              startIndex: show.currentCue,
                              callback: (index){
                                setState(() {
                                  StoreProvider.of<AppState>(context).dispatch(SetCurrentCue(index));
                                  _sceneKey = Key("SCENE_KEY_${_keyIndex++}");
                                });
                              },
                            );
                          },
                        ),
                      )
                    )
                  ]
                )
              ),
              Expanded(
                flex: 6,
                child: StoreConnector<AppState, Show>(
                  key: _sceneKey,
                  converter: (store) => store.state.show,
                  builder: (context, show) {
                    return SceneListArea(
                      scenes: (show.cues.length == 0) ? null : show.cues[show.currentCue].scenes,
                      cueIndex: show.currentCue,
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
