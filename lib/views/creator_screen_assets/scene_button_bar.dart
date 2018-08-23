import 'package:flutter/material.dart';

class SceneButtonBar extends StatefulWidget {

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
              tooltip: 'save',
              onPressed: () { print("Save"); },
            ),
          ),
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.schedule),
              tooltip: 'black',
              onPressed: () { print("Load"); },
            ),
          ),
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.clear),
              tooltip: 'delete',
              onPressed: () { print("Blackout"); },
            ),
          )
        ],
      ),
    );
  }
}
