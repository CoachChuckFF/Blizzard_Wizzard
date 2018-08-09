import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/keys.dart';

class AvailableDeviceItem extends StatelessWidget {
  final Function(int) onTap;
  final Profile profile;

  AvailableDeviceItem({
    @required this.onTap,
    @required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: BlizzardWizzardKeys.availableDevice(profile.id.toString()),
      child: new ListTile(
        onTap: () => onTap(profile.id),
        leading: new Text(
          profile.name,
          key: BlizzardWizzardKeys.availableDeviceName(profile.id.toString()),
          style: Theme.of(context).textTheme.title,
        ),
        title: new Text(
          //ArtnetServer.internetAddressToString(profile.address),
          profile.activeTick.toString(),
          key: BlizzardWizzardKeys.availableDeviceIp(profile.id.toString()),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: new Text(
          profile.type,
          key: BlizzardWizzardKeys.availableDeviceType(profile.id.toString()),
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}
