import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/device_grid.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_button_bar.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_manipulator_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_manipulator_button_bar.dart';


class CreatorScreen extends StatefulWidget {
  @override
  createState() => CreatorScreenState();
}

class CreatorScreenState extends State<CreatorScreen> {
  final double fontSize = 20.0;
  final String fontFamily = "Roboto";

  List<int>selectedDevices;
  List<int>selectedFixtures;
  
  int configState;
  int deviceFixtureState;

  List<Device> _generateDeviceList(){
    List<Device> devices = List<Device>();

    if(deviceFixtureState == DeviceFixtureGridState.device){
      selectedDevices.forEach((index){
        if(StoreProvider.of<AppState>(context).state.show.patchedDevices.containsKey(index)){
          Mac searchMac = StoreProvider.of<AppState>(context).state.show.patchedDevices[index].mac;
          Device addDev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device){
            return device.mac == searchMac;
          }, orElse: (){ return null; });
          if(addDev != null){
            devices.add(addDev);
          }
        }
      });
    } else {
      selectedFixtures.forEach((index){
        if(StoreProvider.of<AppState>(context).state.show.patchedFixtures.containsKey(index)){
          Mac searchMac = StoreProvider.of<AppState>(context).state.show.patchedFixtures[index].mac;
          Device addDev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device){
            return device.mac == searchMac;
          }, orElse: (){ return null; });
          if(addDev != null){
            devices.add(addDev);
          }
        }
      });
    }
    return devices;
  }

  @override
  void initState() {
    super.initState();
    configState = LightingConfigState.color;
    deviceFixtureState = DeviceFixtureGridState.device;
    selectedDevices = List<int>();
    selectedFixtures = List<int>();
  }

  @override
  Widget build(BuildContext context) {
    List<Device> devices = _generateDeviceList();

    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Tooltip(
                          message: "Devices",
                          child: FlatButton(
                            color: (deviceFixtureState == DeviceFixtureGridState.device) ? Colors.black : Colors.white,
                            child: Icon(
                              Icons.ac_unit,
                              color: (deviceFixtureState == DeviceFixtureGridState.device) ? Colors.white : Colors.black,
                            ), 
                            onPressed: (){
                              if(deviceFixtureState != DeviceFixtureGridState.device){
                                setState(() {
                                  if(configState == LightingConfigState.channels){
                                    configState = LightingConfigState.dmx;
                                  }
                                  deviceFixtureState = DeviceFixtureGridState.device;
                                });
                              }
                            },
                          )
                        )
                      ),
                      Expanded(
                        child: Tooltip(
                        message: "Fixtures",
                          child: FlatButton(
                            color: (deviceFixtureState == DeviceFixtureGridState.fixture) ? Colors.black : Colors.white,
                            child: Icon(
                              Icons.adjust,
                              color: (deviceFixtureState == DeviceFixtureGridState.fixture) ? Colors.white : Colors.black,
                            ), 
                            onPressed: (){
                              if(deviceFixtureState != DeviceFixtureGridState.fixture){
                                setState(() {
                                  if(configState == LightingConfigState.dmx){
                                    configState = LightingConfigState.channels;
                                  }
                                  deviceFixtureState = DeviceFixtureGridState.fixture;
                                });
                              }
                            },
                          )
                        )
                      ),
                    ]
                  )
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          (deviceFixtureState == DeviceFixtureGridState.device) ? "Patched Devices" : "Pathced Fixtures",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: fontFamily
                          )
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: (deviceFixtureState == DeviceFixtureGridState.fixture) ? 
                        Theme(
                          data: ThemeData(primarySwatch: DeviceFixtureGridColor.fixture),
                          child: StoreConnector<AppState, Map<int,PatchedFixture>>(
                            converter: (store) => store.state.show.patchedFixtures,
                            builder: (context, patchedFixtures) {
                              return FixtureGrid(
                                patchedFixtures: patchedFixtures,
                                selectedFixtures: selectedFixtures,
                                callback: (selectedFixtures){
                                  setState(() {
                                      this.selectedFixtures = selectedFixtures;                               
                                  });
                                },
                              );
                            },
                          ),
                        ) :
                        Theme(
                          data: ThemeData(primarySwatch: DeviceFixtureGridColor.device),
                          child: StoreConnector<AppState, Map<int,PatchedDevice>>(
                            converter: (store) => store.state.show.patchedDevices,
                            builder: (context, patchedDevices) {
                              return DeviceGrid(
                                patchedDevices: patchedDevices,
                                selectedDevices: selectedDevices,
                                callback: (selectedDevices){
                                  setState(() {
                                      this.selectedDevices = selectedDevices;                               
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ),
              ]
            )
          ),
        ),
        Expanded(
          flex: 1,
          child: SceneButtonBar(),
        ),
        Expanded(
          flex: 1,
          child: SceneManipulatorButtonBar(
            state: configState,
            fixtureState: deviceFixtureState,
            callback: (state){
              setState(() {
                configState = state;                
              });
            },
          ),
        ),
      Expanded(
          flex: 5,
          child: SceneManipulatorArea(
            state: configState,
            devices: devices,  
          )
        )
      ],
    );

  }
}
