import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class DHCPCard extends SettingsCard {

  DHCPCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);

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
                  "DHCP",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).hintColor
                  ),
                  textAlign: TextAlign.left,
                )
              ),
              Expanded(
                flex: 5,
                child: Switch(
                  value: device.isDHCP,
                  onChanged:(val){ _sendCommand(); }
                )
              ),
              Expanded(
                flex: 3,
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
                  message: "Turn ${(device.isDHCP) ? 'off' : 'on'} DHCP",
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
          Container(height: 13.0),
        ]
      )
    );

  }


  void _sendCommand(){
    
    this.onSubmit("01101001");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetIpProgPacket.opCode, 
        Duration(seconds: BlizzardWizzardConfigs.artnetConfigNeverReturnTimeout),
        onFailure: (device.isDHCP) ? "Failed to turn off DHCP" : "Failed to turn on DHCP",
        onSuccess: "DHCP turned ${(device.isDHCP) ? 'off' : 'on'} successfully!",
      )
    );

    tron.server.sendPacket(_populateConfigPacket().udpPacket, this.device.address);
  }

  ArtnetIpProgPacket _populateConfigPacket(){
    ArtnetIpProgPacket packet = ArtnetIpProgPacket();

    packet.commandProgrammingEnable = true;
    packet.commandDHCPEnable = (!device.isDHCP);

    return packet;
  }
}
