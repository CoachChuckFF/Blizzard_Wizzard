  import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
  
  //Global Varables
  ArtnetController tron;


  /*Configurations*/
  class BlizzardWizzardConfigs{
    //Maxes
    static final int longNameLength = 64;
    static final int shortNameLength = 18;

    //Server Configs
    static final String broadcast = "255.255.255.255";
    static final int artnetPort = 6454;
    static final int sacnPort = 1234;

    //Artnet Configs
    static final int artnetPollDelay = 3; //sec
    static final int artnetBeepDelay = 34; //sec
    static final int artnetConfigCallbackTimout = 3000; //ms 

    //Available Device Configs
    static final int availableTimoutTick = 3;
  }
