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
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/channel_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/dmx_channel_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/fixture_type_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/library_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/main_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/manufacturer_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/verify_patch_fixture_page.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_dialog.dart';

class PatchFixtureDialog extends StatefulWidget {
  final int slot;

  PatchFixtureDialog(this.slot);

  @override
  createState() => PatchFixtureDialogState();
}

class PatchFixtureDialogState extends State<PatchFixtureDialog> {
  Key channelKey;
  Fixture fixture;
  int state;
  int channelIndex;

  PatchFixtureDialogState();

  void _callback(int state){
    int tempState = state;
    int tempIndex = this.channelIndex;
    Key tempKey = this.channelKey;

    switch(state){
      case PatchFixtureState.exit:
        Navigator.pop(context);
        return;
      case PatchFixtureState.nextChannel: 
        tempIndex++;
        tempKey = Key("CI$tempIndex");
        tempState = PatchFixtureState.firstChannel;
      break;
      case PatchFixtureState.prevChannel:
        tempIndex--;
        tempKey = Key("CI$tempIndex");
        tempState = PatchFixtureState.firstChannel;
      break;
    }

    setState(() {
      this.state = tempState;
      this.channelIndex = tempIndex;
      this.channelKey = tempKey;
    });
  }
  

  @override
  initState() {
    super.initState();
    fixture = new Fixture();
    state = PatchFixtureState.main;
    channelIndex = 0;
    channelKey = Key("CI$channelIndex");
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
      case PatchFixtureState.fixtureType:
        page = FixtureTypePatchFixturePage(callback: _callback, fixture: fixture,);
      break;
      case PatchFixtureState.firstChannel:
        page = ChannelPatchFixturePage(callback: _callback, fixture: fixture, index: channelIndex, key: channelKey,);
      break;
      case PatchFixtureState.verify:
        page = VerifyPatchFixturePage(callback: _callback, fixture: fixture);
      break;
      case PatchFixtureState.patchFromCreate:
        page = PatchFixturePage(callback: _callback, fixture: fixture, lastPage: PatchFixtureState.verify, slot: widget.slot);
      break;
    }

    return page;
  }
}