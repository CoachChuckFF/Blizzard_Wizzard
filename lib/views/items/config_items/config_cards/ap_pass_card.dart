import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:d_artnet/d_artnet.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';

class APPasswordCard extends ConfigCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  APPasswordCard(profile, alertMessage) : super(profile, alertMessage);

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
        this.profile.address, 
        ArtnetPollReplyPacket.opCode, 
        BlizzardWizzardConfigs.artnetConfigCallbackTimout)
    );
*/
    tron.server.sendPacket(_populateConfigPacket(input).udpPacket, this.profile.address);


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
