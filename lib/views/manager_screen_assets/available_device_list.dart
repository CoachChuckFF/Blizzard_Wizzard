import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/keys.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/manager_screen_assets/available_device_item.dart';

class AvailableDevicesList extends StatelessWidget {
  final List<Device> availableDevices;
  final Function(Device) onTap;

  AvailableDevicesList({
    Key key,
    @required this.availableDevices,
    @required this.onTap,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return _buildListView();
  }

  ListView _buildListView() {
    return new ListView.builder(
      key: BlizzardWizzardKeys.availableDevicesList,
      itemCount: availableDevices.length,
      itemBuilder: (BuildContext context, int index) {
        final device = availableDevices[index];

        return new AvailableDeviceItem(
          device: device,
          onTap: onTap,
        );
      },
    );
  }
}
