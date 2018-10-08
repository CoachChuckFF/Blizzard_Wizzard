import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/cue.dart';

class CueItem extends StatelessWidget {
  final ValueChanged<int> onTap;
  final ValueChanged<int> onDoubleTap; 
  final Cue cue;
  final bool selected;
  final int index;

  CueItem({Key key, @required this.cue, this.selected = false, this.index = 0, this.onTap, this.onDoubleTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color fontColor = (selected) ? Colors.white : Theme.of(context).primaryColor;
    Color bgColor = (!selected) ? Colors.white : Theme.of(context).primaryColor;

    return Card(
      color: bgColor,
      child: InkWell(
        child: ListTile(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      cue.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: fontColor
                      ),
                    ),
                  ),
                ]
              ),
              Container(height: 3.0),
            ],
          ),
        ),
        onTap: (){onTap(index);},
        onDoubleTap: (){onDoubleTap(index);},
      )
    );
  }
}