import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/mac.dart';

class Scene{
  static int sceneCount = 1;
  List<SceneUniverse> scene;
  String name;
  int id;
  DelayTime xFade;
  DelayTime hold;
  DelayTime fadeIn;
  DelayTime fadeOut;

  Scene({
    this.name, 
    this.xFade = const DelayTime(), 
    this.hold = const DelayTime(sec: 1),
    this.fadeIn = const DelayTime(),
    this.fadeOut = const DelayTime(),
    this.scene = const <SceneUniverse>[],
  }){
    if(this.name == null){
      name = "Scene $sceneCount";
    }
    id = sceneCount;
    sceneCount++;
  }

}

class SceneUniverse{
  Mac mac;
  List<int> dmx;

  SceneUniverse(this.mac, this.dmx);
}