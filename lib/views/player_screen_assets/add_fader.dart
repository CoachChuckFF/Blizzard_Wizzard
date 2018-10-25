import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/blizzard_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/patch_fader_assets/channels_patch_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/patch_fader_assets/cue_patch_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/patch_fader_assets/devices_patch_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/patch_fader_assets/main_patch_fader.dart';

class AddFader extends StatelessWidget {
  final int index;

  AddFader(this.index);

  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: BlizzardSizes.vertSliderPadding * 2 + BlizzardSizes.vertSliderThumb,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FaderButton(
                child: Text(
                  "S$index",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  )
                ),
                primaryColor: Colors.blue,
              )
            ),
            Expanded(
              flex: 13,
              child: Center(
                child: IconButton(
                  iconSize: 50.0,
                  color: Colors.blue,
                  icon: Icon(
                    Icons.add_box,
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      child: PatchFaderDialog(
                        index: index
                      )
                    );
                  },
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

class PatchFaderDialog extends StatefulWidget {
  final int index;

  PatchFaderDialog({this.index});

  @override
  createState() => PatchFaderDialogState();
}

class PatchFaderDialogState extends State<PatchFaderDialog> {
  List<int> _channels;
  List<Mac> _macs;
  int _state;

  @override
  void initState() {
    super.initState();
    _state = PatchFaderState.main;
    _channels = List<int>();
    _macs = List<Mac>();
  }

  @override
  Widget build(BuildContext context) {
    switch(_state){
      case PatchFaderState.main:
        return MainPatchFaderPage(
          index: widget.index,
          callback: (state){
            setState((){
              _state = state;
            });
          },
        );
      case PatchFaderState.cue:
        return StoreConnector<AppState, List<Cue>>(
          converter: (store) => store.state.show.cues,
          builder: (context, cues){
            return CuePatchFaderPage(
              cues: cues,
              index: widget.index,
              callback: (val){
                if(val == -1){
                  setState(() {
                    _state = PatchFaderState.main;                 
                  });
                  return; 
                }

                //add cue fader
              },
            );
          },
        );
      case PatchFaderState.devices:
        return StoreConnector<AppState, List<Device>>(
          converter: (store) => store.state.availableDevices,
          builder: (context, devices){
            return DevicesPatchFaderPage(
              devices: devices,
              macs: _macs,
              index: widget.index,
              callback: (state){
                setState(() {
                  _state = state;
                });
              },
            );
          },
        );  
      case PatchFaderState.channels:
        return ChannelsPatchFaderPage(
          index: widget.index,
          channels: _channels,
          callback: (state){
            if(state != PatchFaderState.submit){
              setState((){
                _state = PatchFaderState.devices;
              });
              return;
            }

            //add device fader
          },
        );
    }
    return Text("0/0");
  }
}
