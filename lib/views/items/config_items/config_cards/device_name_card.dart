import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';

class DeviceNameCard extends ConfigCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  DeviceNameCard(profile, alertMessage) : super(profile, alertMessage);

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
                hintText: 'Device Name'
              ),
              maxLength: BlizzardWizzardConfigs.longNameLength,
              maxLengthEnforced: true,
              validator: _validate,
              onSaved: _onSave,
            ),
            new ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('CLEAR'),
                    onPressed: () { _onClear(); },
                  ),
                  new FlatButton(
                    child: const Text('SUBMIT'),
                    onPressed: () { submit(); },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
  // First validate form.
    print("submit");
    if (_formKey.currentState.validate()) {
      print("save");
      _formKey.currentState.save(); // Save our form now.
    }
  }

  String _validate(String input){
    return null;
  }

  void _onClear(){
    print("clear");
    _formKey.currentState.reset();
  }

  void _onSave(String input){

    tron.addToWaitingList(WaitForPacket(_submitCallback,
        this.profile.address, 
        ArtnetPollReplyPacket.opCode, 
        BlizzardWizzardConfigs.artnetConfigCallbackTimout)
    );

    tron.server.sendPacket(_populateConfigPacket(input).udpPacket, this.profile.address);

  }

  void _submitCallback(List<int> data){
    if(data == null){
      alertMessage("Change name failed");
    } else {
      alertMessage("Name changed to " + String.fromCharCodes(data.getRange(ArtnetPollReplyPacket.longNameIndex, ArtnetPollReplyPacket.longNameSize)));
    }
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
