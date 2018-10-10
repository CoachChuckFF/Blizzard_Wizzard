import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class SceneEditDialog extends StatefulWidget {
 
  final ValueChanged<Scene> callback;
  final Scene scene;
  final double itemExtent;
  final double itemWidth; 


  SceneEditDialog({this.callback, this.scene, this.itemExtent = 50.0, this.itemWidth = 50.0});

  @override
  createState() => SceneEditDialogState();
}


class SceneEditDialogState extends State<SceneEditDialog> {
  TextEditingController _textController = TextEditingController();
  Key _scrollKey;
  Key _fadeKey;
  int _scrollIndex;
  Scene _scene;
  int _state;

  SceneEditDialogState();

  @override
  initState() {
    super.initState();

    _state = SceneEditState.hold;

    _scene = Scene();

    _scene.name = widget.scene.name;
    _scene.hold = widget.scene.hold;
    _scene.xFade = widget.scene.xFade;
    _scene.fadeIn = widget.scene.fadeIn;
    _scene.fadeOut = widget.scene.fadeOut;

    _textController.text = _scene.name;

    _scrollIndex = 0;
    _scrollKey = Key("SCROLL_KEY_$_scrollIndex");

    _fadeKey = Key("FADE_KEY_$_scrollIndex");
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
                  color: (_state == SceneEditState.hold) ?
                    Theme.of(context).primaryColor : Colors.white,
                  child: new Text(
                    "Hold",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_state == SceneEditState.hold) ?
                      Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: (){
                    if(_state != SceneEditState.hold){
                      setState(() {
                        _state = SceneEditState.hold;
                      });
                    }
                  },
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: new FlatButton(
                  color: (_state == SceneEditState.xFade) ?
                    Theme.of(context).primaryColor : Colors.white,
                  child: new Text(
                    "X Fade",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_state == SceneEditState.xFade) ?
                      Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: (){
                    if(_state != SceneEditState.xFade){
                      setState(() {
                        _state = SceneEditState.xFade;
                        _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
                      });
                    }
                  },
                )
              ),
              Expanded(
                child: new FlatButton(
                  color: (_state == SceneEditState.fadeIn) ?
                    Theme.of(context).primaryColor : Colors.white,
                  child: new Text(
                    "Fade In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_state == SceneEditState.fadeIn) ?
                      Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: (){
                    if(_state != SceneEditState.fadeIn){
                      setState(() {
                        _state = SceneEditState.fadeIn;
                        _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
                      });
                    }
                  },
                )
              ),
              Expanded(
                child: new FlatButton(
                  color: (_state == SceneEditState.fadeOut) ?
                    Theme.of(context).primaryColor : Colors.white,
                  child: new Text(
                    "Fade Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_state == SceneEditState.fadeOut) ?
                      Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: (){
                    if(_state != SceneEditState.fadeOut){
                      setState(() {
                        _state = SceneEditState.fadeOut;
                        _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
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
      _textController.text = "Scene";
    }
    _scene.name = _textController.text;
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
                    hintText: _scene.name,
                    labelText: "Scene Name",
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
                  message: "Name will propogate through all selected scenes",
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
                            color: Colors.blue
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

  Widget _buildHold(){
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      (_scene.hold.hr == 0) ?
                      "Hour" : "${_scene.hold.hr}h",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      
                    });
                  }
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: Colors.red,
                    textTheme: Theme.of(context).textTheme.copyWith( 
                      headline: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      body1: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      )
                    )
                  ),
                  child: NumberPicker.integer(
                    listViewWidth: widget.itemWidth,
                    itemExtent: widget.itemExtent,
                    initialValue: _scene.hold.hr,
                    minValue: 0,
                    maxValue: 99,
                    onChanged: (hr){
                    setState(() {
                      _scene.hold = _scene.hold.copyWith(
                        hr: hr,
                      );
                    });
                  }),
                )
              ],
            )
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      (_scene.hold.min == 0) ?
                      "Min" : "${_scene.hold.min}m",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      
                    });
                  }
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: Colors.green,
                    textTheme: Theme.of(context).textTheme.copyWith(
                      headline: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      body1: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      )
                    )
                  ),
                  child: NumberPicker.integer(
                    listViewWidth: widget.itemWidth,
                    itemExtent: widget.itemExtent,
                    initialValue: _scene.hold.min,
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (min){
                    setState(() {
                      _scene.hold = _scene.hold.copyWith(
                        min: min,
                      );
                    });
                  }),
                )
              ],
            )
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      (_scene.hold.getDoubleSecond() == 0) ?
                      "Halt" : "${_scene.hold.getDoubleSecond()}s",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      
                    });
                  }
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: Theme.of(context).textTheme.copyWith(
                      headline: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                      body1: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      )
                    )
                  ),
                  child: NumberPicker.decimal(
                    listViewWidth: widget.itemWidth,
                    itemExtent: widget.itemExtent,
                    initialValue: _scene.hold.getDoubleSecond(),
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (sec){
                    setState(() {
                      _scene.hold = _scene.hold.copyWithDouble(sec);
                    });
                  }),
                )
              ],
            )
          ),
        ],
      )
    );
  }

  Widget _buildFade(int state, ValueChanged<int> onMinChange, ValueChanged<double> onSecChange){

    return Card(
      key: _fadeKey,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      (_getTime(state).min == 0) ?
                      "Min" : "${_getTime(state).min}m",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      
                    });
                  }
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: Colors.green,
                    textTheme: Theme.of(context).textTheme.copyWith(
                      headline: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      body1: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      )
                    )
                  ),
                  child: NumberPicker.integer(
                    listViewWidth: widget.itemWidth,
                    itemExtent: widget.itemExtent,
                    initialValue: _getTime(state).min,
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (min){
                      onMinChange(min);
                  }),
                )
              ],
            )
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      (_getTime(state).getDoubleSecond() == 0) ?
                      "Sec" : "${_getTime(state).getDoubleSecond()}s",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      
                    });
                  }
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: Theme.of(context).textTheme.copyWith(
                      headline: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                      body1: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                      )
                    )
                  ),
                  child: NumberPicker.decimal(
                    listViewWidth: widget.itemWidth,
                    itemExtent: widget.itemExtent,
                    initialValue: _getTime(state).getDoubleSecond(),
                    minValue: 0,
                    maxValue: 59,
                    onChanged: (sec){
                      onSecChange(sec);
                  }),
                )
              ],
            )
          ),
        ],
      )
    );
  }

  Widget _buildHaltButton({Function onTap, Function onDoubleTap, Function onLongPress}){
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            child: FlatButton(
              color: Colors.black,
              child:Text(
                "HALT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white
                ),
              ),
              onPressed: onTap
            ),
            onLongPress: onLongPress,
            onDoubleTap: onDoubleTap,
          ),
        ),
        Expanded(
          child: Container()
        )
      ]
    );
  }

  Widget _buildZero(int state, Function onTap){
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            child: FlatButton(
              color: Colors.black,
              child:Text(
                "Zero",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white
                ),
              ),
              onPressed: onTap
            ),
            onLongPress: (){
              setState(() {
                _scene.xFade = DelayTime();
                _scene.fadeIn = DelayTime();
                _scene.fadeOut = DelayTime();
                _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
              });
            },
          ),
        ),
        Expanded(
          child: Tooltip(
            message: "Set all fades to ${_getTime(state)}",
            preferBelow: false,
            child: FlatButton(
              color: Colors.grey,
              child:Text(
                "Set All",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white
                ),
              ),
              onPressed: (){
                setState(() {
                  _scene.xFade = _getTime(state).copyWith();
                  _scene.fadeIn = _getTime(state).copyWith();
                  _scene.fadeOut = _getTime(state).copyWith();
                });
              }
            ),
          ),
        ),
      ]
    );
  }

  DelayTime _getTime(int state){
    switch(_state){
      case SceneEditState.xFade:
        return _scene.xFade;
        break;
      case SceneEditState.fadeIn:
        return _scene.fadeIn;
        break;
      case SceneEditState.fadeOut:
        return _scene.fadeOut;
        break;
    }
  }

  Widget build(BuildContext context) {

    List<Widget> children = List<Widget>();

    children.add(_buildButtonBar());

    switch(_state){
      case SceneEditState.name:
        children.add(_buildName());
        break;
      case SceneEditState.hold:
        children.add(_buildHold());
        children.add(_buildHaltButton(
          onTap: (){
            setState(() {
              _scene.hold = DelayTime();
              _scrollKey = Key("SCROLL_KEY_${++_scrollIndex}");              
            });
          }
        ));
        break;
      case SceneEditState.xFade:
        children.add(_buildFade(
          _state,
          (min){
            setState(() {
              _scene.xFade = _scene.xFade.copyWith(min: min);
            });
          },
          (sec){
            setState(() {
              _scene.xFade = _scene.xFade.copyWithDouble(sec);
            });
          }
        ));
        children.add(_buildZero(
          _state,
          (){
            setState(() {
              _scene.xFade = DelayTime();
              _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
            });
          }
        ));
        break;
      case SceneEditState.fadeIn:
        children.add(_buildFade(
          _state,
          (min){
            setState(() {
              _scene.fadeIn = _scene.fadeIn.copyWith(min: min);
            });
          },
          (sec){
            setState(() {
              _scene.fadeIn = _scene.fadeIn.copyWithDouble(sec);
            });
          }
        ));
        children.add(_buildZero(
          _state,
          (){
            setState(() {
              _scene.fadeIn = DelayTime();
              _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
            });
          }
        ));
        break;
      case SceneEditState.fadeOut:
        children.add(_buildFade(
          _state,
          (min){
            setState(() {
              _scene.fadeOut = _scene.fadeOut.copyWith(min: min);
            });
          },
          (sec){
            setState(() {
              _scene.fadeOut = _scene.fadeOut.copyWithDouble(sec);
            });
          }
        ));
        children.add(_buildZero(
          _state,
          (){
            setState(() {
              _scene.fadeOut = DelayTime();
              _fadeKey = Key("FADE_KEY_${++_scrollIndex}"); 
            });
          }
        ));
        break;
    }

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Edit Scene",
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
            _scene.name = _textController.text;
            widget.callback(_scene);
            Navigator.of(context).pop();
          }
        ),
      ],
      content: ListView(
        key: _scrollKey,
        children: children
      )
    );
  }
}
