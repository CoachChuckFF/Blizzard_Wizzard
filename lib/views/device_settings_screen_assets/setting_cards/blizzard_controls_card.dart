import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class BlizzardControlsCard extends SettingsCard {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  BlizzardControlsCard(device, onSubmit, onReturn) : super(device, onSubmit, onReturn);
  
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
                    "Functions",
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
                    message: "Update the device's firmware",
                    child: FlatButton(
                      child: Text(
                        "Update",
                      ),
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Update?"),
                              content: new Text("Device is up to date!"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Accept"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Reboot the device - all configurations are saved",
                    child: FlatButton(
                      child: Text(
                        "Reboot",
                      ),
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Reboot?"),
                              content: new Text("Are you sure you want to reboot? All settings will be saved."),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Accept"),
                                  onPressed: () {
                                    _reboot();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Tooltip(
                    message: "Factory reset the device - all configurations will be lost",
                    child: FlatButton(
                      child: Text(
                        "Reset",
                      ),
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Reset?"),
                              content: new Text("Warning: This will factory reset the device - all configurations will be lost. \n\n Continue?"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Proceed"),
                                  onPressed: () {
                                    _reset();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
                    message: "Special functions only available via Blizzard Pro devices",
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

  void _reboot(){
    this.onSubmit("Rebooting...");

    tron.addToWaitingList(
      WaitForPacket(this.onReturn,
        this.device.address, 
        ArtnetPollReplyPacket.opCode, 
        Duration(seconds: BlizzardWizzardConfigs.artnetConfigNeverReturnTimeout * 10),
        onFailure: "Failed to reboot and reconnect please exit this screen",
        onSuccess: "Reconnected",
      )
    );

    tron.server.sendPacket(_populateCommandPacket(
      {
        "Action" : BlizzardActions.reboot,
      }
    ).udpPacket, this.device.address);

  }

  void _reset(){
    this.onSubmit("Deleting system 32...");

    tron.server.sendPacket(_populateCommandPacket(
      {
        "Action" : BlizzardActions.reset
      }
    ).udpPacket, this.device.address);
  }

  ArtnetCommandPacket _populateCommandPacket(var info){ 
    ArtnetCommandPacket packet = ArtnetCommandPacket();

    List<int> data = json.encode(info).codeUnits;

    for(int i = 0; i < data.length; i++){
      packet.data[i] = data[i];
    }

    //null terminate
    packet.data[data.length] = 0x00;

    return packet;
  }
}
