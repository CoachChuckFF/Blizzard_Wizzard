import 'package:blizzard_wizzard/models/mac.dart';

class PatchDevice {
  Map<int, Mac> map; //slot index / device mac

  PatchDevice({this.map}){
    if(this.map == null){
      map = Map<int,Mac>();
    }
  }
}