import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class IPCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<int> ip = List<int>(4);

  IPCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
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
                  flex:2,
                  child: Text(
                    "IP",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Theme.of(context).hintColor
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: device.address.rawAddress[0].toString(),
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (ip){this.ip[0] = int.parse(ip);},
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: device.address.rawAddress[1].toString(),
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (ip){this.ip[1] = int.parse(ip);},
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: device.address.rawAddress[2].toString(),
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (ip){this.ip[2] = int.parse(ip);},
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: device.address.rawAddress[3].toString(),
                      isDense: true,
                    ),
                    enabled: !device.isDHCP,
                    keyboardType: TextInputType.number,
                    validator: _validateIP,
                    onSaved: (ip){this.ip[3] = int.parse(ip);},
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
                    message: (device.isDHCP) ? "Turn off DHCP to edit IP" : "Edit the IP of the device",
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

  String _validateIP(String input){
    var val = int.parse(input);
    if(val is int){
      if(val <= 0xFF && val >= 0x00){
        return null;
      }
    }
    return "0-255";
  }

  void _onClear(){
    _formKey.currentState.reset();
  }

  void _sendCommand(){
    
    this.onSubmit("Enhance");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetIpProgPacket.opCode, 
        Duration(seconds: BlizzardWizzardConfigs.artnetConfigNeverReturnTimeout),
        onFailure: "Failed to change IP",
        onSuccess: "Ip changed",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetIpProgPacket _populateConfigPacket(){
    ArtnetIpProgPacket packet = ArtnetIpProgPacket();

    packet.commandProgrammingEnable = true;
    packet.commandDHCPEnable = false;
    packet.commandProgramIp = true;

    packet.ip = this.ip;

    return packet;
  }
}
