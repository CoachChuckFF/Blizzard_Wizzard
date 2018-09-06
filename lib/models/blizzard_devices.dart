

class BlizzardDevices{
  static const Map<int, String> deviceMap = {
    0x34: "Blizzard Wizzard",
  };

  static String getDevice(int key){
    if(deviceMap.containsKey(key)){
      return deviceMap[key];
    }
    return "Unknown";
  }
}
