import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class SceneManipulatorButtonBar extends StatelessWidget {
  final ValueChanged<int> callback;
  final int state;
  final int fixtureState;

  SceneManipulatorButtonBar({
    this.callback,
    this.state: LightingConfigState.color,
    this.fixtureState,
  });

  @override
  Widget build(BuildContext context) {

    return (fixtureState == DeviceFixtureGridState.fixture) ?
    Card(
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
                callback(LightingConfigState.color);
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
                callback(LightingConfigState.preset);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.fx) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "FX",
                style: TextStyle(
                  color: (state == LightingConfigState.fx) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                callback(LightingConfigState.fx);
              },
            )
          ),
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.channels) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "Channels",
                style: TextStyle(
                  color: (state == LightingConfigState.channels) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                callback(LightingConfigState.channels);
              },
            )
          ),
        ],
      ),
    ) : 
    Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: new FlatButton(
              color: (state == LightingConfigState.classic) ?
                Theme.of(context).primaryColor : Colors.white,
              child: new Text(
                "Sliders",
                style: TextStyle(
                  color: (state == LightingConfigState.classic) ?
                  Colors.white : Colors.black,
                ),
              ),
              onPressed: (){
                callback(LightingConfigState.classic);
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
                callback(LightingConfigState.dmx);
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
                callback(LightingConfigState.keypad);
              },
            )
          ),
        ],
      ),
    );
  }
}


