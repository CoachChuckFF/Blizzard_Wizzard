import 'package:blizzard_wizzard/models/scene.dart';

class Cue{
  static int idCount = 1;
  int id = 0;

  String name;
  CueMode mode;
  List<Scene> scenes;

  Cue({this.name, this.id = 0, this.scenes = const []}){
    if(this.id == 0){
      this.id = idCount++;
    } else {
      if(this.id >= idCount){
        idCount = this.id + 1;
      }
    }
    if(this.name == null){
      this.name = "Cue $id";
    }
  }

}

class CueMode{
  static const int chase = 1;
  static const int step = 2;
}
