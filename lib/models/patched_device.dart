import 'package:blizzard_wizzard/models/mac.dart';

class PatchedDevice{
  final Mac mac;
  final String name;

  PatchedDevice({this.mac, this.name});

  @override
  bool operator == (Object other) =>
      other is PatchedDevice &&
        other.mac == mac;
}