import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/que.dart';

class Show{
  final List<Que> ques;
  final Map<int, int> patchedFixtures;
  final Map<int, int> patchedQues;
  final Map<int, Mac> patchedDevices;
  final String name;

  Show({
    this.ques,
    this.patchedDevices,
    this.patchedQues,
    this.patchedFixtures,
    this.name
  });

  Show copyWith({
    List<Que> ques,
    Map<int, int> patchedFixtures,
    Map<int, int> patchedQues,
    Map<int, Mac> patchedDevices,
    String name }){
    return Show(
      ques: ques ?? this.ques,
      patchedFixtures: patchedFixtures ?? this.patchedFixtures,
      patchedQues: patchedQues ?? this.patchedQues,
      patchedDevices: patchedDevices ?? this.patchedDevices,
      name: name ?? this.name,
    );
  }

}