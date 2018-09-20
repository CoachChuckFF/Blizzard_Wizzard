import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/channel_type.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/channel_type_picker.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class ChannelPatchFixturePage extends StatefulWidget {
 
  final ValueChanged<int> callback;
  final Fixture fixture;
  final int index;

  ChannelPatchFixturePage({Key key, this.callback, this.fixture, this.index}):super(key: key);

  @override
  createState() => ChannelPatchFixturePageState();
}


class ChannelPatchFixturePageState extends State<ChannelPatchFixturePage> {
  static GlobalKey<FormState> _formKey;
  ChannelTypeReturnValue channelType;
  TextEditingController _nameController;
  ScrollController _viewController;

  String _validateName(String name){


    return null;
  }

  void _init(){
    int typeIndex;

    if(widget.fixture.profile.first.channels[widget.index] == null){
      widget.fixture.profile.first.channels[widget.index] = Channel(number: widget.index);
      widget.fixture.profile.first.channels[widget.index].segments = List<Segment>();
      typeIndex = 0;
    } else {
      typeIndex = ChannelTypes.getIndexFromName(widget.fixture.profile.first.channels[widget.index].name);
    }

    channelType = ChannelTypeReturnValue.copyFromType(ChannelTypes.types[typeIndex], typeIndex);

    _nameController.text = (channelType.needsName) ? 
      (widget.fixture.profile.first.channels[widget.index].name ?? "Channel ${widget.index + 1}") :
      channelType.name;
  }

  @override
  initState() {
    super.initState();
    _formKey = new GlobalKey<FormState>();
    _nameController = new TextEditingController();
    _viewController = new ScrollController();
    _init();
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
                "Configure Channel ${widget.index + 1}",
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
            text: "Back",
            color: Colors.red,
            onTap: (){
              widget.callback((widget.index == 0) ? 
              PatchFixtureState.fixtureType : 
              PatchFixtureState.prevChannel
              );
            }
          ),
          BlizzardDialogButton(
            text: "Next",
            color: Colors.green,
            onTap: (){

              if(channelType.needsName){
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                } else {
                  return;
                }
              } else {
                widget.fixture.profile.first.channels[widget.index].name = channelType.name;
              }

              if(channelType.canHaveSegments){
                //Do something
              }

              widget.callback(
                (widget.index >= widget.fixture.profile.first.channels.length - 1) ?
                PatchFixtureState.verify : 
                PatchFixtureState.nextChannel
              );

            }
          ),
        ],
        content: ListView(
          controller: _viewController,
          reverse: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            (channelType.canHaveSegments) ? 
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.fixture.profile.first.channels[widget.index].segments.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if(index == 0){
                  return Card(
                    child: ListTile(
                      title: Text(
                        "Segments",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.add,
                        ),
                        onPressed: (){
                          setState(() {
                            widget.fixture.profile.first.channels[widget.index].segments.add(
                              Segment(name: "Test", start: 0, end: 1)
                            );                           
                          });
                          _viewController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        } 
                      ),
                    )
                  );
                }
                index--;
                
                Segment segment = widget.fixture.profile.first.channels[widget.index].segments[index];

                return Card(
                  child: ListTile(
                    leading: Text(
                      segment.name,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    title: Column(
                      children: <Widget>[
                        Text(
                          segment.start.toString(),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          segment.end.toString(),
                          textAlign: TextAlign.right,
                        )
                      ]
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.remove,
                      ),
                      onPressed: (){
                        setState(() {
                          widget.fixture.profile.first.channels[widget.index].segments.remove(segment);     
                        });
                        _viewController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      } 
                    ),
                  )
                );
              }
            ) :
            Container(),
            ChannelTypePicker.integer(
              initialValue: channelType.index,
              onChanged: (channelType){
                setState(() {
                  _nameController.text = (channelType.needsName) ? "Channel ${widget.index + 1}" : channelType.name;
                  this.channelType = channelType;   
                });
              },
            ),
            Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _nameController,
                    enabled: channelType.needsName,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: (channelType.needsName) ? Theme.of(context).primaryColor : Colors.grey
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Channel Name",
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
                      widget.fixture.profile.first.channels[widget.index].name = text;
                    },
                  ),
                )
              )
            ),
          ]
        )
      ),
    );
  }
}
