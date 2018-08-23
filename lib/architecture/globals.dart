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
  static final int artnetConfigCallbackTimout = 3000; //ms 

  //Available Device Configs
  static final int availableTimoutTick = 3;
}

class BlizzardActions{
  //actions
  static final int setGeneralConfig = 64;
  static final int getGeneralConfig = 64;

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
  static const int colorState = 1;
  static const int dmxState = 2;
  static const int settingsState = 3;
  static const int keypadState = 4;
}

class PageState{
  static const int fixturesState = 1;
  static const int sceneCreateState = 2;
  static const int sceneEditState = 3;
  static const int scenePlayState = 4;
  static const int helpState = 5; 
}