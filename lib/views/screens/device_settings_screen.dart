import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/config_button_bar.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/device_config_list.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/ap_pass_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/artnet_scan_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/device_name_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/header_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/info_card.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/ssid_pass_card.dart';



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
  bool _isLoading;
  int _state;

  DeviceSettingsScreenState({
    @required this.device,
  }){
    loadingMessage = "";
    _isLoading = false;
    _state = DeviceConfigureCategoryState.device;
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Configuration Wizzard'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: (this._isLoading) ? 
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
        Column(
          children: <Widget>[
            InfoCard(device),
            ConfigButtonBar(
              state: _state,
              callback: (newState){
                if(newState != _state){
                  setState(() {
                    _state = newState;                    
                  });
                }
              }
            ),
            Expanded(
              child: Theme(
                data: _categoryToThemeData(),
                child: DeviceConfigList(
                  configurations: _deviceToConfigList()
                )
              ),
            ),
          ],
        )
      ),
    );
  }

  ThemeData _categoryToThemeData(){
    switch(_state){
      case DeviceConfigureCategoryState.device:
        return ThemeData(
          primarySwatch: DeviceConfigureCategoryColor.device,
        );
      case DeviceConfigureCategoryState.protocol:
        return ThemeData(
          primarySwatch: DeviceConfigureCategoryColor.protocol,
        );
      case DeviceConfigureCategoryState.network:
        return ThemeData(
          primarySwatch: DeviceConfigureCategoryColor.network,
        );
    }

    return ThemeData(
      primarySwatch: Colors.black,
    );
  }

  List<Widget> _deviceToConfigList(){
    List<Widget> list = List<Widget>();

    switch(_state){
      case DeviceConfigureCategoryState.device:
        list.add(HeaderCard("Device Configurations"));
        list.add(DeviceNameCard(device, _preLoad, _postLoad));
      break;
      case DeviceConfigureCategoryState.protocol:
        list.add(HeaderCard("Protocol Configurations"));
        if(device.canSwitch) list.add(ArtnetSACNCard(device, _preLoad, _postLoad));
      break;
      case DeviceConfigureCategoryState.network:
        list.add(HeaderCard("Network Configurations"));
        if(device.isBlizzard) list.add(APPassCard(device, _preLoad, _postLoad));
        if(device.isBlizzard) list.add(SSIDPassCard(device, _preLoad, _postLoad));
      break;
      default:
        list.add(HeaderCard("42"));
      break;
    }

    return list;
  }

  void _preLoad(String message){
    setState(() {
      loadingMessage = message;
      _isLoading = true;      
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
        _isLoading = false;
      });
    }  

    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
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

