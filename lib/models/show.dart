import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/cue.dart';


class Show{
  List<Cue> cues;
  Map<int, PatchedFixture> patchedFixtures;
  Map<int, PatchedDevice> patchedDevices;
  Map<int, int> patchedCues;
  String name;
  int currentCue;
  int currentScene;

  Show({
    this.cues = const <Cue>[],
    this.patchedDevices,
    this.patchedCues,
    this.patchedFixtures,
    this.name,
    this.currentCue = 0,
    this.currentScene = 0,
  }){
    if(this.patchedCues == null){
      this.patchedCues = Map<int, int>();
    }
    if(this.patchedDevices == null){
      this.patchedDevices = Map<int, PatchedDevice>();
    }
    if(this.patchedFixtures == null){
      this.patchedFixtures = Map<int, PatchedFixture>();
    }
  }

  Show copyWith({
    List<Cue> cues,
    Map<int, int> patchedCues,
    Map<int, PatchedFixture> patchedFixtures,
    Map<int, PatchedDevice> patchedDevices,
    String name,
    int currentCue,
    int currentScene
    }){
    return Show(
      cues: cues ?? this.cues,
      patchedFixtures: patchedFixtures ?? this.patchedFixtures,
      patchedCues: patchedCues ?? this.patchedCues,
      patchedDevices: patchedDevices ?? this.patchedDevices,
      name: name ?? this.name,
      currentCue: currentCue ?? this.currentCue,
    );
  }

}