import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class DeviceNameCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static int submitCount = 0;
  static const List<String> responses = [
    "Please enter a name",
    "You need need to make up a name",
    "*BLANK* is not a name",
    "A name has more than 0 charecters",
    "love me",
  ];

  DeviceNameCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
  String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Form(
        key: _formKey,
        child: new Column(
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: device.name,
                      labelText: "Device Name",
                      isDense: true,
                    ),
                    maxLength: BlizzardWizzardConfigs.longNameLength,
                    maxLengthEnforced: true,
                    validator: _validate,
                    onSaved: (name){this.name = name;},
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
                    message: "Unique device name",
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
                          child: const Text('CLEAR'),
                          onPressed: (){ _onClear(); },
                        ),
                        FlatButton(
                          child: const Text('SUBMIT'),
                          onPressed: (){ _submit(); }
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
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _sendCommand();
    }
  }

  String _validate(String input){
    if(input.length == 0){
      return responses[submitCount++%responses.length];
    }
    return null;
  }

  void _onClear(){
    _formKey.currentState.reset();
  }

  void _sendCommand(){
    
    this.onSubmit("Beep Boop Beep");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackTimeout),
        preWait: Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackPreWait),
        onFailure: "Failed to change name...",
        onSuccess: "Name changed to $name",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetAddressPacket _populateConfigPacket(){
    ArtnetAddressPacket packet = ArtnetAddressPacket();
    String longName = (name.length > BlizzardWizzardConfigs.longNameLength) ? name.substring(0, BlizzardWizzardConfigs.longNameLength - 1) : name;
    String shortName = (name.length > BlizzardWizzardConfigs.shortNameLength) ? name.substring(0, BlizzardWizzardConfigs.shortNameLength - 1) : name;


    packet.programNetSwitchEnable = false;
    packet.programSubSwitchEnable = false;
    packet.programUniverseEnable = false;

    packet.longName = longName;
    packet.shortName = shortName;

    return packet;
  }
}
