import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/blizzard_devices.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/keys.dart';
import 'package:blizzard_wizzard/models/mac.dart';

class AvailableDeviceItem extends StatelessWidget {
  final Function(Device) onTap;
  final Device device;

  AvailableDeviceItem({
    @required this.onTap,
    @required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      key: BlizzardWizzardKeys.availableDevice(device.mac.toString()),
      child: new ListTile(
        onTap: () => onTap(device),
        leading: new Text(
          device.name,
          key: BlizzardWizzardKeys.availableDeviceName(device.mac.toString()),
          style: Theme.of(context).textTheme.title,
        ),
        title: new Text(
          //ArtnetServer.internetAddressToString(device.address),
          device.activeTick.toString(),
          key: BlizzardWizzardKeys.availableDeviceIp(device.mac.toString()),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: new Text(
          BlizzardDevices.getDevice(device.typeId),
          key: BlizzardWizzardKeys.availableDeviceType(device.mac.toString()),
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}
