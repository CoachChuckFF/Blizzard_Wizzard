import 'dart:io';
import 'dart:async';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:validator/validator.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';


class ArtnetServer{

  /*Internals*/
  InternetAddress _ownIp = InternetAddress.anyIPv4;
  Function _connectionCallback, _packetCallback, _pollCallback;
  RawDatagramSocket _socket;
  bool _connected = false;
  bool _beeped = false;
  bool _espBroadcast = false;
  bool _espEnabled = false;
  int _checkIpTO = BlizzardWizzardConfigs.checkIpTO;
  int _uuid = 0;

  ArtnetServer(this._connectionCallback, this._pollCallback, this._packetCallback){
    startServer();
  }

  void _handlePacket(RawSocketEvent e){
    Datagram gram = _socket.receive();
    var packet;

    if (gram == null) return;

    if(!ArtnetCheckPacket(gram.data)) return;

    if(ArtnetGetOpCode(gram.data) ==  ArtnetBeepBeepPacket.opCode){
      packet = ArtnetBeepBeepPacket(null, gram.data);
      if(packet.uuid == _uuid){
        _ownIp = gram.address;
        _beeped = true;
      }
    }

    if(_ownIp == gram.address) return;

    _packetCallback(gram);

  }

  void startServer(){
    if(_connected) return;

    RawDatagramSocket.bind(InternetAddress.anyIPv4, BlizzardWizzardConfigs.artnetPort).then((RawDatagramSocket socket){
      _socket = socket;
      _uuid = ArtnetGenerateBeepBeepUUID(DateTime.now().millisecondsSinceEpoch);
      print('UDP ready to receive');
      print('${socket.address.address}:${socket.port} - $_uuid');
      _connected = true;
      _socket.broadcastEnabled = true;
      _socket.listen(_handlePacket);

      _connectionCallback();

      //Kick off Timers!
      sendPacket(ArtnetBeepBeepPacket(_uuid).udpPacket);
      Timer(Duration(seconds: BlizzardWizzardConfigs.artnetPollDelay), _tick);
      Timer(Duration(seconds: BlizzardWizzardConfigs.artnetBeepDelay), _beep);
    });
  }

  void stopServer(){
    if(!_connected) return;

    _connected = false;
    _socket.close();
  }

  void sendPacket(List<int> packet,[InternetAddress ip, int port]){
    InternetAddress ipToSend = (_espEnabled) ? InternetAddress(BlizzardWizzardConfigs.espIp) : ((ip == null) ? InternetAddress(BlizzardWizzardConfigs.broadcast) : ip);
    int portToSend = (port == null) ? BlizzardWizzardConfigs.artnetPort : port; 

    if(_connected) _socket.send(packet, ipToSend, portToSend);
  }



  void _tick(){
    ArtnetPollPacket packet = ArtnetPollPacket();

    _pollCallback();

    sendPacket(packet.udpPacket);
    print("Tick");
    
    if(_connected){
      Timer(Duration(seconds: BlizzardWizzardConfigs.artnetPollDelay), _tick);
    }
  }

  void _beep(){
    ArtnetBeepBeepPacket packet = ArtnetBeepBeepPacket(_uuid);

    if(_beeped){
      if(!_espEnabled && _espBroadcast){
        _espEnabled = true;
      } else if(_checkIpTO-- <= 0 && !_espEnabled && !_espBroadcast){
        _checkIpTO = BlizzardWizzardConfigs.checkIpTO;
        _espBroadcast = true;
      }
    } else {
      if(_espEnabled){
        if(_espBroadcast){
          _espBroadcast = false;
          _espEnabled = false;
        }
      } else {
        if(_espBroadcast){
          _espBroadcast = false;
        } else {
          _espBroadcast = true;
        }
      }
    }
    _beeped = false;

    sendPacket(packet.udpPacket, InternetAddress((_espBroadcast) ? BlizzardWizzardConfigs.espIp : BlizzardWizzardConfigs.broadcast));
    print("Beep");
    
    if(_connected){
      Timer(Duration(seconds: BlizzardWizzardConfigs.artnetBeepDelay), _beep);
    }
  }

  List<int> populateOutgoingPollReply(){
    ArtnetPollReplyPacket reply = ArtnetPollReplyPacket();

    reply.ip = _ownIp.rawAddress;

    reply.port = 0x1936;

    reply.versionInfoH = 0;
    reply.versionInfoL = 1;

    reply.universe = 0;

    reply.oemHi = 0x12;
    reply.oemLo = 0x51;

    reply.ubeaVersion = 0;

    reply.status1ProgrammingAuthority = 2;
    reply.status1IndicatorState = 2;

    reply.estaManHi = 0x01;
    reply.estaManLo = 0x04;

    reply.shortName = "Baa";
    reply.longName = "Blizzard Art-Net Analyzer - Baa";

    reply.nodeReport = "!Enjoy the little things!";
    reply.packet.setUint8(ArtnetPollReplyPacket.nodeReportIndex, 0); //Sometimes you have to look for the little things

    reply.numPorts = 1;

    reply.portTypes[0] = ArtnetPollReplyPacket.portTypesProtocolOptionDMX;

    reply.style = ArtnetPollReplyPacket.styleOptionStNode;

    reply.status2HasWebConfigurationSupport = true;
    reply.status2DHCPCapable = true;

    return reply.udpPacket;
  }

  static String internetAddressToString(InternetAddress address){
    var temp = address.rawAddress;
    return temp[0].toString() + "." + temp[1].toString() + "." + temp[2].toString() + "." + temp[3].toString();
  }
}

