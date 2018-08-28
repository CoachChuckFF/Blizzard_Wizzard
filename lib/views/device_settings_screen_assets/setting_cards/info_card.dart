import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';


class InfoCard extends SettingsCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  InfoCard(device, alertMessage) : super(device, alertMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(this.device.address.toString()),
    );
  }
}
