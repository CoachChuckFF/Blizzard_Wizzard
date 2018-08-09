  import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
  
  //Global Varables
  ArtnetController tron;

   /*static finals*/
  class BlizzardWizzardConfigs{
    //Server Configs
    static final String broadcast = "255.255.255.255";
    static final int artnetPort = 6454;
    static final int sacnPort = 1234;

    //Artnet Configs
    static final int artnetPollDelay = 3;
    static final int artnetBeepDelay = 34;

    //Available Device Configs
    static final int availableTimoutTick = 3;
  }