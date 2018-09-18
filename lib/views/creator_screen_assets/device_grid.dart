import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
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
        Color textColor = Theme.of(context).primaryColor;
        Color boxColor = Colors.white;
        String info = "${index + 1}";

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

          if(selectedDevices.contains(index)){
            textColor = Colors.white;
            boxColor = Theme.of(context).primaryColor;
            isSelected = true;
          }
        }

        return Material(
          color: boxColor,
          child: Container(
            child: InkWell(
              child: Center(
                child: Text(
                  info,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                    color: textColor,
                  ),
                ),
              ),
              onTap: (){
                if(callback != null){
                  if(isPatched && isConnected){
                    if(isSelected){
                      callback(List.from(selectedDevices)..remove(index));
                    } else {
                      callback(List.from(selectedDevices)..add(index));
                    }
                  } else if(!isPatched){
                    showDialog(
                      context: context,
                      child: StoreConnector<AppState, List<Device>>(
                        converter: (store) => store.state.availableDevices,
                        builder: (context, availableDevices) {
                          return PatchDeviceDialog(
                            index: index,
                            devices: availableDevices,
                            patchedDevices: patchedDevices,
                            callback: callback,
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
                      callback(<int>[]);
                    } else {
                      callback(patchedDevices.keys.toList());
                    }
                  } else if(!isPatched){
                    showDialog(
                      context: context,
                      child: StoreConnector<AppState, List<Device>>(
                        converter: (store) => store.state.availableDevices,
                        builder: (context, availableDevices) {
                          return PatchDeviceDialog(
                            index: index,
                            devices: availableDevices,
                            patchedDevices: patchedDevices,
                            callback: callback,
                          );
                        },
                      ),
                    );
                  }
                }
              },
              onLongPress: (){
                if(isPatched && isConnected){
                  showDialog(
                    context: context,
                    child: StoreConnector<AppState, List<Device>>(
                      converter: (store) => store.state.availableDevices,
                      builder: (context, availableDevices) {
                        return EditDeviceDialog(
                          index: index,
                          devices: availableDevices,
                          patchedDevices: patchedDevices,
                          callback: callback,
                        );
                      },
                    ),
                  );
                } else if(!isPatched){
                  showDialog(
                    context: context,
                    child: StoreConnector<AppState, List<Device>>(
                      converter: (store) => store.state.availableDevices,
                      builder: (context, availableDevices) {
                        return PatchDeviceDialog(
                          index: index,
                          devices: availableDevices,
                          patchedDevices: patchedDevices,
                          callback: callback,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          )
        );
      },
    );
  }
}

class PatchDeviceDialog extends StatelessWidget {
 
  PatchDeviceDialog({this.index, this.devices, this.patchedDevices, this.callback});

  final List<Device> devices;
  final Map<int, PatchedDevice> patchedDevices;
  final ValueChanged<List<int>> callback;
  final int index;

  Widget build(BuildContext context) {
    Map<int, PatchedFixture> patchedFixtures;
    List<Device> availableDevices = List<Device>();

    devices.forEach((device){
      if(!patchedDevices.containsValue(PatchedDevice(
        mac: device.mac,
      ))){
        availableDevices.add(device);
      }
    });

    return ListViewAlertDialog(
      title: Text('Select Device to Patch',
        style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Robot",
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: (availableDevices.length == 0) ?
            Tooltip(
              preferBelow: false,
              message: "Stop that tickles",
              child: Text(
                "No Devices Found",
                style: Theme.of(context).textTheme.title,
              ),
            ) :
            ListView.builder(
              itemCount: availableDevices.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext buildContext, int index){
                return InkWell(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        availableDevices[index].name,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  onTap: (){
                    StoreProvider.of<AppState>(context).dispatch(AddPatchDevice(
                      this.index, 
                      PatchedDevice(
                        mac: availableDevices[index].mac,
                        name: availableDevices[index].name,
                      )));


                    if(availableDevices[index].fixture != null){
                      patchedFixtures = StoreProvider.of<AppState>(context).state.show.patchedFixtures;
                      PatchedFixture fixture = patchedFixtures.values.firstWhere((fix){
                        return fix.fromDevice;
                      }, orElse: (){return null;});

                      if(fixture == null){
                        int freeIndex = 0;
                        while(true){ //this scares me
                          if(!StoreProvider.of<AppState>(context).state.show.patchedFixtures.containsKey(freeIndex)){
                            break;
                          }
                          freeIndex++;
                        }
                        StoreProvider.of<AppState>(context).dispatch(AddPatchFixture(
                          freeIndex, 
                          PatchedFixture(
                            mac: availableDevices[index].mac,
                            name: "D ${availableDevices[index].fixture.name}",
                            fixture: availableDevices[index].fixture,
                            fromDevice: true,
                          )));
                      }
                    }
      
                    callback([this.index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.blue,
              child: Container(
                child: InkWell(
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontFamily: "Robot",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              )
            )
          ),
        ]
      )
    );
  }
}

class EditDeviceDialog extends StatefulWidget {
 
  EditDeviceDialog({this.index, this.devices, this.patchedDevices, this.callback});

  final List<Device> devices;
  final Map<int, PatchedDevice> patchedDevices;
  final ValueChanged<List<int>> callback;
  final int index;

  @override
  createState() => EditDeviceDialogState();
}

class EditDeviceDialogState extends State<EditDeviceDialog> {
  bool clearAll;

  EditDeviceDialogState();

  @override
  initState() {
    super.initState();
    clearAll = false;
  }

  Widget build(BuildContext context) {
    Mac searchMac = widget.patchedDevices[widget.index].mac;
    Map<int, PatchedFixture> patchedFixtures;
    List<PatchedFixture> fixtures = List<PatchedFixture>();

    patchedFixtures = StoreProvider.of<AppState>(context).state.show.patchedFixtures;

    patchedFixtures.values.forEach((fixture){
      if(fixture.mac == searchMac){
        fixtures.add(fixture);
      }
    });

    return ListViewAlertDialog(
      title: Text('Fixtures Connected to ${widget.patchedDevices[widget.index].name}',
        style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Robot",
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: (fixtures.length == 0) ?
            Tooltip(
              preferBelow: false,
              message: "Oh hello there",
              child: Text(
                "No Fixtures Connected",
                style: Theme.of(context).textTheme.title,
              ),
            ) :
            ListView.builder(
              itemCount: fixtures.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext buildContext, int index){
                return Tooltip(
                  preferBelow: false,
                  message: "${fixtures[index].name} patched at address ${fixtures[index].fixture.patchAddress}",
                  child: Card(
                    child: ListTile(
                      title: Text(
                        fixtures[index].name,
                        style: Theme.of(context).textTheme.title,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                      trailing: Text(
                        "${fixtures[index].fixture.patchAddress}",
                        style: Theme.of(context).textTheme.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.red,
              child: Container(
                child: InkWell(
                  child: Center(
                    child: Text(
                      (clearAll) ? "Unpatch All Devices" : "Unpatch Device",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontFamily: "Robot",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: (){
                    if(clearAll){
                      StoreProvider.of<AppState>(context).dispatch(ClearPatchDevice());
                    } else {
                      StoreProvider.of<AppState>(context).dispatch(RemovePatchDevice(
                        widget.index));
                    }
                    widget.callback([]);
                    Navigator.pop(context);
                  },
                  onLongPress: (){
                    setState(() {
                      clearAll = !clearAll;
                    });
                  },
                ),
              )
            )
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.blue,
              child: Container(
                child: InkWell(
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 21.0,
                        fontFamily: "Robot",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              )
            )
          ),
        ]
      )
    );
  }
}