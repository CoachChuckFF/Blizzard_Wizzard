import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class SceneManipulatorButtonBar extends StatefulWidget {
  final ValueChanged<int> callback;
  final int state;

  SceneManipulatorButtonBar({
    this.callback,
    this.state: LightingConfigState.colorState,
  });

  @override
  createState() => SceneManipulatorButtonBarState();
}

class SceneManipulatorButtonBarState extends State<SceneManipulatorButtonBar> {
  int state;

  _update(int state){
    setState(() {
      this.state = state; 
      if(widget.callback != null){
        widget.callback(state);
      }
    });
  }

  @override
  initState() {
    super.initState();
    state = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.colorState) ?
                Colors.deepPurpleAccent : Colors.white,
              child: new Text(
                "Color",
                style: TextStyle(
                  color: (state == LightingConfigState.colorState) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.colorState);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.dmxState) ?
                Colors.deepPurpleAccent : Colors.white,
              child: new Text(
                "DMX",
                style: TextStyle(
                  color: (state == LightingConfigState.dmxState) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.dmxState);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.keypadState) ?
                Colors.deepPurpleAccent : Colors.white,
              child: new Text(
                "Keypad",
                style: TextStyle(
                  color: (state == LightingConfigState.keypadState) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.keypadState);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.settingsState) ?
                Colors.deepPurpleAccent : Colors.white,
              child: new Text(
                "Settings",
                style: TextStyle(
                  color: (state == LightingConfigState.settingsState) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.settingsState);
              },
            )
          ),
        ],
      ),
    );
  }
}


