import 'package:blizzard_wizzard/models/mac.dart';

class Scene{
  static int sceneCount = 1;
  List<SceneUniverse> scene;
  String name;
  int id;
  double xFade;
  double hold;
  double fadeIn;
  double fadeOut;

  Scene({
    this.name, 
    this.xFade = 1.0, 
    this.hold = 1.0,
    this.fadeIn = 1.0,
    this.fadeOut = 1.0,
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