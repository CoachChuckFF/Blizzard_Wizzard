import 'dart:math';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/blizzard_devices.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/views/device_settings_screen_assets/setting_cards/settings_card.dart';


class InfoCard extends StatefulWidget {
  static const List<String> interests = [
    "Lady Lights",
    "Long Walks",
    "Suitee",
    "Bear Wrestling",
    "Nickleback",
  ];
  final Device device;

  InfoCard(this.device);

  @override
  State<StatefulWidget> createState() => InfoCardState();
}

class InfoCardState extends State<InfoCard> {  

  bool _egg;
  int _state;

  @override
  initState() {
    super.initState();
    _egg = false;
    _state = 0;
  }

  @override
  Widget build(BuildContext context) {
    Random rng = Random(widget.device.mac.hashCode);

    return Card(
      child: Column(
        children: <Widget>[
          Container(height: 3.0),
          Text(
            widget.device.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 25.0,
              color: Theme.of(context).accentColor
            ),
          ),
          Container(height: 21.0),
          Row(
            children: <Widget>[
              Container(width: 21.0),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onDoubleTap: (){
                    if(_state == 0){
                      _state = 1;
                    } else {
                      _state = 0;
                    }
                  },
                  onTap: () => _state = 0,
                  child: Text(
                    "Fixture",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 21.0,
                      color: Theme.of(context).accentColor
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  BlizzardDevices.getDevice(widget.device.typeId),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 21.0,
                  ),
                ),
              )
            ],
          ),
          Container(height: 13.0),
          Row(
            children: <Widget>[
              Container(width: 21.0),
              Expanded(
                flex: 2,
                child: Text(
                  "Mac",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 21.0,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onLongPress: (){
                    if(_state == 2){
                      setState(() {
                        _egg = true;                        
                      });
                    } else {
                      _state = 0;
                    }
                  },
                  onTap: () => _state = 0,
                  child: Text(
                    widget.device.mac.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 21.0,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(height: 13.0),
          Row(
            children: <Widget>[
              Container(width: 21.0),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: (){
                    if(_state == 1){
                      _state = 2;
                    } else {
                      _state = 0;
                    }
                  },
                  child: Text(
                    "IP",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 21.0,
                      color: Theme.of(context).accentColor
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  widget.device.address.address,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 21.0,
                  ),
                ),
              ),
            ],
          ),
          Container(height: 13.0),
          (widget.device.isBlizzard && _egg) ? 
          Row(
            children: <Widget>[
              Container(width: 21.0),
              Expanded(
                flex: 2,
                child: Text(
                  "Interests",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 21.0,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  InfoCard.interests[rng.nextInt(InfoCard.interests.length)],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 21.0,
                  ),
                ),
              ),
            ],
          ) : 
          Container(height: 0.0),
          Container(height: 13.0),
        ],
      ),
    );
  }
}
