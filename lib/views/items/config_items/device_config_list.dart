import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/keys.dart';
import 'package:blizzard_wizzard/views/items/available_device_items/available_device_item.dart';

class DeviceConfigList extends StatelessWidget {
  final List<ConfigCard> configurations;

  DeviceConfigList({
    Key key,
    @required this.configurations,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return _buildListView();
  }

  ListView _buildListView() {
    return new ListView.builder(
      key: BlizzardWizzardKeys.availableDevicesList,
      itemCount: configurations.length,
      itemBuilder: (BuildContext context, int index) {
        return configurations[index];
      },
    );
  }
}
