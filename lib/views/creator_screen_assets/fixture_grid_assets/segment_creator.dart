import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class SegmentCreator extends StatefulWidget {
 
  final ValueChanged<Segment> callback;
  final Segment segment;
  final int start;
  final int index;

  SegmentCreator({this.callback, this.segment, this.start = 1, this.index = 0});

  @override
  createState() => SegmentCreatorState(segment);
}


class SegmentCreatorState extends State<SegmentCreator> {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Key _endKey;
  Segment _segment;

  String _validateName(String name){
    if(name.length == 0 || name == ""){
      return "Give your segment a name!";
    }
    return null;
  }

  SegmentCreatorState(this._segment);

  @override
  initState() {
    super.initState();

    int start = widget.start;
    if(start >= 512){
      start = 511;
    }

    if(_segment == null){
      _segment = Segment(
        name: "Macro ${widget.index + 1}",
        start: start,
        end: start+1
      );
    }

    _endKey = Key("EK${_segment.start}");
  }

  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: ListViewAlertButtonsDialog(
        title: Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Segment Creator",
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
              widget.callback(null);
              Navigator.of(context).pop();
            }
          ),
          BlizzardDialogButton(
            text: "Save",
            color: Colors.green,
            onTap: (){
              
              if(_formKey.currentState.validate()){
                _formKey.currentState.save();
              } else {
                return;
              }

              widget.callback(_segment);
              Navigator.of(context).pop();
            }
          ),
        ],
        content: ListView(
          children: <Widget>[
            Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
                  child: TextFormField(
                    initialValue: _segment.name,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Segment Name",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.all(5.0)
                    ),
                    maxLength: BlizzardWizzardConfigs.longNameLength,
                    maxLengthEnforced: true,
                    validator: _validateName,
                    onSaved: (text){
                      _segment.name = text;
                    },
                  ),
                )
              )
            ),
            Card(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Start",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context).textTheme.copyWith(
                              headline: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold
                              ),
                              body1: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                              )
                            )
                          ),
                          child: NumberPicker.integer(
                            listViewWidth: double.infinity,
                            itemExtent: 100.0,
                            initialValue: _segment.start,
                            minValue: 1,
                            maxValue: 510,
                            onChanged: (start){
                            setState(() {
                              _segment.start = start;  
                              _endKey = Key("EK${_segment.start}");
                              if(_segment.start >= _segment.end){
                                _segment.end = start + 1;
                              }           
                            });
                          }),
                        )
                      ],
                    )
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "End",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            accentColor: Colors.green,
                            textTheme: Theme.of(context).textTheme.copyWith(
                              headline: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold
                              ),
                              body1: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                              )
                            )
                          ),
                          child: NumberPicker.integer(
                            key: _endKey,
                            listViewWidth: double.infinity,
                            itemExtent: 100.0,
                            initialValue: (_segment.end <= _segment.start) ? 
                              _segment.start + 1 : _segment.end,
                            minValue: _segment.start + 1,
                            maxValue: 512,
                            onChanged: (end){
                            setState(() {
                              this._segment.end = end;            
                            });
                          }),
                        )
                      ],
                    )
                  ),
                ],
              )
            ),
          ]
        )
      )
    );
  }
}