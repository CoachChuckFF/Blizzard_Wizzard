import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_edit_dialog.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_item.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_select_dialog.dart';

class ShowArea extends StatelessWidget {
  final ValueChanged<String> nameChanged;
  final ValueChanged<String> showChanged;
  final String name;

  ShowArea({Key key, @required this.name, this.nameChanged, this.showChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(
            "Shows",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0
            ),
          ),
          ShowItem(
            show: name,
            selected: true,
            onTap: (){
              showDialog(
                context: context,
                child: ShowSelectDialog(
                  name: name,
                  callback: nameChanged
                )
              );
            },
            onDoubleTap: (){
              showDialog(
                context: context,
                child: ShowEditDialog(
                  name: name,
                  callback: nameChanged
                )
              );
            },
            onLongPress: (){
              showDialog(
                context: context,
                child: ShowEditDialog(
                  name: name,
                  callback: nameChanged
                )
              );
            },
          )
        ],
      ),
    );
  }
}
