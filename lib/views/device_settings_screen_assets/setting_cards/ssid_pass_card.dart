import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class SSIDPassCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static int submitCount = 0;
  static const List<String> responses = [
    "Please enter an SSID",
  ];

  String pass;
  String ssid;

  SSIDPassCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
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
                      hintText: "New SSID",
                      labelText: "SSID",
                      isDense: true,
                    ),
                    maxLength: BlizzardWizzardConfigs.ssidLength,
                    maxLengthEnforced: true,
                    validator: _validateSSID,
                    onSaved: (ssid){this.ssid = ssid;},
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
              ],
            ),
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
                      hintText: "New Password",
                      labelText: "Password",
                      isDense: true,
                    ),
                    maxLength: BlizzardWizzardConfigs.longNameLength,
                    maxLengthEnforced: true,
                    validator: _validatePass,
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
                    message: "Will attempt to connect ${device.name} to the given SSID",
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

  String _validateSSID(String input){
    if(input.length == 0){
      return responses[submitCount++%responses.length];
    }
    return null;
  }

  String _validatePass(String input){

    return null;
  }

  void _onClear(){
    _formKey.currentState.reset();
  }

  void _sendCommand(){
    
    this.onSubmit("${device.name} will now try to connect to $ssid. It will loose connection, so please back out of this page.");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(seconds: BlizzardWizzardConfigs.artnetConfigNeverReturnTimeout),
        onFailure: "Failed to change networks",
        onSuccess: "Failed to change networks",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetCommandPacket _populateConfigPacket(){
    ArtnetCommandPacket packet = ArtnetCommandPacket();
    var info = {
      "Action" : BlizzardActions.setSSIDAndPass,
      "SSID" : this.ssid,
      "Pass" : this.pass,
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
