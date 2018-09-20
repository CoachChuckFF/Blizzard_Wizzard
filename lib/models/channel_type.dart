import 'package:flutter/material.dart';

class ChannelTypes{
  static const List<ChannelType> types = [
    ChannelType("Generic", "The generic dimmer", "G", Colors.blue, true, true),
    ChannelType("Dimmer", "The master dimmer", "D", Colors.black, false, false),
    ChannelType("Red", "The red ranger dimmer", "R", Colors.red, false, false),
    ChannelType("Green", "The green ranger dimmer", "G", Colors.green, false, false),
    ChannelType("Blue", "The blue ranger dimmer", "B", Colors.blue, false, false),
    ChannelType("Amber", "The maple flavored dimmer", "A", Colors.amber, false, false),
    ChannelType("White", "The light-colored ranger dimmer", "W", Colors.grey, false, false),
    ChannelType("UV", "The 'Don't look at my bed!' dimmer", "UV", Colors.deepPurple, false, false),
    ChannelType("Lime", "The chaser dimmer", "L", Colors.lime, false, false),
    ChannelType("Strobe", "The flash flash dimmer", "*", Colors.black, false, true),
    ChannelType("Pan", "The X-rated dimmer", "X", Colors.blue, false, false),
    ChannelType("Pan Fine", "The X-rated dimmer with a little more finesse", "X+", Colors.blueAccent, false, false),
    ChannelType("Tilt", "The 'Y are you still here?' dimmer", "Y", Colors.red, false, false),
    ChannelType("Tilt Fine", "The 'Y are you still here?' dimmer in a softer voice", "Y+", Colors.redAccent, false, false),
    ChannelType("Macro", "The 'let the fixture do all the work' dimmer", "M", Colors.deepOrange, false, true),
  ];

  static int getIndexFromName(String name){
    int index = types.indexWhere((channel){
      return channel.name == name;
    });
    return (index == -1) ? 0 : index;
  }
}

class ChannelType{
  final String name;
  final String message;
  final String abv;
  final Color color;
  final bool needsName;
  final bool canHaveSegments;

  const ChannelType(
    this.name,
    this.message,
    this.abv,
    this.color,
    this.needsName,
    this.canHaveSegments,
  );
}

class ChannelTypeReturnValue{
  final String name;
  final bool needsName;
  final bool canHaveSegments;
  final int index;

  ChannelTypeReturnValue(
    this.name,
    this.needsName,
    this.canHaveSegments,
    this.index,
  );

  static ChannelTypeReturnValue copyFromType(ChannelType type, int index){
    return ChannelTypeReturnValue(
      type.name,
      type.needsName,
      type.canHaveSegments,
      index,
    );
  }
}