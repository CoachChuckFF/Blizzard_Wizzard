import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/fixes/vertical_slider.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/blizzard_fader.dart';
import 'package:blizzard_wizzard/views/player_screen_assets/fader_button.dart';

class DmxFader extends StatefulWidget {
  final Color activeColor = Colors.deepPurple;
  final Color inactiveColor = Colors.black;
  final Map<Mac,List<int>> patchedChannels;

  DmxFader(this.patchedChannels);

  createState() => DmxFaderState();
}


class DmxFaderState extends State<DmxFader> {
  String name;
  double value;

  DmxFaderState();

  @override
  initState() {
    super.initState();
    value = 0;
    name = "DMX";
  }

  void _setDMXValue(double newValue){
    if(newValue == value) return;
    if(newValue > 255) newValue = 255;
    if(newValue < 0) newValue = 0;

    value = newValue;

    widget.patchedChannels.keys.forEach((mac){
      Device dev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((dev){
        if(dev.mac == mac) return true; return false;
      }, orElse: (){return null;});

      if(dev == null) return;

      dev.dmxData.setDmxValues(widget.patchedChannels[mac], value.toInt());

      tron.server.sendPacket(dev.dmxData.udpPacket, dev.address);
    });

    setState(() {});
  }

  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: BlizzardSizes.vertSliderPadding*2 + BlizzardSizes.vertSliderThumb,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FaderButton(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  )
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  showDialog(
                    context: context,
                    child: DmxFaderDialog(
                      name: name,
                      patchedChannels: widget.patchedChannels,
                      callback: (){
                        print("Delete patched Channel");
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FaderButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  if(value + 1 > 255){
                    return;
                  }
                  _setDMXValue(value + 1);
                },
              )
            ),
            Expanded(
              child: FaderButton(
                child: Icon(
                  Icons.remove,
                  color: Colors.white
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  if(value - 1 < 0){
                    return;
                  }
                  _setDMXValue(value - 1);
                },
              )
            ),
            (value == 0) ?
            Expanded(
              child: FaderButton(
                child: Text(
                  "Full",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  )
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  _setDMXValue(255);
                },
              )
            ) :
            Expanded(
              child: FaderButton(
                child: Text(
                  "Zero",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  )
                ),
                primaryColor: widget.activeColor,
                onTap: (){
                  _setDMXValue(0);
                },
              )
            ),
            Expanded(
              child: FaderButton(
                child: Text(
                  "Run",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  )
                ),
                primaryColor: widget.activeColor,
              )
            ),
            Expanded(
              flex: 8,
              child: BlizzardFader(
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                callback: (newValue){
                  _setDMXValue(newValue);
                },
                max: 255,
                value: value,
              )
            ),
            Expanded(
              child: FaderButton(
                child: Text(
                  "${value.truncate()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  )
                ),
                primaryColor: widget.activeColor,
              )
            ),
          ]
        )
      )
    );
  }
}

class DmxFaderDialog extends StatelessWidget {
  final Function callback;
  final String name;
  final Map<Mac,List<int>> patchedChannels;

  DmxFaderDialog({this.callback, this.name, this.patchedChannels});

  Widget build(BuildContext context) {
    int channelCount = 0;

    patchedChannels.values.forEach((channels){
      channelCount += channels.length;
    });

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        )
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Cancel",
          color: Colors.blue,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
        BlizzardDialogButton(
          text: "Delete",
          color: Colors.red,
          onTap: (){
            callback();
            Navigator.of(context).pop();
          }
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: patchedChannels.keys.length,
              itemBuilder: _buildDeviceList
            ),
          ),
          Expanded(
            child: Container()
          ),
          Expanded(
            flex: 6,
            child: GridView.builder(
              itemCount: channelCount,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100.0,
              ),
              itemBuilder: _buildChannelGrid,
            ),
          ),
        ]
      )
    );
  }

  Widget _buildDeviceList(BuildContext context, int index){
    Device dev;
    String name;

    dev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((dev){
      return dev.mac == patchedChannels.keys.toList()[index];
    }, orElse: (){return null;});

    if(dev == null){
      name = patchedChannels.keys.toList()[index].toString();
    } else {
      name = dev.name;
    }

    Color color = ColorsList.getColor(index);

    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontSize: 20.0
        ),
      ),
      trailing: Icon(
        Icons.stop,
        color: color,
        size: 50.0,
      )
    );

  }

  Widget _buildChannelGrid(BuildContext context, int index){
    int jndex = 0;
    int channel = 0;

    patchedChannels.forEach((mac, list){
      list.forEach((c){
        if(index-- == 0){
          channel = c;
        } 
        return;
      });
      if(index < 0){
        return;
      }
      jndex++;
    });

    Color color = ColorsList.getColor(jndex);

    return Card(
      color: color,
      child: Center(
        child: Text(
          channel.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}