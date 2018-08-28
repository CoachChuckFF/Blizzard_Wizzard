import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_dialog.dart';


class DeviceGrid extends StatelessWidget {
  final int cols;
  final double fontSize = 20.0;
  final String fontFamily = "Roboto";
  final Map<int, Mac> patchedDevices;
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
        Color textColor = Colors.lightBlue;
        Color boxColor = Colors.white;

        if(selectedDevices.contains(index)){
          textColor = Colors.white;
          boxColor = Colors.lightBlue;
        }

        return GestureDetector(
          child: SizedBox(
            height: 33.0,
            child: Container(
              child: Center(
                child: Text(
                  '${index + 1}',
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
              if(patchedDevices.containsKey(index)){
                callback(List<int>()..add(index));
              } else {
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
              if(patchedDevices.containsKey(index)){
                if(selectedDevices.contains(index)){
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
            if(callback != null){
              if(patchedDevices.containsKey(index)){
                if(selectedDevices.contains(index)){
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
              StoreProvider.of<AppState>(context).dispatch(AddPatchDevice(widget.index, widget.devices[widget.index].mac));
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}