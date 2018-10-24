import 'package:blizzard_wizzard/models/scene.dart';

class Cue{
  static int idCount = 1;
  int id;

  String name;
  List<Scene> scenes;

  Cue({this.name, this.id = 0, this.scenes = const []}){
    if(this.id == 0){
      this.id = ++idCount;
    } else {
      if(this.id >= idCount){
        idCount = this.id + 1;
      }
    }
    if(this.name == null){
      this.name = "Cue $id";
    }
  }

  Cue copyWith({
    String name,
    List<Scene> scenes,
    int id,
  }) {
    return Cue(
      name: name ?? this.name,
      scenes: scenes ?? this.scenes,
      id: id ?? this.id,
    );
  }

}
