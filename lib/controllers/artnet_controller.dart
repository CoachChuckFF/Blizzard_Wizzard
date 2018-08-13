import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:io';
import 'dart:async';
import 'package:d_artnet/d_artnet.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';

class ArtnetController{

  final Store store;
  ArtnetServer server;
  List<WaitForPacket> waitingList;

  ArtnetController(this.store){
    server = ArtnetServer(_onConnection, _onPoll, _handlePacket);
    waitingList = new List<WaitForPacket>();
  }

  void _onPoll(){

    List<Profile> temp = List.from((store.state as AppState).availableDevices);

    for(final listProfile in temp){
      if(listProfile.activeTick <= 0){
        store.dispatch(RemoveAvailableDevice(listProfile));
      } else {
        store.dispatch(TickDownAvailableDevice(listProfile));
      }
    }
  }

  void _onConnection(){
    print("Connected");
  }

  void _handlePacket(Datagram gram){

    _checkWaitingList(gram);

    switch(ArtnetGetOpCode(gram.data)){
      case ArtnetPollPacket.opCode:
        server.sendPacket(server.populateOutgoingPollReply(), gram.address);
        print("Got Poll");
      break;
      case ArtnetPollReplyPacket.opCode:
        /*Important*/
        _handlePollReply();
        _handleDeviceList(_packetToProfile(ArtnetPollReplyPacket(gram.data), gram.address));
      break;
      case ArtnetIpProgReplyPacket.opCode:
        /*Important*/
        _handleProgReply();
      break;
      case ArtnetCommandPacket.opCode:
        /*Important*/
        _handleCommand();
      break;
      case ArtnetFirmwareReplyPacket.opCode:
        /*Importnant*/
        _handleFirmwareReply();
      break;
      default:
        return; //unknown packet
    }
  }

  void addToWaitingList(WaitForPacket wait){
    waitingList.add(wait);
    wait.timer = Timer(Duration(milliseconds: wait.timeout), () => _removeFromWaitingList(wait.id, null));
  }

  void _checkWaitingList(Datagram gram){

    waitingList.where((wait) => wait.address == gram.address)
      .toList()
      .forEach((wait){
        if(wait.packetType == ArtnetGetOpCode(gram.data)){
          wait.timer.cancel();
          _removeFromWaitingList(wait.id, gram.data);
        }
      });
  }

  void _removeFromWaitingList(int id, List<int> data){
    int waitingIndex = waitingList.indexWhere((wait) => wait.id == id);

    if(waitingIndex != -1){
      waitingList[waitingIndex].callback(data);
      waitingList.removeAt(waitingIndex);
    }    
  }

  void _handleDeviceList(Profile profile){
    bool newDevice = true;

    List<Profile> temp = List.from((store.state as AppState).availableDevices);

    for(final listProfile in temp){
      if(listProfile == profile){
        newDevice = false;
        store.dispatch(TickResetAvailableDevice(listProfile));
        break;
      }
    }

    if(newDevice){
      store.dispatch(AddAvailableDevice(profile));
    }
  }

  void _handlePollReply(){
    print("Got Poll Reply");
  }

  void _handleProgReply(){
    print("Got Prog Reply");

  }

  void _handleCommand(){
    print("Got Command");
  }

  void _handleFirmwareReply(){
    print("Got Firmware Reply");
    server.sendPacket([0]);
  }

  void alertPacket(){
    //update state
  }

  void waitForPacket(){
  }

  Profile _packetToProfile(ArtnetPollReplyPacket packet, InternetAddress ip){

    return Profile(packet.longName,
                  packet.blizzardType, 
                  ip, 
                  packet.isBlizzardDevice,
                  packet.universe);

  }

}



