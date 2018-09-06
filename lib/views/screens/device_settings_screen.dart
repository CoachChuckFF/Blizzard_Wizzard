import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/device_config_list.dart';
//import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/ap_pass_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/device_name_card.dart';
//import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/info_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';
//import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/ssid_pass_card.dart';



class DeviceSettingsScreen extends StatefulWidget {

  final Device device;

  DeviceSettingsScreen({ Key key, @required this.device}) : super(key: key);


  @override
  DeviceSettingsScreenState createState() => new DeviceSettingsScreenState(device: device);
}

class DeviceSettingsScreenState extends State<DeviceSettingsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Device device;
  String loadingMessage;
  bool isLoading;

  DeviceSettingsScreenState({
    @required this.device,
  }){
    loadingMessage = "";
    isLoading = false;
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
        child: (this.isLoading) ? 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10.0),
              Text(loadingMessage),
            ]
          ),
        ) :
        DeviceConfigList(
          configurations: _deviceToConfigList()
        )
      ),
    );
  }

  List<SettingsCard> _deviceToConfigList(){
    List<SettingsCard> list = List<SettingsCard>();

    //list.add(InfoCard(device, () {}, () {})));
    list.add(DeviceNameCard(device, _preLoad, _postLoad));
    //if(device.isBlizzard) list.add(SSIDPasswordCard(device, _alertSnackBar));
    //if(device.isBlizzard) list.add(APPasswordCard(device, _alertSnackBar));
    //list.add(DMXControlCard(device, _alertSnackBar));

    return list;
  }

  void _preLoad(String message){
    setState(() {
      loadingMessage = message;
      isLoading = true;      
    });
  }

  void _postLoad(List<int> data, String message){

    device = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((dev){
      return dev == device;
    }, orElse: (){return null;});

    if(device == null){
      Timer(Duration(seconds: BlizzardWizzardConfigs.artnetConfigDisconnectTimeout), _handleDisconnect);
      device = widget.device;
      device.name = ":(";
      message = "Device disconnected";
      setState(() {
        loadingMessage = "Wah wah";
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }  

    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          this.dispose();
        },
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handleDisconnect(){
    Navigator.of(context).pop();
    this.dispose();
  }

}

