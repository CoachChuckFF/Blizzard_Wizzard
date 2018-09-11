import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class IndicatorCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  IndicatorCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
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
                  flex:3,
                  child: Text(
                    "Indicator",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Theme.of(context).hintColor
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Normal Operation",
                    child: FlatButton(
                      color: (device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionNormal ||
                        device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionUnkown) ?
                        Theme.of(context).primaryColor : Colors.white,
                      child: Text(
                        "Normal",
                        style: TextStyle(
                          color: (device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionNormal ||
                            device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionUnkown) ?
                            Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: (){
                        if(device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionNormal ||
                        device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionUnkown)
                          _sendCommand(ArtnetPollReplyPacket.status1IndicatorStateOptionNormal);
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Locate the device - usually from the device panel",
                    child: FlatButton(
                      color: (device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionLocate) ?
                        Theme.of(context).primaryColor : Colors.white,
                      child: Text(
                        "Locate",
                        style: TextStyle(
                          color: (device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionLocate) ?
                          Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: (){
                        if(device.indicatorState != ArtnetPollReplyPacket.status1IndicatorStateOptionLocate)
                          _sendCommand(ArtnetPollReplyPacket.status1IndicatorStateOptionLocate);
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Mute the device indicator - usually just turns off the device panel",
                    child: FlatButton(
                      color: (device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionMute) ?
                        Theme.of(context).primaryColor : Colors.white,
                      child: Text(
                        "Mute",
                        style: TextStyle(
                          color: (device.indicatorState == ArtnetPollReplyPacket.status1IndicatorStateOptionMute) ?
                          Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: (){
                        if(device.indicatorState != ArtnetPollReplyPacket.status1IndicatorStateOptionMute)
                          _sendCommand(ArtnetPollReplyPacket.status1IndicatorStateOptionMute);
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
              ],
            ),
            Container(height: 13.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: "Change the indication operation of this device",
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
          ],
        ),
      ),
    );
  }

  void _sendCommand(int state){
    
    this.onSubmit("Blink Blink");
    String onSuccess = "";

    switch(state){
      case ArtnetPollReplyPacket.status1IndicatorStateOptionLocate:
        onSuccess = "Indicator mode set to locate";
      break;
      case ArtnetPollReplyPacket.status1IndicatorStateOptionMute:
        onSuccess = "Indicator mode set to mute";
      break;
      default:
        onSuccess = "Indicator mode set to normal";
    }

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(seconds: BlizzardWizzardConfigs.artnetConfigNeverReturnTimeout),
        onFailure: "Failed to change indication mode",
        onSuccess: onSuccess,
      )
    );

    tron.server.sendPacket(_populateConfigPacket(state).udpPacket, this.device.address);
  }

  ArtnetAddressPacket _populateConfigPacket(int state){
    ArtnetAddressPacket packet = ArtnetAddressPacket();

    switch(state){
      case ArtnetPollReplyPacket.status1IndicatorStateOptionLocate:
        packet.command = ArtnetAddressPacket.commandOptionLedLocate;
      break;
      case ArtnetPollReplyPacket.status1IndicatorStateOptionMute:
        packet.command = ArtnetAddressPacket.commandOptionLedMute;
      break;
      default:
        packet.command = ArtnetAddressPacket.commandOptionLedNormal;
    }

    return packet;
  }
}
