import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/dmx_channel_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/library_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/main_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/manufacturer_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_dialog.dart';

class PatchFixtureDialog extends StatefulWidget {
 
  PatchFixtureDialog();

  @override
  createState() => PatchFixtureDialogState();
}

class PatchFixtureDialogState extends State<PatchFixtureDialog> {
  Fixture fixture;
  int state;

  PatchFixtureDialogState();

  void _callback(int state){
    if(state == PatchFixtureState.exit){
      Navigator.pop(context);
    } else {
      setState(() {
        this.state = state;

      });
    }
  }

  @override
  initState() {
    super.initState();
    fixture = new Fixture();
    state = PatchFixtureState.main;
  }

  Widget build(BuildContext context) {
    Widget page = Text("Oh Geeze");

    switch(state){
      case PatchFixtureState.main:
        page = MainPatchFixturePage(callback: _callback);
      break;
      case PatchFixtureState.library:
        page = LibraryPatchFixturePage(callback: _callback);
      break;
      case PatchFixtureState.dmxChannels:
        page = DMXChannelPatchFixturePage(callback: _callback, fixture: fixture,);
      break;
      case PatchFixtureState.manufacturer:
        page = ManufacturerPatchFixturePage(callback: _callback, fixture: fixture,);
      break;
    }

    return page;
  }
}