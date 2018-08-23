import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/settings_card.dart';


class APPasswordCard extends SettingsCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  APPasswordCard(fixture, alertMessage) : super(fixture, alertMessage);

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
                hintText: 'AP Pass'
              ),
              maxLength: BlizzardWizzardConfigs.passwordLength,
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

  /*
    tron.addToWaitingList(WaitForPacket(_submitCallback,
        this.fixture.address, 
        ArtnetPollReplyPacket.opCode, 
        BlizzardWizzardConfigs.artnetConfigCallbackTimout)
    );
*/
    tron.server.sendPacket(_populateConfigPacket(input).udpPacket, this.fixture.address);


  }

  void _submitCallback(List<int> data){
    if(data == null){
      alertMessage("Change name failed");
    } else {
      alertMessage("Name changed to " + String.fromCharCodes(data.getRange(ArtnetPollReplyPacket.longNameIndex, ArtnetPollReplyPacket.longNameSize)));
    }
  }

  ArtnetCommandPacket _populateConfigPacket(String pass){
    ArtnetCommandPacket packet = ArtnetCommandPacket();

    Map<String, dynamic> command = {
      "Action" : BlizzardActions.setGeneralConfig,
      "key" : BlizzardDefines.apPassKey,
      "Type" : BlizzardDefines.dataString,
      "Change_Device" : 0,
      "Change_Mask" : 0,
      "Data" : pass,
    };

    packet.data = json.encode(command).codeUnits;

    return packet;
  }
}
