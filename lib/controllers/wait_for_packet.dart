import 'dart:io';
import 'dart:async';

class WaitForPacket{
  static int idCount = 0;

  final Function(List<int>) callback;
  final InternetAddress address;
  final int packetType; //OpCode
  final int timeout;

  int id;
  Timer timer;

  WaitForPacket(this.callback, this.address, this.packetType, this.timeout){
    id = idCount++;
  }

}