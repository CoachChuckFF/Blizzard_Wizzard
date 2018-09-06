import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: device.name,
                labelText: "Device Name",
                isDense: true,
              ),
              maxLength: BlizzardWizzardConfigs.longNameLength,
              maxLengthEnforced: true,
              validator: _validate,
              onSaved: _onSave,
            ),
            ButtonTheme.bar( // make buttons use the appropriate styles for cards
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
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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

  void _onSave(String input){
    
    this.onSubmit("Beep Boop");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackTimeout),
        preWait: Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackPreWait),
        onFailure: "Failed to change name...",
        onSuccess: "Name changed to $input",
      )
    );

    tron.server.sendPacket(_populateConfigPacket(input).udpPacket, this.device.address);
  }

  ArtnetAddressPacket _populateConfigPacket(String name){
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
