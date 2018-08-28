import 'package:blizzard_wizzard/models/fixture.dart';

class BlizzardDevices{
  static const Map<int, DeviceInfo> deviceMap = {
    0x34:DeviceInfo(name: "Blizzard Wizzard", self: Profile(
      redChannel: 33,
      greenChannel: 34,
      blueChannel: 35,
    )),
  };

  static DeviceInfo getDevice(int key){
    if(deviceMap.containsKey(key)){
      return deviceMap[key];
    }
    return DeviceInfo(name: "unkown");
  }
}

class DeviceInfo{
  final String name;
  final Profile self;

  const DeviceInfo({this.name, this.self});

}