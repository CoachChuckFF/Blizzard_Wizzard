import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class SceneManipulatorButtonBar extends StatefulWidget {
  final ValueChanged<int> callback;
  final int state;

  SceneManipulatorButtonBar({
    this.callback,
    this.state: LightingConfigState.color,
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
              color: (state == LightingConfigState.color) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "Color",
                style: TextStyle(
                  color: (state == LightingConfigState.color) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.color);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.preset) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "Presets",
                style: TextStyle(
                  color: (state == LightingConfigState.preset) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.preset);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.dmx) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "DMX",
                style: TextStyle(
                  color: (state == LightingConfigState.dmx) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.dmx);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.keypad) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "Keypad",
                style: TextStyle(
                  color: (state == LightingConfigState.keypad) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                _update(LightingConfigState.keypad);
              },
            )
          ),
        ],
      ),
    );
  }
}


