import 'package:blizzard_wizzard/models/mac.dart';

class PatchFixture {
  Map<int, int> map; //fixture mac

  PatchFixture({this.map}){
    if(this.map == null){
      map = Map<int,int>();
    }
  }
}