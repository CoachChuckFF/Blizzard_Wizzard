import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/keys.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';

class DeviceConfigList extends StatelessWidget {
  final List<SettingsCard> configurations;

  DeviceConfigList({
    Key key,
    @required this.configurations,
  }) : super(key: key);

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
