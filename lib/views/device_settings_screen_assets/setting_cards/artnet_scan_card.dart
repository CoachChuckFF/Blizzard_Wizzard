import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class ArtnetSACNCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  ArtnetSACNCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(height: 5.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container()
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "sACN",
                  style: TextStyle(
                    fontSize: 21.0,
                  ),
                  textAlign: TextAlign.left,
                )
              ),
              Expanded(
                flex: 5,
                child: Switch(
                  value: device.isArtnet,
                  onChanged:(val){ _sendCommand(); }
                )
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Artnet",
                  style: TextStyle(
                    fontSize: 21.0,
                  ),
                  textAlign: TextAlign.right,
                )
              ),
              Expanded(
                flex: 1,
                child: Container()
              )
            ],
          ),
          Container(height: 5.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container()
              ),
              Expanded(
                flex: 1,
                child: Tooltip(
                  message: "Active protocol will change to ${(device.isArtnet) ? 'sACN' : 'Artnet'}",
                  preferBelow: false,
                  child: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).disabledColor,
                  ),
                )
              ),
              Expanded(
                flex: 13,
                child: Container()
              )
            ],
          ),
          Container(height: 5.0),
        ]
      )
    );

  }


  void _sendCommand(){
    
    this.onSubmit("Crunching the Numbers");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackTimeout),
        preWait: Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackPreWait),
        onFailure: "Could not switch to ${(device.isArtnet) ? 'sACN' : 'Artnet'}",
        onSuccess: "Protocol switched to ${(!device.isArtnet) ? 'sACN' : 'Artnet'}",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetAddressPacket _populateConfigPacket(){
    ArtnetAddressPacket packet = ArtnetAddressPacket();

    packet.programNetSwitchEnable = false;
    packet.programSubSwitchEnable = false;
    packet.programUniverseEnable = false;

    packet.command = (device.isArtnet) ? 0x70 : 0x60;

    return packet;
  }
}
