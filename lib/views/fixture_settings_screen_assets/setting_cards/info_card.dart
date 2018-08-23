import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/settings_card.dart';


class InfoCard extends SettingsCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  InfoCard(fixture, alertMessage) : super(fixture, alertMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(this.fixture.address.toString()),
    );
  }
}
