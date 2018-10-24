import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/models/show.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_list_area.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/show_area.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/master_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_area.dart';

class PlayerScreen extends StatefulWidget {
  @override
  createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded( //main lists
          flex: 1,
          child: MasterFader(),
        ),
        Expanded( //main lists
          flex: 4,
          child: StoreConnector<AppState, Show>(
            converter: (store) => store.state.show,
            builder: (context, show){
              return FaderArea(
                patchedChannels: show.patchedChannels,
                patchedCues: show.patchedCues
              );
            },
          ),
        ),
      ],
    );
  }
}
