import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/keys.dart';
import 'package:blizzard_wizzard/views/items/available_device_items/available_device_item.dart';

class AvailableDevicesList extends StatelessWidget {
  final List<Profile> availableDevices;
  final Function(int) onTap;

  AvailableDevicesList({
    Key key,
    @required this.availableDevices,
    @required this.onTap,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return new AppLoading(builder: (context, loading) {
      return loading
          ? new LoadingIndicator(key: ArchSampleKeys.todosLoading)
          : _buildListView();
    });*/

    return _buildListView();
  }

  ListView _buildListView() {
    return new ListView.builder(
      key: BlizzardWizzardKeys.availableDevicesList,
      itemCount: availableDevices.length,
      itemBuilder: (BuildContext context, int index) {
        final profile = availableDevices[index];

        return new AvailableDeviceItem(
          profile: profile,
          onTap: onTap,
        );
      },
    );
  }
}
