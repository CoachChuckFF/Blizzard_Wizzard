import 'package:flutter/widgets.dart';

class BlizzardWizzardKeys {
  // Manager Screen
  static final managerScreen = const Key('__managerScreen__');
  static final availableDevicesList = const Key('__availableDevices__');
  static final availableDevice = (String id) => new Key('availableDevice__${id}');
  static final availableDeviceName = (String id) => new Key('availableDevice__${id}__Name');
  static final availableDeviceIp = (String id) => new Key('availableDevice__${id}__Ip');
  static final availableDeviceType = (String id) => new Key('availableDevice__${id}__Type');

  // Creator Screen 
  static final creatorScreen = const Key('__creatorScreen__');

  // Editor Screen
  static final editorScreen = const Key('__editorScreen__'); 

  // Player Screen
  static final playerScreen = const Key('__playerScreen__'); 

  // Helper Screen
  static final helperScreen = const Key('__helperScreen__'); 
}
