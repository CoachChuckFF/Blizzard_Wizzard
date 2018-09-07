import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/blizzard_devices.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/keys.dart';
import 'package:blizzard_wizzard/views/manager_screen_assets/health_bar.dart';
import 'package:blizzard_wizzard/views/manager_screen_assets/rs_health_bar.dart';

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
      child: Card(
        child: ListTile(
          onTap: () => onTap(device),
          leading: Tooltip(
            message: "Connection Strength",
            child: RSHealthBar(
              strength: device.activeTick,
              maxStrength: BlizzardWizzardConfigs.checkIpTO,
              size: 30.0,
            ),
          ),
          title: new Text(
            device.name,
            style: Theme.of(context).textTheme.title,
          ),
          trailing: Tooltip(
            message: (device.isPatched) ? "${device.name} is patched" : "${device.name} is not patched",
            child: Icon(
              (device.isPatched) ? Icons.memory : Icons.crop_square
            ),
          )
        ),
      )
    );
  }
}
