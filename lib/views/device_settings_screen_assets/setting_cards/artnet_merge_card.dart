import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class ArtnetMergeCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  ArtnetMergeCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
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
                    "Merge",
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
                    message: "No merging",
                    child: FlatButton(
                      color: (!device.isMerging) ?
                        Theme.of(context).primaryColor : Colors.white,
                      child: Text(
                        "None",
                        style: TextStyle(
                          color: (!device.isMerging) ?
                          Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: (){
                        if(device.isMerging)
                          _sendCommand(ArtnetMergeState.none);
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Highest DMX Value Takes Precedence",
                    child: FlatButton(
                      color: (device.isMerging && !device.isLTP) ?
                        Theme.of(context).primaryColor : Colors.white,
                      child: Text(
                        "HTP",
                        style: TextStyle(
                          color: (device.isMerging && !device.isLTP) ?
                          Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: (){
                        if(!(device.isMerging && !device.isLTP))
                          _sendCommand(ArtnetMergeState.htp);
                      },
                    )
                  )
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Latest DMX Value Takes Precedence",
                    child: FlatButton(
                      color: (device.isMerging && device.isLTP) ?
                        Theme.of(context).primaryColor : Colors.white,
                      child: Text(
                        "LTP",
                        style: TextStyle(
                          color: (device.isMerging && device.isLTP) ?
                          Colors.white : Colors.black,
                        ),
                      ),
                      onPressed: (){
                        if(!(device.isMerging && device.isLTP))
                          _sendCommand(ArtnetMergeState.ltp);
                      },
                    )
                  )
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
                    message: "Change the merge mode of this device",
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
    
    this.onSubmit("Deep Breaths");
    String onSuccess = "";

    switch(state){
      case ArtnetMergeState.none:
        onSuccess = "Artnet merge set to none";
      break;
      case ArtnetMergeState.htp:
        onSuccess = "Artnet merge set to HTP";
      break;
      case ArtnetMergeState.ltp:
        onSuccess = "Artnet merge set to LTP";
      break;
      default:
        return;
    }

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackTimeout),
        preWait: Duration(milliseconds: BlizzardWizzardConfigs.artnetConfigCallbackPreWait),
        onFailure: "Failed change merge mode",
        onSuccess: onSuccess,
      )
    );

    tron.server.sendPacket(_populateConfigPacket(state).udpPacket, this.device.address);
  }

  ArtnetAddressPacket _populateConfigPacket(int state){
    ArtnetAddressPacket packet = ArtnetAddressPacket();

    switch(state){
      case ArtnetMergeState.none:
        packet.command = ArtnetAddressPacket.commandOptionCancelMerge;
      break;
      case ArtnetMergeState.htp:
        packet.command = ArtnetAddressPacket.commandOptionMergeHtp0;
      break;
      case ArtnetMergeState.ltp:
        packet.command = ArtnetAddressPacket.commandOptionMergeLtp0;
      break;
    }

    return packet;
  }
}
