import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_dialog.dart';


class DeviceGrid extends StatelessWidget {
  final int cols;
  final double fontSize = 20.0;
  final String fontFamily = "Roboto";
  final Map<int, PatchedDevice> patchedDevices;
  final List<int> selectedDevices;
  final ValueChanged<List<int>> callback;

  DeviceGrid({
    this.cols = 5,
    this.patchedDevices,
    this.selectedDevices,
    this.callback
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
      itemCount: BlizzardWizzardConfigs.artnetMaxUniverses,
      itemBuilder: (BuildContext context, int index) {
        bool isPatched = false;
        bool isConnected = false;
        bool isSelected = false;
        Color textColor = Colors.lightBlue;
        Color boxColor = Colors.white;
        String info = "${index + 1}";

        if(selectedDevices.contains(index)){
          textColor = Colors.white;
          boxColor = Colors.lightBlue;
          isSelected = true;
        }

        if(patchedDevices.containsKey(index)){
          Mac searchMac = patchedDevices[index].mac;


          Device dev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device) => device.mac == searchMac, orElse: () => null);
          if(dev == null){
            if(isSelected){
              callback(List.from(selectedDevices)..remove(index));
            }
            info = patchedDevices[index].name;
            boxColor = Colors.grey;
            textColor = Colors.white;
          } else {
            info = dev.name;
            isConnected = true;
          }
          isPatched = true;
        }

        return GestureDetector(
          child: SizedBox(
            height: 33.0,
            child: Container(
              child: Center(
                child: Text(
                  info,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                    color: textColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: boxColor
              ),
            ),
          ),
          onTap: (){
            if(callback != null){
              if(isPatched && isConnected){
                callback(List<int>()..add(index));
              } else if(!isPatched){
                showDialog(
                  context: context,
                  child: StoreConnector<AppState, List<Device>>(
                    converter: (store) => store.state.availableDevices,
                    builder: (context, availableDevices) {
                      return PatchDeviceDialog(
                        index: index,
                        devices: availableDevices,
                      );
                    },
                  ),
                );
              }
            }
          },
          onDoubleTap: (){
            if(callback != null){
              if(isPatched && isConnected){
                if(isSelected){
                  callback(List.from(selectedDevices)..remove(index));
                } else {
                  callback(List.from(selectedDevices)..add(index));
                }
              } else {
                //nothing?
              }
            }
          },
          onLongPress: (){
            if(isPatched && isConnected){
              if(patchedDevices.containsKey(index)){
                if(isSelected){
                  //remove patch?
                } else {
                  //info?
                }
              } else {
                //nothing?
              }
            }
          },
        );
      },
    );
  }
}

class PatchDeviceDialog extends StatefulWidget {
  const PatchDeviceDialog({this.index, this.devices});

  final List<Device> devices;
  final int index;

  @override
  State createState() => new PatchDeviceDialogState();
}

class PatchDeviceDialogState extends State<PatchDeviceDialog> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListViewAlertDialog(
      title: new Text('Pick Device to Patch to slot ${widget.index}'),
      actions: <Widget>[
        new FlatButton(
          child: const Text("Cancel"),
          onPressed: ()=> Navigator.pop(context),
        ),
      ],
      content: new ListView.builder(
        itemCount: widget.devices.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext buildContext, int index){
          return GestureDetector(
            child: new ListTile(
              title: new Text(
                widget.devices[index].name,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            onTap: (){
              StoreProvider.of<AppState>(context).dispatch(AddPatchDevice(
                widget.index, 
                widget.devices[widget.index].mac,
                widget.devices[widget.index].name));
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}