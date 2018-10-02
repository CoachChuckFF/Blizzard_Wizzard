import 'dart:math';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class KeyColors{
  static const List<Color>colors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.red,
    Colors.black
  ];

  var rng;

  KeyColors(int seed){
    this.rng = Random(seed);
  }

  Color getRandColor(){
    return colors[this.rng.nextInt(colors.length)];
  }
}

class KeypadArea extends StatefulWidget {
  static int randSeed = 0;
  final List<Device> devices;

  KeypadArea({@required this.devices}){
    randSeed++;
  }

  @override
  createState() => KeypadAreaState();
}

class KeypadAreaState extends State<KeypadArea> {

  KeyColors keyColors;
  List<String> command;
  bool messagePresent;

  _execute(){
    var channel;
    var channelTo;
    var value;

    int atIndex = command.indexOf("@");

    if(atIndex == -1 || atIndex >= command.length - 1) return;

    if(command[0] == "Full"){
      channel = 1;
      channelTo = 512;
    } else {

      int thruIndex = command.indexOf("->");
      String preamble = "";

      if(thruIndex == -1){
        for(int i = 0; i < atIndex; i++){
          preamble += command[i];
        }

        channel = int.tryParse(preamble);

        if(channel == null) return;

        
      } else {
        for(int i = 0; i < thruIndex; i++){
          preamble += command[i];
        }

        channel = int.tryParse(preamble);

        if(channel == null) return;


        preamble = "";

        for(int i = thruIndex + 1; i < atIndex; i++){
          preamble += command[i];
        }

        channelTo = int.tryParse(preamble);

        if(channelTo == null) return;

      }
    }

    String postamble = "";

    if(command[atIndex + 1] == "Full"){
      value = 255;
    } else {
      for(int i = atIndex + 1; i < command.length; i++){
        postamble += command[i];
      }

      value = int.tryParse(postamble);

      if(value == null) return;

    }

    if(value < 0 || value > 0xFF) return;

    if(channel < 1 || channel > 512) return;


    if(channelTo == null){
      widget.devices.forEach((device){
        device.dmxData.setDmxValue(channel, value);
        tron.server.sendPacket(device.dmxData.udpPacket, device.address);
      });
    } else {
      if(channelTo < 1 || channelTo > 512) return;

      widget.devices.forEach((device){
        List<int> addresses = List<int>();
        for(int i = channel; i < channelTo + 1; i++){
          addresses.add(i);
        }
        device.dmxData.setDmxValues(addresses, value);
        tron.server.sendPacket(device.dmxData.udpPacket, device.address);
      });
    }

  }

  _handleCommand(String command){

    if(messagePresent){
      this.command.clear();
      this.messagePresent = false;
    }

    this.command.add(command);
    if(command == ""){
      _execute();

      switch(_commandToString()){
        case KeypadSecrets.konami:
          this.messagePresent = true;
          this.command.clear();
          this.command.add(String.fromCharCodes([
            0x2b, 0x20, 0x33, 0x30, 0x20, 0x4c, 0x69, 0x76, 0x65, 0x73
          ]));
          break;  
        case KeypadSecrets.dreams:
          this.messagePresent = true;
          this.command.clear();
          this.command.add(String.fromCharCodes([
            0x54, 0x68, 0x61, 0x6e, 0x6b, 0x20, 0x79, 0x6f, 0x75, 0x20,
            0x66, 0x6f, 0x72, 0x20, 0x74, 0x68, 0x65, 0x20, 0x69, 0x6e,
            0x73, 0x70, 0x69, 0x72, 0x61, 0x74, 0x69, 0x6f, 0x6e
          ]));
          break;  
        case KeypadSecrets.escape:
          this.messagePresent = true;
          this.command.clear();
          this.command.add(String.fromCharCodes([
            0x48, 0x65, 0x6c, 0x70, 0x20, 0x69, 0x73, 0x20, 0x6f, 0x6e,
            0x20, 0x69, 0x74, 0x73, 0x20, 0x77, 0x61, 0x79, 0x21,
          ]));
        break;  
        case KeypadSecrets.don:
          this.messagePresent = true;
          this.command.clear();
          this.command.add(String.fromCharCodes([
            0x54, 0x68, 0x65, 0x20, 0x44, 0x6f, 0x6e, 0x20, 0x69, 0x73, 
            0x20, 0x70, 0x6c, 0x65, 0x61, 0x73, 0x65, 0x64, 0x21,
          ]));
        break;
        case KeypadSecrets.homage:
          this.messagePresent = true;
          this.command.clear();
          this.command.add(String.fromCharCodes([
            0x43, 0x72, 0x65, 0x61, 0x74, 0x65, 0x64, 0x20, 0x62, 0x79,
            0x20, 0x43, 0x68, 0x72, 0x69, 0x73, 0x74, 0x69, 0x61, 0x6e,
            0x20, 0x27, 0x53, 0x4f, 0x43, 0x27, 0x20, 0x4b, 0x72, 0x75,
            0x65, 0x67, 0x65, 0x72,
          ]));
        break;
        default:
          this.messagePresent = false;
          this.command.clear();
      }
    } else if(this.command.length > 2 && command == "Full"){
      print(this.command[this.command.length - 2]);
      if(this.command[this.command.length - 2] == "@"){
        _execute();
        this.messagePresent = false;
        this.command.clear();
      }
    }

    setState(() {});
  }

  String _commandToString(){
    String retVal = "";
    command.forEach((string){
      if(string == "@" || string == "->"){
        retVal += " $string ";
      } else {
        retVal += string; 
      }
    });

    return retVal;
  }

  @override
  initState() {
    super.initState();
    keyColors = KeyColors(KeypadArea.randSeed);
    command = new List<String>();
    messagePresent = false;
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 30.0;
    double littlefontSize = 20.0;
    String fontFamily = "Roboto";

    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              _commandToString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: littlefontSize,
                fontFamily: fontFamily,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "1",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("1");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "2",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("2");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "3",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("3");
                    },
                  )
                ),
              ],
            )
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                 Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "4",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("4");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "5",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("5");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "6",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("6");
                    },
                  )
                ),
              ],
            )
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "7",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("7");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "8",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("8");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "9",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("9");
                    },
                  )
                ),
              ],
            )
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "@",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("@");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("0");
                    },
                  )
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "Full",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("Full");
                    },
                  )
                ),
              ],
            )
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    color: Colors.white,
                    splashColor: keyColors.getRandColor(),
                    child: Text(
                      "->",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("->");
                    },
                  )
                ),
                Expanded(
                  flex: 2,
                  child: RaisedButton(
                    color: Colors.green,
                    splashColor: Colors.greenAccent,
                    child: Text(
                      "Enter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                      ),
                    ),
                    onPressed: (){
                      _handleCommand("");
                    },
                  )
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}


