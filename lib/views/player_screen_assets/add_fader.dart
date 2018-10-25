import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/actions.dart';
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
  List<Device> _devs;
  Map<Mac, List<int>> _patched;
  int _state;
  int _devCount;

  @override
  void initState() {
    super.initState();
    _state = PatchFaderState.main;
    _patched = Map<Mac, List<int>>();
    _devs = List<Device>();
    _devCount = 0;
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

                StoreProvider.of<AppState>(context).dispatch(PatchCueFader(
                  widget.index,
                  val)
                );
                Navigator.pop(context);
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
              devs: _devs,
              index: widget.index,
              callback: (state){
                if(state == PatchFaderState.channels){
                  _patched.clear();
                  _devs.forEach((dev){
                    _patched[dev.mac] = List<int>();
                  });
                }
                setState(() {
                  _state = state;
                });
              },
            );
          },
        );  
      case PatchFaderState.channels:
        return ChannelsPatchFaderPage(
          name: _devs[_devCount].name,
          channels: _patched[_devs[_devCount].mac],
          callback: (state){
            if(state != PatchFaderState.submit && state != PatchFaderState.submitAll){
              if(_devCount <= 0){
                _devCount = 0;
                _state = PatchFaderState.devices;
              } else {
                _devCount--;
              }
              setState((){});
              return;
            }
            if(state == PatchFaderState.submitAll){
              List<int> toCopy = List.from(_patched[_devs[_devCount].mac]);
              _patched.keys.toList().forEach((key){
                _patched[key].clear();
                _patched[key].addAll(toCopy);
              });

              StoreProvider.of<AppState>(context).dispatch(PatchDmxFader(
                widget.index,
                _patched)
              );
              Navigator.pop(context);
              return;
            }
            if(_devCount == _devs.length-1 || state == PatchFaderState.submitAll){

              StoreProvider.of<AppState>(context).dispatch(PatchDmxFader(
                widget.index,
                _patched)
              );
              Navigator.pop(context);
              return;
            }

            setState(() {_devCount++;});
          },
        );
    }
    return Text("0/0");
  }
}
