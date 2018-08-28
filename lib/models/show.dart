import 'package:blizzard_wizzard/models/patch_device.dart';
import 'package:blizzard_wizzard/models/patch_fixture.dart';
import 'package:blizzard_wizzard/models/patch_que.dart';
import 'package:blizzard_wizzard/models/que.dart';

class Show{
  List<Que> ques;
  List<PatchFixture> pathcedFixtures;
  List<PatchQue> patchedQues;
  List<PatchDevice> patchedDevices;
  String name;

  Show(this.name){
    ques = List<Que>();
    pathcedFixtures = List<PatchFixture>();
    patchedQues = List<PatchQue>();
    patchedDevices = List<PatchDevice>();
  }

}