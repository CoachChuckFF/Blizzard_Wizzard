import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/device_config_list.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/ap_pass_card.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/device_name_card.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/dmx_control_card.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/info_card.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/settings_card.dart';
import 'package:blizzard_wizzard/views/fixture_settings_screen_assets/setting_cards/ssid_pass_card.dart';



class FixtureSettingsScreen extends StatefulWidget {

  final Fixture fixture;

  FixtureSettingsScreen({ Key key, this.fixture}) : super(key: key);


  @override
  FixtureSettingsScreenState createState() => new FixtureSettingsScreenState(fixture: fixture);
}

class FixtureSettingsScreenState extends State<FixtureSettingsScreen> {

  final Fixture fixture;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FixtureSettingsScreenState({
    @required this.fixture,
  }){
    print("created!");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Configuration Wizzard - ${fixture.name}'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: DeviceConfigList(
          configurations: _fixtureToConfigList()
        ),
      ),
    );
  }

  List<SettingsCard> _fixtureToConfigList(){
    List<SettingsCard> list = List<SettingsCard>();

    list.add(InfoCard(fixture, _alertSnackBar));
    list.add(DeviceNameCard(fixture, _alertSnackBar));
    if(fixture.isBlizzard) list.add(SSIDPasswordCard(fixture, _alertSnackBar));
    if(fixture.isBlizzard) list.add(APPasswordCard(fixture, _alertSnackBar));
    list.add(DMXControlCard(fixture, _alertSnackBar));

    return list;
  }

  void _alertSnackBar(String message){
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          this.dispose();
        },
      ),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}

