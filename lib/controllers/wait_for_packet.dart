import 'dart:io';
import 'dart:async';

class WaitForPacket{
  static int idCount = 0;

  final Function(List<int>, String) callback;
  final String onSuccess;
  final String onFailure;
  final InternetAddress address;
  final int packetType; //OpCode
  final Duration preWait;
  final Duration timeout;

  int id;
  bool preWaiting;
  Timer timer;

  WaitForPacket(this.callback, this.address, this.packetType, this.timeout, {this.onSuccess, this.onFailure, this.preWait}){
    id = idCount++;

    if(this.preWait == null){
      preWaiting = false;
    } else {
      preWaiting = true;
    }
  }

  void callCallback(List<int> data){
    if(this.callback != null){
      this.callback(data, (data == null) ? this.onFailure : this.onSuccess);
    }
  }

}