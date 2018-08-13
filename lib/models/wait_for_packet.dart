import 'dart:io';
import 'dart:async';
import 'package:d_artnet/d_artnet.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/models/models.dart';

class WaitForPacket{
  static int idCount = 0;

  final Function(List<int>) callback;
  final InternetAddress address;
  final int packetType; //OpCode
  final int timeout;

  int id;
  Timer timer = null;

  WaitForPacket(this.callback, this.address, this.packetType, this.timeout){
    id = idCount++;
  }

}