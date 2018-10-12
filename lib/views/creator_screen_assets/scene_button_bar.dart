import 'package:flutter/material.dart';

class SceneButtonBar extends StatelessWidget {
  final Function onSaveTap;
  final Function onSaveDoubleTap;

  final Function onLoadTap;
  final Function onLoadDoubleTap;

  final Function onBlackoutTap;
  final Function onBlackoutDoubleTap;


  SceneButtonBar({this.onSaveTap, this.onSaveDoubleTap,
    this.onLoadTap, this.onLoadDoubleTap,
    this.onBlackoutTap, this.onBlackoutDoubleTap,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: new IconButton(
                icon: new Icon(Icons.save),
                tooltip: 'Save Scene',
                onPressed: onSaveTap
              ),
              onDoubleTap: onSaveDoubleTap,
            )
          ),
          Expanded(
            child: GestureDetector(
              child: new IconButton(
                icon: new Icon(Icons.schedule),
                tooltip: 'Load Scene',
                onPressed: onLoadTap
              ),
              onDoubleTap: onLoadDoubleTap,
            )
          ),
          Expanded(
            child: GestureDetector(
              child: new IconButton(
                icon: new Icon(Icons.clear),
                tooltip: 'Blackout',
                onPressed: onBlackoutTap,
              ),
              onDoubleTap: onBlackoutDoubleTap,
            )
          )
        ],
      ),
    );
  }
}
