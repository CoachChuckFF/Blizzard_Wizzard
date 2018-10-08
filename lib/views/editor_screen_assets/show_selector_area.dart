import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_item.dart';

class ShowSelectorArea extends StatelessWidget {

  ShowSelectorArea({Key key, @required this.name}) : super(key: key);
  String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(
            "Cues",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0
            ),
          ),
          ShowItem(
            show: name,
            selected: true,
          )
        ],
      ),
    );
  }
}
