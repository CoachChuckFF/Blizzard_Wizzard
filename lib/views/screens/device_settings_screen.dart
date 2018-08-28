import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/device_config_list.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/ap_pass_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/device_name_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/dmx_control_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/info_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/ssid_pass_card.dart';



class DeviceSettingsScreen extends StatefulWidget {

  final Device device;

  DeviceSettingsScreen({ Key key, this.device}) : super(key: key);


  @override
  DeviceSettingsScreenState createState() => new DeviceSettingsScreenState(device: device);
}

class DeviceSettingsScreenState extends State<DeviceSettingsScreen> {

  final Device device;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DeviceSettingsScreenState({
    @required this.device,
  }){
    print("created!");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Configuration Wizzard - ${device.name}'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: DeviceConfigList(
          configurations: _deviceToConfigList()
        ),
      ),
    );
  }

  List<SettingsCard> _deviceToConfigList(){
    List<SettingsCard> list = List<SettingsCard>();

    list.add(InfoCard(device, _alertSnackBar));
    list.add(DeviceNameCard(device, _alertSnackBar));
    if(device.isBlizzard) list.add(SSIDPasswordCard(device, _alertSnackBar));
    if(device.isBlizzard) list.add(APPasswordCard(device, _alertSnackBar));
    //list.add(DMXControlCard(device, _alertSnackBar));

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

