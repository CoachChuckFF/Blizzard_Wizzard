import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/architecture/keys.dart';
import 'package:blizzard_wizzard/views/items/config_items/device_config_list.dart';
import 'package:blizzard_wizzard/views/items/config_items/config_cards/device_name_card.dart';
import 'package:blizzard_wizzard/views/items/config_items/config_cards/dmx_control_card.dart';
import 'package:blizzard_wizzard/views/items/config_items/config_cards/info_card.dart';
import 'package:blizzard_wizzard/views/items/config_items/config_cards/ssid_pass_card.dart';
import 'package:blizzard_wizzard/views/items/config_items/config_cards/ap_pass_card.dart';

class ConfigWizzardScreen extends StatefulWidget {

  final Profile profile;

  ConfigWizzardScreen({ Key key, this.profile}) : super(key: key);


  @override
  ConfigWizzardScreenState createState() => new ConfigWizzardScreenState(profile: profile);
}

class ConfigWizzardScreenState extends State<ConfigWizzardScreen> {

  final Profile profile;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ConfigWizzardScreenState({
    @required this.profile,
  }){
    print("created!");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Configuration Wizzard - ${profile.name}'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: DeviceConfigList(
          configurations: _profileToConfigList()
        ),
      ),
    );
  }

  List<ConfigCard> _profileToConfigList(){
    List<ConfigCard> list = List<ConfigCard>();

    list.add(InfoCard(profile, _alertSnackBar));
    list.add(DeviceNameCard(profile, _alertSnackBar));
    if(profile.isBlizzard) list.add(SSIDPasswordCard(profile, _alertSnackBar));
    if(profile.isBlizzard) list.add(APPasswordCard(profile, _alertSnackBar));
    list.add(DMXControlCard(profile, _alertSnackBar));

    return list;
  }

  void _alertSnackBar(String message){
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          this.dispose();
        },
      ),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}

