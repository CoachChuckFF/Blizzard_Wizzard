import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_item.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_item.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_item.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class SceneSelectDialog extends StatefulWidget {
  final bool isLoad;
  final List<int> selectedDevices;
  final List<int> selectedFixtures;
  final ValueChanged<List<int>> callback;

  SceneSelectDialog({this.isLoad, this.selectedDevices, this.selectedFixtures, this.callback});

  @override
  createState() => SceneSelectDialogState();
}

class SceneSelectDialogState extends State<SceneSelectDialog> {
  int _state;
  int _cueIndex;

  void _handleSave(int index){
    List<SceneData> data = List<SceneData>();
    List<Mac> macs = List<Mac>();

    if(widget.selectedDevices == null){
      widget.selectedFixtures.forEach((key){
        macs.add(StoreProvider.of<AppState>(context).state.show.patchedFixtures[key].mac);
      });
    } else {
      widget.selectedDevices.forEach((key){
        macs.add(StoreProvider.of<AppState>(context).state.show.patchedDevices[key].mac);
      });
    }

    StoreProvider.of<AppState>(context).state.availableDevices.forEach((device){
      if(macs.contains(device.mac)){
        data.add(
          SceneData(
            device.mac,
            List.from(device.dmxData.dmx)
          )
        );
      }
    });

    if(_cueIndex == -1){
      StoreProvider.of<AppState>(context).dispatch(AddCue(
        Cue(
          scenes: List<Scene>()..add(
            Scene(
              sceneData: data
            )
          ) 
        )
      ));
      _cueIndex = StoreProvider.of<AppState>(context).state.show.cues.length - 1;
    } else if(index == -1){
      StoreProvider.of<AppState>(context).dispatch(AddScene(
        Scene(
          sceneData: data,
        ),
        _cueIndex,
      ));
    } else {
      StoreProvider.of<AppState>(context).dispatch(UpdateScene(
        StoreProvider.of<AppState>(context).state.show.cues[_cueIndex].scenes[index].copyWith(
          sceneData: data
        ),
        index,
        _cueIndex,
      ));
    }

    StoreProvider.of<AppState>(context).dispatch(SetCurrentCue(_cueIndex));
    Navigator.pop(context);
  }

  void _handleLoad(int index){
    List<int> selected = List<int>();

    StoreProvider.of<AppState>(context).state.show.cues[_cueIndex].scenes[index].sceneData.forEach((data){
      Device dev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device){
        return device.mac == data.mac;
      }, orElse: (){return null;});

      if(dev != null){

        if(widget.selectedDevices == null){
          StoreProvider.of<AppState>(context).state.show.patchedFixtures.forEach((key, value){
            if(value.mac == data.mac){
              selected.add(key);
            }
          });
        } else {
          StoreProvider.of<AppState>(context).state.show.patchedDevices.forEach((key, value){
            if(value.mac == data.mac){
              selected.add(key);
            }
          });
        }

        for(int i = 0; i < 512; i++){
          dev.dmxData.setDmxValue(i + 1, data.dmx[i]);
        }

        tron.server.sendPacket(dev.dmxData.udpPacket, dev.address);
      }

    });

    StoreProvider.of<AppState>(context).dispatch(SetCurrentCue(_cueIndex));
    widget.callback(selected);
    Navigator.pop(context);

  }

  ListView _buildCues(){
    List<String> cues = List<String>(); 
    
    StoreProvider.of<AppState>(context).state.show.cues.forEach((cue){
      cues.add(cue.name);
    });

    if(cues.length == 0){
      return ListView(
        children: <Widget>[
          Text("No Cues Available")
        ]
      );
    }

    return ListView.builder(
      itemCount: cues.length,
      itemBuilder: (context, index){
        return CueItem(
          cue: Cue(name: cues[index]),
          index: index,
          onTap: (index){
            setState((){
              _cueIndex = index;
              print(_cueIndex);
              _state = SelectSceneState.scene;
            });
          },
        );
      },
    );
  }

  ListView _buildScenes(){
    List<Scene> scenes = StoreProvider.of<AppState>(context).state.show.cues[_cueIndex].scenes;

    if(scenes.length == 0){
      return ListView(
        children: <Widget>[
          Text("No Scenes Available")
        ]
      );
    }

    return ListView.builder(
      itemCount: scenes.length,
      itemBuilder: (context, i){
        print(i);
        return SceneItem(
          scene: scenes[i],
          onTap: (val){
            print(i);
            if(widget.isLoad){
              _handleLoad(i);
            } else {
              _handleSave(i);
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _cueIndex = -1;
    _state = SelectSceneState.cue;
  }

  Widget build(BuildContext context) {

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                (!(!widget.isLoad && _state == SelectSceneState.scene)) ? Container() :
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                    ),
                    onPressed: (){
                      setState(() {
                        _state = SelectSceneState.cue;
                        _cueIndex = -1;
                      });
                    },
                  )
                ),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      "Select ${(_state == SelectSceneState.cue) ? 'Cue' : 'Scene'} to ${(widget.isLoad) ? 'Load' : 'Save'}",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ), 
                (widget.isLoad) ? Container() :
                Expanded(
                  flex: 1,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30.0,
                      ),
                      onPressed: (){
                        _handleSave(-1);
                      },
                    )
                  )
                )
              ],
            )
          )
        )
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Cancel",
          color: Colors.blue,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
      ],
      content: (_state == SelectSceneState.cue) ? 
        _buildCues() : _buildScenes(),
    );
  }
}