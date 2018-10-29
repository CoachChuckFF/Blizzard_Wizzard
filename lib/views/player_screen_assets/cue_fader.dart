import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_item.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/blizzard_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';
import 'package:blizzard_wizzard/controllers/playback_manager.dart';

class CueFader extends StatefulWidget {
  final Cue cue;
  final Color activeColor = Colors.deepOrange;
  final Color inactiveColor = Colors.black;
  final int index;
  CueFader({this.index, this.cue});

  createState() => CueFaderState();
}

class CueFaderState extends State<CueFader> {
  String name;
  LightPlayer _player;
  int _sceneIndex;
  bool pause;
  double value;

  CueFaderState();

  @override
  initState() {
    super.initState();
    value = 0;
    name = "Cue";
    pause = true;
    _sceneIndex = 0;
    _player = LightPlayer(widget.cue.scenes);
  }

  @override
  dispose() {
    super.dispose();
    _player.pause();
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
                onTap: (){
                  showDialog(
                    context: context,
                    child: CueFaderDialog(
                      cue: widget.cue,
                      sceneIndex: _sceneIndex,
                      callback: (val){
                        if(val == -1){
                          StoreProvider.of<AppState>(context).dispatch(UnpatchCueFader(
                            widget.index,
                          ));
                          return;
                        }
                        setState(() {
                          _sceneIndex = val;  
                          _player.setIndex(_sceneIndex);                        
                        });
                      },
                    ),
                  );
                },
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
                onTap: (){
                  _player.prev();
                },
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
                onTap: (){
                  _player.next();
                },
              )
            ),
            Expanded(
              child: FaderButton(
                child: Icon(
                  (!pause) ?
                  Icons.pause:
                  Icons.play_arrow,
                  color: Colors.white
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  if(pause){
                    _player.play();
                  } else {
                    _player.pause();
                  }
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
                  _player.reset();
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
                  "look 1",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
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

class CueFaderDialog extends StatelessWidget {
  final ValueChanged<int> callback;
  final Cue cue;
  final int cueId;
  final int sceneIndex;

  CueFaderDialog({this.callback, this.cue, this.cueId, this.sceneIndex});

  Widget build(BuildContext context) {

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              (cue == null) ? "Cue is with the Ether" : cue.name,
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
        (cue == null) ? Container() :
        BlizzardDialogButton(
          text: "Cancel",
          color: Colors.blue,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
        BlizzardDialogButton(
          text: "Unpatch",
          color: Colors.red,
          onTap: (){
            callback(-1);
            Navigator.of(context).pop();
          }
        ),
      ],
      content: (cue == null) ? Container() :
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: cue.scenes.length,
              itemBuilder: _buildSceneList
            ),
          ),
        ]
      )
    );
  }

  Widget _buildSceneList(BuildContext context, int index){
    return SceneItem(
      scene: cue.scenes[index],
      selected: index == sceneIndex,
      onTap: (val){
        if(index != sceneIndex){
          callback(index);
          Navigator.of(context).pop();
        }
      },
    ); 
  }
}