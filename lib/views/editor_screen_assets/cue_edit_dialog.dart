import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class CueEditDialog extends StatefulWidget {
 
  final ValueChanged<Cue> callback;
  final Cue cue;

  CueEditDialog({this.callback, this.cue});

  @override
  createState() => CueEditDialogState();
}


class CueEditDialogState extends State<CueEditDialog> {
  TextEditingController _textController = TextEditingController();
  Cue _cue;
  int _state;

  CueEditDialogState();

  @override
  initState() {
    super.initState();

    _state = CueEditState.name;

    _cue = Cue();

    _cue.name = widget.cue.name;

    _textController.text = _cue.name;
  }

  Widget _buildButtonBar(){
    return Card(
      child:Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: new FlatButton(
                  color: (_state == SceneEditState.name) ?
                    Theme.of(context).primaryColor : Colors.white,
                  child: new Text(
                    "Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_state == SceneEditState.name) ?
                      Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: (){
                    if(_state != SceneEditState.name){
                      setState(() {
                        _state = SceneEditState.name;
                      });
                    }
                  },
                )
              ),
              Expanded(
                child: new FlatButton(
                  color: (_state == SceneEditState.delete) ?
                    
                    Colors.red : Colors.white,
                  child: new Text(
                    "Delete",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_state == SceneEditState.delete) ?
                      Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: (){
                    if(_state != SceneEditState.delete){
                      setState(() {
                        _state = SceneEditState.delete;
                      });
                    }
                  },
                )
              ),
            ],
          ),
        ]
      )
    );
  }

  void _onClear(){
    _textController.clear();
  }

  void _saveName(){
    if(_textController.text.length == 0){
      _textController.text = "Cue";
    }
    _cue.name = _textController.text;
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
                    hintText: _cue.name,
                    labelText: "Cue Name",
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
                  message: "Renames the Cue",
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

  Widget _buildDelete(){
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Tooltip(
              message: "Will delete Cue",
              preferBelow: false,
              child: FlatButton(
                color: Colors.red,
                child:Text(
                  "Delete",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white
                  ),
                ),
                onPressed: (){
                  widget.callback(null);
                  Navigator.pop(context);
                }
              ),
            )
          ),
        ]
      ),
    );
  }

  Widget build(BuildContext context) {

    List<Widget> children = List<Widget>();

    children.add(_buildButtonBar());

    switch(_state){
      case CueEditState.name:
        children.add(_buildName());
        break;
      case CueEditState.delete:
        children.add(_buildDelete());
        break;
    }

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Edit Cue",
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
            _cue.name = _textController.text;
            widget.callback(_cue);
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
