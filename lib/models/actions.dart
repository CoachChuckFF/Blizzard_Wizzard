import 'package:blizzard_wizzard/models/fixture.dart';

/* Is Loading */
class SetLoaded{}
class ClearLoaded{}

/* Has Keyboard */
class SetHasKeyboard{}
class ClearHasKeyboard{}

/* Available Devices List */
class TickDownAvailableDevice{
  final Fixture fixture;

  TickDownAvailableDevice(this.fixture);
}

class TickResetAvailableDevice{
  final Fixture fixture;

  TickResetAvailableDevice(this.fixture);
}

class AddAvailableDevice{
  final Fixture fixture;

  AddAvailableDevice(this.fixture);
}

class RemoveAvailableDevice{
  final Fixture fixture;

  RemoveAvailableDevice(this.fixture);
}

class UpdateAvailableDevice{
  final Fixture fixture;

  UpdateAvailableDevice(this.fixture);
}