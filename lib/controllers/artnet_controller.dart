import 'dart:async';
import 'dart:io';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/blizzard_devices.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/controllers/wait_for_packet.dart';

class ArtnetController{

  final Store store;
  ArtnetServer server;
  List<WaitForPacket> waitingList;

  ArtnetController(this.store){
    server = ArtnetServer(_onConnection, _onPoll, _handlePacket);
    waitingList = new List<WaitForPacket>();
  }

  void _onPoll(){

    List<Device> temp = List.from((store.state as AppState).availableDevices);

    for(final listDevice in temp){
      if(listDevice.activeTick <= 0){
        store.dispatch(RemoveAvailableDevice(listDevice));
      } else {
        store.dispatch(TickDownAvailableDevice(listDevice));
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
        _handleDeviceList(_packetToDevice(ArtnetPollReplyPacket(gram.data), gram.address));
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

  void _handleDeviceList(Device device){
    bool newDevice = true;

    List<Device> temp = List.from((store.state as AppState).availableDevices);

    for(final listDevice in temp){
      if(listDevice == device){
        if(!listDevice.compare(device)){
          store.dispatch(UpdateAvailableDevice(device));
        }
        newDevice = false;
        store.dispatch(TickResetAvailableDevice(listDevice));
        break;
      }
    }

    if(newDevice){
      store.dispatch(AddAvailableDevice(device));
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

  Device _packetToDevice(ArtnetPollReplyPacket packet, InternetAddress ip){

    Device device = Device(packet.mac,
    name: packet.longName,
    isBlizzard: packet.isBlizzardDevice,
    typeId: packet.blizzardType,
    fixtures: List<Fixture>(),
    address: ip);

    if(packet.isBlizzardDevice){
      ChannelMode mode = ChannelMode(
        name: "5 Channel",
        channels: <Channel>[
          Channel(name: "Red", number: 0),
          Channel(name: "Green", number: 1),
          Channel(name: "Blue", number: 2),
          Channel(name: "Amber", number: 3),
          Channel(name: "White", number: 4),
        ],  
      );
      device.fixtures.add(
        Fixture(
          packet.mac,
          name: BlizzardDevices.getDevice(packet.blizzardType),
          patchAddress: 33,
          channelMode: 0,
          profile: List<ChannelMode>()..add(mode)
        )
      );
    }

    return device;
  }
}



