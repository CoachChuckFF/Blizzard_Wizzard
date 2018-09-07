import 'dart:async';
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/blizzard_devices.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/views/screens/blizzard_screen.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/controllers/reducers.dart';

Device blizzardDev;
Device genDev;
Store _store;
int _ticker;

void initTestStructs(Store store){
  _store = store;
  _ticker = 1;

  blizzardDev = Device([0x00, 0x01, 0x02, 0x03, 0x04, 0x05],
    name: "Blizzard Device",
    typeId: 0x34,
    isBlizzard: true,
    isPatched: true,
    address: InternetAddress("192.168.1.89"),
  );

  genDev = Device([0x03, 0x01, 0x02, 0x03, 0x04, 0x05],
    name: "Generic Device",
    typeId: 0x00,
    address: InternetAddress("192.168.1.89"),
  );

  _store.dispatch(AddAvailableDevice(blizzardDev));

  _resetDeviceTick();
}

void _resetDeviceTick(){
  _store.dispatch(TickResetAvailableDevice(blizzardDev));
  if(_ticker++ % 4 == 0){
    genDev.activeTick = BlizzardWizzardConfigs.checkIpTO;
    _store.dispatch(AddAvailableDevice(genDev));
  }
  Timer(Duration(seconds: 5), _resetDeviceTick);
}