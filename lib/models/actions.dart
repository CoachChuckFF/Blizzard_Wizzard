import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/models/show.dart';

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

class UpdateShow{
  final Show show;

  UpdateShow(this.show);
}

// Patched Ques


// Patched Fixtures
class AddPatchFixture{
  final int slot;
  final PatchedFixture fixture;

  AddPatchFixture(this.slot, this.fixture);
}

class RemovePatchFixture{
  final int slot;

  RemovePatchFixture(this.slot);
}

class ClearPatchFixture{

  ClearPatchFixture();
}

// Patched Devices
class AddPatchDevice{
  final int slot;
  final PatchedDevice device;

  AddPatchDevice(this.slot, this.device);
}

class RemovePatchDevice{
  final int slot;

  RemovePatchDevice(this.slot);
}

class ClearPatchDevice{

  ClearPatchDevice();
}

class UpdateSceneList{
  final List<Scene> scenes;
  final int cueIndex;

  UpdateSceneList({this.scenes, this.cueIndex = 0});
}




