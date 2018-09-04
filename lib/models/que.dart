import 'package:blizzard_wizzard/models/scene.dart';

class Que{
  static int idCount = 1;
  QueMode mode;

  String name;
  int id = 0;
  List<Scene> scenes;

  Que(this.name, {this.id}){
    if(this.id == 0){
      this.id = idCount++;
    } else {
      if(this.id >= idCount){
        idCount = this.id + 1;
      }
    }
    scenes = List<Scene>();

  }

}

class QueMode{
  static const int chase = 1;
  static const int step = 2;
}
