import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';

//Global Varables
ArtnetController tron;

/*Configurations*/
class BlizzardWizzardConfigs{
  //Maxes
  static final int longNameLength = 64;
  static final int shortNameLength = 18;
  static final int ssidLength = 32;
  static final int passwordLength = 64;

  //Server Configs
  static final String broadcast = "255.255.255.255";
  static final String espIp = "192.168.4.255";
  static final int artnetPort = 6454;
  static final int sacnPort = 1234;

  //Artnet Configs
  static final int artnetMaxUniverses = 32768;
  static final int artnetPollDelay = 5; //sec
  static final int artnetBeepDelay = 3; //sec
  static final int checkIpTO = 3; //times
  static final int artnetConfigCallbackPreWait= 144; //ms 
  static final int artnetConfigCallbackTimeout = 3000; //ms
  static final int artnetConfigDisconnectTimeout = 2; //seconds
  static final int artnetConfigNeverReturnTimeout = 8; //seconds

  //Available Device Configs
  static final int availableTimoutTick = 3;
}

class BlizzardActions{
  //actions
  static final int setGeneralConfig = 1;
  static final int getGeneralConfig = 1;

  static final int setDhcp = 3;
  static final int getDhcp = 4;
  static final int setIp = 5;
  static final int getIp = 6;
  static final int setDisableWifiOnEthernet = 7;
  static final int getDisableWifiOnEthernet = 8;
  static final int getConenctions = 9;
  static final int getConnectionInfo = 10;
  static final int setSSIDAndPass = 11;
  static final int getMac = 112;
}

class BlizzardDefines{

  //data types
  static final int dataU8 = 0;
  static final int dataU16 = 1;
  static final int dataU32 = 2;
  static final int dataString = 3;

  //keys
  static final String apPassKey = "AP_PASS";
}

class LightingConfigState{
  static const int color = 1;
  static const int dmx = 2;
  static const int settings= 3;
  static const int keypad = 4;
  static const int preset = 5;
}

class PageState{
  static const int manager = 1;
  static const int fixtureSettings = 2;
  static const int creator = 3;
  static const int editor = 4;
  static const int player = 5;
  static const int helper = 6; 
}

class DeviceFixtureGridState{
  static const int device = 1;
  static const int fixture = 2;
}

class DeviceConfigureCategoryState{
  static const int device = 1;
  static const int fixture = 2;
  static const int network = 3;
  static const int protocol = 4;
}

class DeviceConfigureCategoryColor{
  static const Color device = Colors.deepOrange;
  static const Color deviceAccent = Colors.deepOrangeAccent;

  static const Color protocol = Colors.deepPurple;
  static const Color protocolAccent = Colors.deepPurpleAccent;

  static const Color network = Colors.green;
  static const Color networkAccent = Colors.greenAccent;
}