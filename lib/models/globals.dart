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
  static final int artnetConfigCallbackPreWait= 0; //ms 
  static final int artnetConfigCallbackTimeout = 3000; //ms
  static final int artnetConfigDisconnectTimeout = 5; //seconds
    static final int artnetConfigNeverReturnTimeout = 13; //seconds

  //sACN Configs
  static final int sACNMaxUniverses = 64000;

  //Available Device Configs
  static final int availableTimoutTick = 3;
}

class BlizzardActions{
  //actions
  static final int setGeneralConfig = 1;
  static final int getGeneralConfig = 2;

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

  static final int ota = 26;
  static final int reboot = 27;
  static final int reset = 28;
  static final int blackout = 32;
  static final int setDmx = 33;
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

class ArtnetMergeState{
  static const int none = 1;
  static const int htp = 2;
  static const int ltp = 3;
}

class LightingConfigState{
  static const int color = 1;
  static const int dmx = 2;
  static const int settings= 3;
  static const int keypad = 4;
  static const int preset = 5;
  static const int channels = 6;
  static const int fx = 7;
  static const int classic = 8;
  
}

class PageState{
  static const int manager = 1;
  static const int fixtureSettings = 2;
  static const int creator = 3;
  static const int editor = 4;
  static const int player = 5;
  static const int helper = 6; 
}

class PatchFixtureState{
  static const int exit = -1;
  static const int main = 1;
  static const int library = 2;
  static const int dmxChannels = 3;
  static const int manufacturer = 4;
  static const int fixtureType = 5;
  static const int firstChannel = 6;
  static const int nextChannel = 7;
  static const int prevChannel = 8;
  static const int verify = 9;
  static const int patchFromCreate = 10;
  static const int patchFromLibrary = 11;
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

class DeviceFixtureGridColor{
  static const Color device = Colors.lightBlue;
  static const Color fixture = Colors.purple;
}

class KeypadSecrets{
  static const String konami = "228846468 @ ";
  static const String dreams = "3111 -> 1 -> 1 -> 1331";
  static const String escape = "111 -> 333 -> 111";
  static const String don = "69";
  static const String homage = " @ 762";
}