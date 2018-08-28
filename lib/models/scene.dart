import 'package:blizzard_wizzard/models/mac.dart';

class Scene{
  List<SceneUniverse> scene = List<SceneUniverse>();
  String name = "";

  Scene(this.name);

}

class SceneUniverse{
  Mac mac;
  List<int> dmx;

  SceneUniverse(this.mac, this.dmx);
}