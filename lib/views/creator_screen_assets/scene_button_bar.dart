import 'package:flutter/material.dart';

class SceneButtonBar extends StatefulWidget {
  final ValueChanged<int> callback;

  SceneButtonBar({this.callback});

  @override
  createState() => SceneButtonBarState();
}

class SceneButtonBarState extends State<SceneButtonBar> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.save),
              tooltip: 'Save Scene',
              onPressed: () { print("Save"); },
            ),
          ),
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.schedule),
              tooltip: 'Load Scene',
              onPressed: () { print("Load"); },
            ),
          ),
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.clear),
              tooltip: 'Blackout',
              onPressed: () { widget.callback(0);},
            ),
          )
        ],
      ),
    );
  }
}
