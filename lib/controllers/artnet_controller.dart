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

  ArtnetController(this.store){
    server = ArtnetServer(_onConnection, _onPoll, _handlePacket);
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

    return Profile(packet.longName, "unknown", ip, packet.universe);

  }

}



