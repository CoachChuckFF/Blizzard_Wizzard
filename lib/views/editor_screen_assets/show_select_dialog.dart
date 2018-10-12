import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/show.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_item.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class ShowSelectDialog extends StatelessWidget {
 
  final ValueChanged<String> callback;
  final String name;

  ShowSelectDialog({this.callback, this.name});


  Widget build(BuildContext context) {

    List<String> shows = <String>[
      "Hello world!",
      "The Little Mermaid",
      "Rent"
    ];

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      "Select Show",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30.0,
                      ),
                      onPressed: (){
                        showDialog(
                          context: context,
                          child: ShowAddDialog(
                            names: shows,
                            callback: (name){
                              print("add show $name");
                              Navigator.pop(context);
                            },
                          )
                        );
                      },
                    )
                  )
                )
              ],
            )
          )
        )
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Cancel",
          color: Colors.blue,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
      ],
      content: ListView.builder(
        itemCount: shows.length,
        itemBuilder: (context, index){
          return ShowItem(
            show: shows[index],
            selected: (shows[index] == name),
            onTap: (){
              print("${shows[index]}");
              if(shows[index] != name){
                callback(shows[index]);
              }
              Navigator.pop(context);
            }
          );
        },
      )
    );
  }
}

class ShowAddDialog extends StatefulWidget {
 
  final ValueChanged<String> callback;
  final List<String> names;

  ShowAddDialog({this.callback, this.names});

  @override
  createState() => ShowAddDialogState();
}


class ShowAddDialogState extends State<ShowAddDialog> {
  TextEditingController _textController = TextEditingController();
  String _name;

  ShowAddDialogState();

  @override
  initState() {
    super.initState();

    _name = "";

    _textController.text = _name;
  }

  

  void _onClear(){
    _textController.clear();
  }

  void _saveName(){
    String tempName = "";
    int showCount = 1;

    if(_textController.text.length == 0){
      _textController.text = "Show";
      
    }

    _name = _textController.text;
    tempName = _name;

    while(widget.names.contains(tempName)){
      tempName = "$_name ${showCount++}";
    }

    _name = tempName;
    _textController.text = _name;
  }

  Widget _buildName(){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(height: 3.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container()
              ),
              Expanded(
                flex: 13,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _name,
                    labelText: "Show Name",
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black
                  ),
                  maxLength: BlizzardWizzardConfigs.longNameLength,
                  maxLengthEnforced: true,
                  onEditingComplete: (){
                    setState(() {
                      _saveName();
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  }
                ),
              ),
              Expanded(
                flex: 1,
                child: Container()
              ),
            ],
          ),
          Container(height: 2.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container()
              ),
              Expanded(
                flex: 1,
                child: Tooltip(
                  message: "New Show Name",
                  preferBelow: false,
                  child: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).disabledColor,
                  ),
                )
              ),
              Expanded(
                flex: 13,
                child:ButtonTheme.bar( // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'CLEAR',
                          style: TextStyle(
                            color: Theme.of(context).accentColor
                          )
                        ),
                        onPressed: (){ _onClear(); },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(height: 3.0),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {

    List<Widget> children = List<Widget>();

    children.add(_buildName());

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Create Show",
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        )
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Cancel",
          color: Colors.blue,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
        BlizzardDialogButton(
          text: "Save",
          color: Colors.green,
          onTap: (){
            _saveName();
            widget.callback(_name);
            Navigator.of(context).pop();
          }
        ),
      ],
      content: ListView(
        children: children
      )
    );
  }
}