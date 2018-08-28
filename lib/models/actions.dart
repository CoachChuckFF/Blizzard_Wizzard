import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/patch_fixture.dart';
import 'package:blizzard_wizzard/models/patch_que.dart';

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
class AddPatchQue{
  final PatchQue patchQue;

  AddPatchQue(this.patchQue);

}

class RemovePatchQue{
  final PatchQue patchQue;

  RemovePatchQue(this.patchQue);
}

class UpdatePatchQue{
  final List<PatchQue> patchQues;

  UpdatePatchQue(this.patchQues);
}

class AddPatchFixture{
  final PatchFixture patchFixture;

  AddPatchFixture(this.patchFixture);

}

// Patched Fixtures
class RemovePatchFixture{
  final PatchFixture patchFixture;

  RemovePatchFixture(this.patchFixture);
}

class UpdatePatchFixture{
  final List<PatchFixture> patchFixtures;

  UpdatePatchFixture(this.patchFixtures);
}

// Ques
