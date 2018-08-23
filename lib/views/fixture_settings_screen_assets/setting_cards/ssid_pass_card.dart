import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/settings_card.dart';

class SSIDPasswordCard extends SettingsCard {
  String _ssid;
  String _pass;

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  SSIDPasswordCard(fixture, alertMessage) : super(fixture, alertMessage);

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
                hintText: 'SSID'
              ),
              maxLength: BlizzardWizzardConfigs.ssidLength,
              maxLengthEnforced: true,
              validator: (ssid){_ssid = ssid; return (_ssid.length == 0) ? "SSID can't be blank" : null;},
            ),
            TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Password',
              ),
              obscureText: true,
              maxLength: BlizzardWizzardConfigs.passwordLength,
              maxLengthEnforced: true,
              validator: (pass){_pass = pass; return null;},
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
      print("$_ssid, $_pass");
      tron.server.sendPacket(_populateConfigPacket().udpPacket, this.fixture.address);
    }
  }

  void _onClear(){
    _formKey.currentState.reset();
  }

  void _submitCallback(List<int> data){
    if(data == null){
      alertMessage("Change name failed");
    } else {
      alertMessage("Name changed to " + String.fromCharCodes(data.getRange(ArtnetPollReplyPacket.longNameIndex, ArtnetPollReplyPacket.longNameSize)));
    }
  }

  ArtnetCommandPacket _populateConfigPacket(){
    ArtnetCommandPacket packet = ArtnetCommandPacket();

    Map<String, dynamic> command = {
      "Action" : BlizzardActions.setSSIDAndPass,
      "SSID" : _ssid,
      "Pass" : _pass,
    };

    packet.data = json.encode(command).codeUnits;

    return packet;
  }
}
