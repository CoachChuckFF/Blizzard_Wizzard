import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/cue.dart';


class Show{
  final List<Cue> cues;
  final Map<int, PatchedFixture> patchedFixtures;
  final Map<int, int> patchedCues;
  final Map<int, PatchedDevice> patchedDevices;
  final String name;

  Show({
    this.cues,
    this.patchedDevices,
    this.patchedCues,
    this.patchedFixtures,
    this.name
  });

  Show copyWith({
    List<Cue> cues,
    Map<int, int> patchedCues,
    Map<int, PatchedFixture> patchedFixtures,
    Map<int, PatchedDevice> patchedDevices,
    String name }){
    return Show(
      cues: cues ?? this.cues,
      patchedFixtures: patchedFixtures ?? this.patchedFixtures,
      patchedCues: patchedCues ?? this.patchedCues,
      patchedDevices: patchedDevices ?? this.patchedDevices,
      name: name ?? this.name,
    );
  }

}