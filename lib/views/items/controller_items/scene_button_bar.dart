import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'dart:async';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';

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
