import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/mac.dart';

class PatchedFixture{
  final Mac mac;
  final Fixture fixture;
  final String name;
  final bool fromDevice;

  PatchedFixture({this.mac, this.name, this.fixture, this.fromDevice = false});
}