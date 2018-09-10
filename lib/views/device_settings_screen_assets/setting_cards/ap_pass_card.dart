import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class APPassCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static int submitCount = 0;

  APPassCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
  String pass;

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
                      hintText: "password",
                      labelText: "Ap Pass",
                      isDense: true,
                    ),
                    maxLength: BlizzardWizzardConfigs.longNameLength,
                    maxLengthEnforced: true,
                    validator: _validate,
                    onSaved: (pass){this.pass = pass;},
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
                    message: "A new AP Password, used to connect to the ${device.name} device",
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

    return null;
  }

  void _onClear(){
    _formKey.currentState.reset();
  }

  void _sendCommand(){
    
    this.onSubmit("Doing computer things...");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetCommandPacket.opCode, 
        Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackTimeout),
        onFailure: "Failed to change ap password...",
        onSuccess: "Ap pass changed!",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetCommandPacket _populateConfigPacket(){
    ArtnetCommandPacket packet = ArtnetCommandPacket();
    var info = {
      "Action" : BlizzardActions.setGeneralConfig,
      "Key" : BlizzardDefines.apPassKey,
      "Type" : BlizzardDefines.dataString,
      "Data" : this.pass,
      "Change_Device" : 0,
      "Change_Mask" : 0
    };
 
    List<int> data = json.encode(info).codeUnits;

    for(int i = 0; i < data.length; i++){
      packet.data[i] = data[i];
    }

    //null terminate
    packet.data[data.length] = 0x00;

    return packet;
  }
}
