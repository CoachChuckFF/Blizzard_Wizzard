import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/device_grid.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_button_bar.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_manipulator_area.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_manipulator_button_bar.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/scene_select_dialog.dart';


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

  void _handleSaveTap(){
    showDialog(
      context: context,
      child: SceneSelectDialog(
        isLoad: false,
        selectedDevices: (deviceFixtureState == DeviceFixtureGridState.device) ? selectedDevices: null,
        selectedFixtures: (deviceFixtureState == DeviceFixtureGridState.fixture) ? selectedFixtures: null,
      )
    );
  }

  void _handleSaveDoubleTap(){
    List<SceneData> data = List<SceneData>();
    List<Mac> macs = List<Mac>();

    if(deviceFixtureState == DeviceFixtureGridState.fixture){
      selectedFixtures.forEach((key){
        macs.add(StoreProvider.of<AppState>(context).state.show.patchedFixtures[key].mac);
      });
    } else {
      selectedDevices.forEach((key){
        macs.add(StoreProvider.of<AppState>(context).state.show.patchedDevices[key].mac);
      });
    }

    StoreProvider.of<AppState>(context).state.availableDevices.forEach((device){
      if(macs.contains(device.mac)){
        data.add(
          SceneData(
            device.mac,
            List.from(device.dmxData.dmx)
          )
        );
      }
    });

    if(StoreProvider.of<AppState>(context).state.show.cues.length == 0){
      StoreProvider.of<AppState>(context).dispatch(AddCue(
        Cue(
          scenes: List<Scene>()..add(
            Scene(
              sceneData: data
            )
          ) 
        )
      ));
      StoreProvider.of<AppState>(context).dispatch(SetCurrentCue(0));
    } else {
      Scene newScene = Scene(
        sceneData:data,
      );
      Scene lastScene = StoreProvider.of<AppState>(context).state.show.cues.last.scenes.last;

      if(lastScene != null){
        newScene = newScene.copyWith(
          hold: lastScene.hold,
          xFade: lastScene.xFade,
          fadeIn: lastScene.fadeIn,
          fadeOut: lastScene.fadeOut,
        );
      }

      StoreProvider.of<AppState>(context).dispatch(AddScene(
        newScene,
        StoreProvider.of<AppState>(context).state.show.currentCue,
      ));
    }
  }

  void _handleLoadTap(){
    showDialog(
      context: context,
      child: SceneSelectDialog(
        isLoad: true,
        selectedDevices: (deviceFixtureState == DeviceFixtureGridState.device) ? selectedDevices: null,
        selectedFixtures: (deviceFixtureState == DeviceFixtureGridState.fixture) ? selectedFixtures: null,
        callback: (selected){
          if(deviceFixtureState == DeviceFixtureGridState.device){
            setState((){
              selectedDevices = selected;
            });
          } else {
            setState((){
              selectedFixtures = selected;
            });
          }
        },
      )
    );
  }

  void _handleLoadDoubleTap(){

    if(StoreProvider.of<AppState>(context).state.show.cues.length == 0){
      return;
    }

    Cue cue = StoreProvider.of<AppState>(context).state.show.cues[StoreProvider.of<AppState>(context).state.show.currentCue];

    if(cue.scenes.length == 0){
      return;
    }

    Scene scene = cue.scenes.last;

    scene.sceneData.forEach((data){
      Device dev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device){
        return device.mac == data.mac;
      }, orElse: (){return null;});

      if(dev != null){
        int i = 0;

        if(deviceFixtureState == DeviceFixtureGridState.fixture){
          StoreProvider.of<AppState>(context).state.show.patchedFixtures.forEach((key, value){
            if(value.mac == data.mac){
              if(!selectedFixtures.contains(key)){
                selectedFixtures.add(key);
              }
            }
          });
        } else {
          StoreProvider.of<AppState>(context).state.show.patchedDevices.forEach((key, value){
            if(value.mac == data.mac){
              if(!selectedDevices.contains(key)){
                selectedDevices.add(key);
              }
            }
          });
        }

        data.dmx.forEach((value){
          dev.dmxData.setDmxValue(i++, value);
        });

        tron.server.sendPacket(dev.dmxData.udpPacket, dev.address);
      }

    });

    setState(() {});
  }

  void _handleBlackoutTap(){
    List<Mac> macs = List<Mac>();

    StoreProvider.of<AppState>(context).state.show.patchedFixtures.values.forEach((fixture){
      if(!macs.contains(fixture.mac)){
        macs.add(fixture.mac);
      }
    });

    StoreProvider.of<AppState>(context).state.show.patchedDevices.values.forEach((device){
      if(!macs.contains(device.mac)){
        macs.add(device.mac);
      }
    });

    StoreProvider.of<AppState>(context).state.availableDevices.where((device){
      return macs.contains(device.mac);
    }).forEach((device){
      device.dmxData.blackout();
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });
  }

  void _handleBlackoutDoubleTap(){

    StoreProvider.of<AppState>(context).state.availableDevices.forEach((device){
      device.dmxData.blackout();
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });
  }

  List<Device> _generateDeviceList(){
    List<Device> devices = List<Device>();

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

    return devices;
  }

  Map<Device, List<Fixture>> _generateDeviceMap(){
    Map<Device, List<Fixture>> devices = Map<Device, List<Fixture>>();

    selectedFixtures.forEach((index){
      if(StoreProvider.of<AppState>(context).state.show.patchedFixtures.containsKey(index)){
        PatchedFixture fixture = StoreProvider.of<AppState>(context).state.show.patchedFixtures[index];
        Device addDev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device){
          return device.mac == fixture.mac;
        }, orElse: (){ return null; });
        if(addDev != null){
          if(devices.containsKey(addDev)){
            devices[addDev].add(fixture.fixture);
          } else {
            devices[addDev] = List<Fixture>()..add(fixture.fixture);
          }
        }
      }
    });

    return devices;
  }

  @override
  void initState() {
    super.initState();
    configState = LightingConfigState.color;
    deviceFixtureState = DeviceFixtureGridState.fixture;
    selectedDevices = List<int>();
    selectedFixtures = List<int>();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Tooltip(
                        message: "Fixtures",
                          child: FlatButton(
                            color: (deviceFixtureState == DeviceFixtureGridState.fixture) ? Colors.black : Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.ac_unit,
                                size: 30.0,
                                color: (deviceFixtureState == DeviceFixtureGridState.fixture) ? Colors.white : Colors.black,
                              ), 
                            ),
                            onPressed: (){
                              if(deviceFixtureState != DeviceFixtureGridState.fixture){
                                setState(() {
                                  configState = LightingConfigState.color;
                                  deviceFixtureState = DeviceFixtureGridState.fixture;
                                });
                              }
                            },
                          )
                        )
                      ),
                      Expanded(
                        child: Tooltip(
                          message: "Devices",
                          child: FlatButton(
                            color: (deviceFixtureState == DeviceFixtureGridState.device) ? Colors.black : Colors.white,
                            child: Icon(
                              Icons.adjust,
                              size: 30.0,
                              color: (deviceFixtureState == DeviceFixtureGridState.device) ? Colors.white : Colors.black,
                            ), 
                            onPressed: (){
                              if(deviceFixtureState != DeviceFixtureGridState.device){
                                setState(() {
                                  configState = LightingConfigState.dmx;
                                  deviceFixtureState = DeviceFixtureGridState.device;
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
                  flex: 10,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          (deviceFixtureState == DeviceFixtureGridState.device) ? "Patched Devices" : "Patched Fixtures",
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
          child: SceneButtonBar(
            onSaveTap: _handleSaveTap,
            onSaveDoubleTap: _handleSaveDoubleTap,
            onLoadTap: _handleLoadTap,
            onLoadDoubleTap: _handleLoadDoubleTap,
            onBlackoutTap: _handleBlackoutTap,
            onBlackoutDoubleTap: _handleBlackoutDoubleTap,
          ),
        ),
        Expanded(
          flex: 1,
          child: Theme(
            data: (deviceFixtureState == DeviceFixtureGridState.fixture) ? 
              ThemeData(primarySwatch: DeviceFixtureGridColor.fixture):
              ThemeData(primarySwatch: DeviceFixtureGridColor.device),
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
        ),
      Expanded(
          flex: 5,
          child: (deviceFixtureState == DeviceFixtureGridState.device) ?
          SceneManipulatorArea(
            state: configState,
            devices: _generateDeviceList(),  
          ) : 
          SceneManipulatorArea(
            state: configState,
            deviceMap: _generateDeviceMap(),  
          ), 
        )
      ],
    );

  }
}
