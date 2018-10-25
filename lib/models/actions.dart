import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/mac.dart';
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

  UpdateSceneList(this.scenes, this.cueIndex);
}

class SetCurrentScene{
  final int currentScene;

  SetCurrentScene(this.currentScene);
}

class AddScene{
  final Scene scene;
  final int cueIndex;

  AddScene(this.scene, this.cueIndex);
}

class RemoveScene{
  final int sceneIndex;
  final int cueIndex;

  RemoveScene(this.sceneIndex, this.cueIndex);

}

class UpdateScene{
  final Scene scene;
  final int sceneIndex;
  final int cueIndex;

  UpdateScene(this.scene, this.sceneIndex, this.cueIndex);

}

class UpdateCueList{
  final List<Cue> cues;

  UpdateCueList(this.cues);
}

class SetCurrentCue{
  final int currentCue;

  SetCurrentCue(this.currentCue);
}

class AddCue{
  final Cue cue;

  AddCue(this.cue);
}

class RemoveCue{
  final int cueIndex;

  RemoveCue(this.cueIndex);
}

class UpdateCue{
  final Cue cue;
  final int cueIndex;

  UpdateCue(this.cue, this.cueIndex);
}

class PatchCueFader{
  final int faderIndex;
  final int cueId;

  PatchCueFader(this.faderIndex, this.cueId);
}

class UnpatchCueFader{
  final int faderIndex;

  UnpatchCueFader(this.faderIndex);
}

class PatchDmxFader{
  final int faderIndex;
  final Map<Mac, List<int>> channels;

  PatchDmxFader(this.faderIndex, this.channels);
}

class UnpatchDmxFader{
  final int faderIndex;

  UnpatchDmxFader(this.faderIndex);
}

