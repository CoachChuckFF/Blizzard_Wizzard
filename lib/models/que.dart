import 'package:blizzard_wizzard/models/scene.dart';

class Que{
  static int idCount = 1;

  String name;
  int id = 0;
  List<QueItem> scenes;

  Que(this.name, {this.id}){
    if(this.id == 0){
      this.id = idCount++;
    } else {
      if(this.id >= idCount){
        idCount = this.id + 1;
      }
    }
    scenes = List<QueItem>();

  }

}

class QueMode{
  static const int chase = 1;
  static const int step = 2;
}

class QueItem{
  Scene scene;
  QueMode mode;
  double wait;
  double xFade;

  QueItem({this.scene, this.mode, this.wait, this.xFade});
}