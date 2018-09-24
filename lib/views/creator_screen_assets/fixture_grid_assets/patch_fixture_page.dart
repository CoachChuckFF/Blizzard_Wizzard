import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';

class PatchFixturePage extends StatefulWidget {
 
  final ValueChanged<int> callback;
  final Fixture fixture;
  final int lastPage;
  final int startAddress;
  final int fixtureCount;

  PatchFixturePage({this.callback, this.fixture, this.fixtureCount = 1, this.startAddress = 1,
    this.lastPage});

  @override
  createState() => PatchFixturePageState();
}


class PatchFixturePageState extends State<PatchFixturePage> {
  bool _hasDeviceLink;
  int _startAddress;
  int _fixtureCount;
  PatchedDevice linkDevice;
  Key _endKey;
  Key _startKey;

  PatchFixturePageState();

  @override
  initState() {
    super.initState();

    _hasDeviceLink = false;

    _startAddress = 1;
    _fixtureCount = 1;
    _startKey = Key("SK");
    _endKey = Key("EK");
  }

  Widget build(BuildContext context) {

    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Patch Fixture",
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
          text: "Back",
          color: Colors.blue,
          onTap: (){
            widget.callback(widget.lastPage);
          }
        ),
        BlizzardDialogButton(
          text: (_hasDeviceLink) ? "Patch" : "Link Device",
          color: Colors.green,
          onTap: (){
            if(_hasDeviceLink){
              Navigator.of(context).pop();
            } else {
                showDialog(
                context: context,
                child: StoreConnector<AppState, List<Device>>(
                  converter: (store) => store.state.availableDevices,
                  builder: (context, availableDevices) {
                    return LinkDeviceDialog(
                      devices: availableDevices,
                      callback: (device){
                        if(device == null){
                          return;
                        }
                        setState(() {
                          this.linkDevice = device;
                          this._hasDeviceLink = true;
                        });
                      },
                    );
                  },
                ),
              );
            }
          }
        ),
      ],
      content: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text(
                (_hasDeviceLink) ? linkDevice.name : "Link Device",
              ),
              trailing: Icon(
                (_hasDeviceLink) ? Icons.change_history: Icons.add
              ),
              onTap: (){
                showDialog(
                  context: context,
                  child: StoreConnector<AppState, List<Device>>(
                    converter: (store) => store.state.availableDevices,
                    builder: (context, availableDevices) {
                      return LinkDeviceDialog(
                        devices: availableDevices,
                        callback: (device){
                          if(device == null){
                            return;
                          }
                          setState(() {
                            this.linkDevice = device;
                            this._hasDeviceLink = true;
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Start Address",
                            style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: (){
                          setState(() {
       
                          });
                        }
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                            headline: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold
                            ),
                            body1: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                            )
                          )
                        ),
                        child: NumberPicker.integer(
                          key: _startKey,
                          listViewWidth: double.infinity,
                          itemExtent: 89.0,
                          initialValue: _startAddress,
                          minValue: 1,
                          maxValue: 512/*512-(widget.fixture.getCurrentChannels().channels.length * _fixtureCount)*/,
                          onChanged: (start){
                          setState(() {
                            _startAddress = start;

                          });
                        }),
                      )
                    ],
                  )
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Fixture Count",
                            style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: (){
                          setState(() {
         
                          });
                        },
                        onDoubleTap: (){
                          setState(() {
        
                          });
                        },
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          accentColor: Colors.red,
                          textTheme: Theme.of(context).textTheme.copyWith(
                            headline: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold
                            ),
                            body1: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                            )
                          )
                        ),
                        child: NumberPicker.integer(
                          key: _endKey,
                          listViewWidth: double.infinity,
                          itemExtent: 89.0,
                          initialValue: _fixtureCount,
                          minValue: 1,
                          maxValue: ((512-_startAddress)/widget.fixture.getCurrentChannels().channels.length).truncate(),
                          onChanged: (count){
                          setState(() {
                            _fixtureCount = count;
     
                          });
                        }),
                      )
                    ],
                  )
                ),
              ],
            )
          ),
        ]
      )
    );
  }
}

class LinkDeviceDialog extends StatelessWidget {
 
  LinkDeviceDialog({this.devices, this.callback});

  final List<Device> devices;
  final ValueChanged<PatchedDevice> callback;

  Widget build(BuildContext context) {
    List<PatchedDevice> availableDevices = List<PatchedDevice>();

    Map<int, PatchedDevice> patchedDevices = StoreProvider.of<AppState>(context).state.show.patchedDevices;

    availableDevices.insertAll(0, patchedDevices.values);

    devices.forEach((device){
      if(!patchedDevices.containsValue(PatchedDevice(
        mac: device.mac,
      ))){
        availableDevices.add(PatchedDevice(
          mac: device.mac,
          name: device.name
        ));
      }
    });

    availableDevices.sort((dev1, dev2){
      return dev1.name.compareTo(dev2.name);
    });

    return ListViewAlertButtonsDialog(
      title: Text('Select Device to Link',
        style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Robot",
        ),
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Cancel",
          color: Colors.red,
          onTap: (){
            Navigator.of(context).pop();
          }
        ),
      ],
      content: ListView(
        children: <Widget>[
          ListView.builder(
            itemCount: availableDevices.length + 1,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (BuildContext buildContext, int index){
              if(index-- == 0){
                return (availableDevices.length == 0) ? ListTile(
                  title: Text(
                    "No Devices Found",
                    style: Theme.of(context).textTheme.title,
                  ),
                ) : Container();
              }

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

                  callback(availableDevices[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ]
      )
    );
  }
}