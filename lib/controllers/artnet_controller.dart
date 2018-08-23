import 'dart:async';
import 'dart:io';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:redux/redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
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

    List<Fixture> temp = List.from((store.state as AppState).availableDevices);

    for(final listFixture in temp){
      if(listFixture.activeTick <= 0){
        store.dispatch(RemoveAvailableDevice(listFixture));
      } else {
        store.dispatch(TickDownAvailableDevice(listFixture));
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
        _handleDeviceList(_packetToFixture(ArtnetPollReplyPacket(gram.data), gram.address));
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

  void _handleDeviceList(Fixture fixture){
    bool newDevice = true;

    List<Fixture> temp = List.from((store.state as AppState).availableDevices);

    for(final listFixture in temp){
      if(listFixture == fixture){
        if(!listFixture.compare(fixture)){
          fixture.id = listFixture.id;
          fixture.patchAddress = listFixture.patchAddress;
          store.dispatch(UpdateAvailableDevice(fixture));
        }
        newDevice = false;
        store.dispatch(TickResetAvailableDevice(listFixture));
        break;
      }
    }

    if(newDevice){
      store.dispatch(AddAvailableDevice(fixture));
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

  Fixture _packetToFixture(ArtnetPollReplyPacket packet, InternetAddress ip){
    Fixture fixture = Fixture(packet.mac);

    fixture.name = packet.longName;
    fixture.isBlizzard = packet.isBlizzardDevice;
    fixture.typeId = packet.blizzardType;
    fixture.universe = packet.universe;
    fixture.address = ip;

    return fixture;

  }

}



