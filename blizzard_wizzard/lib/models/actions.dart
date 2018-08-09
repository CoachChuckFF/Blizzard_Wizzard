import 'package:blizzard_wizzard/models/models.dart';

/* Is Loading */
class SetLoaded{}
class ClearLoaded{}

/* Available Devices List */
class TickDownAvailableDevice{
  final Profile profile;

  TickDownAvailableDevice(this.profile);
}

class TickResetAvailableDevice{
  final Profile profile;

  TickResetAvailableDevice(this.profile);
}

class AddAvailableDevice{
  final Profile profile;

  AddAvailableDevice(this.profile);
}

class RemoveAvailableDevice{
  final Profile profile;

  RemoveAvailableDevice(this.profile);
}

class UpdateAvailableDevice{
  final Profile profile;

  UpdateAvailableDevice(this.profile);
}