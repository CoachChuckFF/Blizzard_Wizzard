import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/keys.dart';
import 'package:blizzard_wizzard/views/manager_screen_assets/available_device_item.dart';

class AvailableDevicesList extends StatelessWidget {
  final List<Fixture> availableDevices;
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
        final fixture = availableDevices[index];

        return new AvailableDeviceItem(
          fixture: fixture,
          onTap: onTap,
        );
      },
    );
  }
}
