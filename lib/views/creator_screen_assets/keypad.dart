import 'dart:math';
import 'package:flutter/material.dart';

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
  KeypadArea(){
    randSeed++;
  }

  @override
  createState() => KeypadAreaState();
}

class KeypadAreaState extends State<KeypadArea> {

  KeyColors keyColors;
  List<String> command;

  _handleCommand(String command){
    if(command == ""){
      this.command.clear();
    }

    setState(() {
      this.command.add(command);
    });
  }

  String _commandToString(){
    String retVal = "";
    command.forEach((string){
      retVal += " $string ";
    });

    return retVal;
  }

  @override
  initState() {
    super.initState();
    keyColors = KeyColors(KeypadArea.randSeed);
    command = new List<String>();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
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


