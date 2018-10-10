import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/mac.dart';

class Scene{
  static int sceneCount = 1;
  List<SceneData> sceneData;
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
    this.sceneData = const <SceneData>[],
    this.id
  }){
    if(this.name == null){
      name = "Scene $sceneCount";
    }
    if(this.id == null){
      id = sceneCount++;
    }
  }

  Scene copyWith({
    String name,
    DelayTime hold,
    DelayTime xFade,
    DelayTime fadeIn,
    DelayTime fadeOut,
    List<SceneData> sceneData,
    int id,
  }) {
    return Scene(
      name: name ?? this.name,
      hold: hold ?? this.hold,
      xFade: xFade ?? this.xFade,
      fadeIn: fadeIn ?? this.fadeIn,
      fadeOut: fadeOut ?? this.fadeOut,
      sceneData: sceneData ?? this.sceneData,
      id: id ?? this.id,
    );
  }

}

class SceneData{
  Mac mac;
  List<int> dmx;

  SceneData(this.mac, this.dmx);
}