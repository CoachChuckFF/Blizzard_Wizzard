import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/mac.dart';

/* Is Loading */
class SetLoaded{}
class ClearLoaded{}

/* Has Keyboard */
class SetHasKeyboard{}
class ClearHasKeyboard{}

/* Available Devices List */
class TickDownAvailableDevice{
  final Device device;

  TickDownAvailableDevice(this.device);
}

class TickResetAvailableDevice{
  final Device device;

  TickResetAvailableDevice(this.device);
}

class AddAvailableDevice{
  final Device device;

  AddAvailableDevice(this.device);
}

class RemoveAvailableDevice{
  final Device device;

  RemoveAvailableDevice(this.device);
}

class UpdateAvailableDevice{
  final Device device;

  UpdateAvailableDevice(this.device);
}

/* Show */
class ChangeShowName{
  final String name;

  ChangeShowName(this.name);
}

// Patched Ques


// Patched Fixtures


// Patched Devices
class AddPatchDevice{
  final int slot;
  final Mac mac;
  final String name;

  AddPatchDevice(this.slot, this.mac, this.name);
}


