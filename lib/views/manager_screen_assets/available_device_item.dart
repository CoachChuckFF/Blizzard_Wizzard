import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/devices.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/keys.dart';

class AvailableDeviceItem extends StatelessWidget {
  final Function(int) onTap;
  final Fixture fixture;

  AvailableDeviceItem({
    @required this.onTap,
    @required this.fixture,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      key: BlizzardWizzardKeys.availableDevice(fixture.id.toString()),
      child: new ListTile(
        onTap: () => onTap(fixture.id),
        leading: new Text(
          fixture.name,
          key: BlizzardWizzardKeys.availableDeviceName(fixture.id.toString()),
          style: Theme.of(context).textTheme.title,
        ),
        title: new Text(
          //ArtnetServer.internetAddressToString(fixture.address),
          fixture.activeTick.toString(),
          key: BlizzardWizzardKeys.availableDeviceIp(fixture.id.toString()),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: new Text(
          BlizzardDevices.getDevice(fixture.typeId),
          key: BlizzardWizzardKeys.availableDeviceType(fixture.id.toString()),
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}
