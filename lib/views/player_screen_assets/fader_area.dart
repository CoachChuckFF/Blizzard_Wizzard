import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/add_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/cue_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/dmx_fader.dart';

class FaderArea extends StatelessWidget {
  static const _maxSliders = 30;
  final Map<int, int> patchedCues;
  final Map<int, Map<Mac,List<int>>> patchedChannels;

  FaderArea({this.patchedCues, this.patchedChannels});

  Widget build(BuildContext context) {

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _maxSliders,
      shrinkWrap: true,
      itemBuilder: builder
    );
  }

  Widget builder(BuildContext context, int index){
    Widget child;

    if(patchedCues.containsKey(index)){
      child = StoreConnector<AppState, List<Cue>>(
        converter: (store) => store.state.show.cues,
        builder: (context, cues){

          Cue cue = cues.firstWhere((cue){
            return cue.id == patchedCues[index];
          }, orElse: (){return null;});

          return CueFader(
            index: index,
            cue: cue
          );
        }
      );
    } else if(patchedChannels.containsKey(index)){
      child = DmxFader(
        index: index,
        patchedChannels: patchedChannels[index]
      );
    } else {
      child = AddFader(index);
    }

    return child;
  }
}