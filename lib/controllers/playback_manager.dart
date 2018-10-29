import 'dart:async';
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/scene.dart';

LightPlayerStoreProvider lsexplorer;

class LightPlayerStoreProvider{
  Store store;
  LightPlayerStoreProvider(this.store);
}

class LightPlayer{
  DateTime before;
  List<Scene> scenes;
  Timer timer;
  int index;

  LightPlayer(List<Scene> scenes){
    this.scenes = List.from(scenes);
    index = 0;
    before = DateTime.now();
  }

  void setIndex(int index){
    this.index = index;
    
    _show();
  }

  void update(List<Scene> scenes){
    this.scenes = List.from(scenes);
    index = 0;
  }

  void play(){
    int hold = scenes[index].hold.getDelay();

    if(hold == 0){
      _show();
    } else{
      timer = Timer(
        Duration(
          milliseconds: hold
        ),
        _timerCallback
      );
    }
  }

  void pause(){
    if(timer != null){
      timer.cancel();
    }
  }

  void next(){
    if(++index > scenes.length-1){
      index = 0;
    }

    _show();
  }

  void prev(){
    if(--index < 0){
      index = scenes.length-1;
    }

    _show();
  }

  void reset(){
    index = 0;
    _show();
  }

  void dispose(){
    pause();
  }

  void dim(int dimmer){
    if(dimmer > 255) dimmer = 255;
    if(dimmer < 0) dimmer = 0;
  }

  void _timerCallback(){
    next();

    int hold = scenes[index].hold.getDelay();
    timer = Timer(
      Duration(
        milliseconds: hold
      ),
      _timerCallback
    );
  }

  void _show(){
    DateTime now = DateTime.now();
    print(now.difference(before).inMilliseconds);
    before = now;

    scenes[index].sceneData.forEach((data){
  
      Device dev = lsexplorer.store.state.availableDevices.firstWhere((device){
        return device.mac == data.mac;
      }, orElse: (){return null;});

      if(dev != null){
        for(int i = 0; i < 512; i++){
          dev.dmxData.setDmxValue(i + 1, data.dmx[i]);
        }
        tron.server.sendPacket(dev.dmxData.udpPacket, dev.address);
      }
    });
  }

}