import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/que.dart';


class Show{
  final List<Que> ques;
  final Map<int, PatchedFixture> patchedFixtures;
  final Map<int, int> patchedCues;
  final Map<int, PatchedDevice> patchedDevices;
  final String name;

  Show({
    this.ques,
    this.patchedDevices,
    this.patchedCues,
    this.patchedFixtures,
    this.name
  });

  Show copyWith({
    List<Que> ques,
    Map<int, int> patchedCues,
    Map<int, PatchedFixture> patchedFixtures,
    Map<int, PatchedDevice> patchedDevices,
    String name }){
    return Show(
      ques: ques ?? this.ques,
      patchedFixtures: patchedFixtures ?? this.patchedFixtures,
      patchedCues: patchedCues ?? this.patchedCues,
      patchedDevices: patchedDevices ?? this.patchedDevices,
      name: name ?? this.name,
    );
  }

}