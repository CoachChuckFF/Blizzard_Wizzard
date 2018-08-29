import 'dart:math';
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';

/*
  This file was inspired by fuyumi's flutter color picker @ https://github.com/mchome/flutter_colorpicker
*/

class ColorPickerArea extends StatefulWidget{
  ColorPickerArea({
    @required this.devices,
    this.width: 300.0,
    this.heightToWidthRatio: .69,
    }
  );
  final List<Device> devices;
  final double width;
  final double heightToWidthRatio;


  @override
  State<StatefulWidget> createState() => ColorPickerAreaState();

}

class ColorPickerAreaState extends State<ColorPickerArea> {
  FocusNode _focusR = new FocusNode();
  FocusNode _focusG = new FocusNode();
  FocusNode _focusB = new FocusNode();
  double hue;
  double saturation;
  double value;

  Color getCurrentColor(){
    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }

  void _callback(){
    Color color = getCurrentColor();
    widget.devices.forEach((device){
      device.fixtures.forEach((fixture) {
        if(fixture.profile.redChannel != -1){
          device.dmxData.setDmxValue(fixture.profile.redChannel, color.red);
        }
        if(fixture.profile.greenChannel != -1){
          device.dmxData.setDmxValue(fixture.profile.greenChannel, color.green);
        }
        if(fixture.profile.blueChannel != -1){
          device.dmxData.setDmxValue(fixture.profile.blueChannel, color.blue);
        }
        if(fixture.profile.uvChannel != -1){

        }
      });
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });
  }

  void setCurrentColor(Color color){
    HSVColor next = HSVColor.fromColor(color);
    hue = next.hue;
    saturation = next.saturation;
    value = next.value;
  }

  int _validateColorInput(String input){
    bool stringError = false;

    switch(input.toUpperCase()){
      case "F":
      case "FUL":
        return 255;
      case "Z":
      case "ZRO":
      case "B":
      case "BLK":
      case "OUT":
        return 0;
      case "DON":
        return 69;
      default:
        break;
    }

    int val = int.parse(
      input, 
      onError: (error){
        return 0;
    });
    
    if(stringError){
      return 0;
    }

    if(val > 255){
      val = 255;    
    } else if(val < 0){
      val = 0;
    }

    return val;
  }



  @override
  initState() {
    super.initState();
    HSVColor color = HSVColor.fromColor(Colors.purple);

    hue = color.hue;
    saturation = color.saturation;
    value = 1.0;
  }


  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    double height = width * widget.heightToWidthRatio;
    double heightOffset = 60.0;
    TextEditingController _controllerR = new TextEditingController();
    TextEditingController _controllerG = new TextEditingController();
    TextEditingController _controllerB = new TextEditingController();

    return Column(
      children: <Widget>[
        Container(
          key: Key("RGB"),
          width: width,
          height: heightOffset,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controllerR,
                  focusNode: _focusR,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Red: " + getCurrentColor().red.toString(),
                    labelStyle: TextStyle(
                      color: Colors.red
                    )
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,

                  onChanged: (val){
                    if(val.length >= 3){
                      setState(() {
                        setCurrentColor(getCurrentColor().withRed(_validateColorInput(val)));
                        _callback();
                        _controllerR.clear();                    
                      });
                    }
                  },
                  onSubmitted: (val){
                    setState(() {
                      if(val != ""){
                        setCurrentColor(getCurrentColor().withRed(_validateColorInput(val)));
                        _callback();
                      }
                      _controllerR.clear();                    
                    });
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controllerG,
                  focusNode: _focusG,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Green: " + getCurrentColor().green.toString(),
                    labelStyle: TextStyle(
                      color: Colors.green
                    )
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  
                  onChanged: (val){
                    if(val.length >= 3){
                      setState(() {
                        setCurrentColor(getCurrentColor().withGreen(_validateColorInput(val)));
                        _callback();
                        _controllerG.clear();                    
                      });
                    }
                  },
                  onSubmitted: (val){
                    setState(() {
                    if(val != ""){
                      setCurrentColor(getCurrentColor().withGreen(_validateColorInput(val)));
                      _callback();
                    }
                      _controllerG.clear();                    
                    });
                  },
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controllerB,
                  focusNode: _focusB,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Blue: " + getCurrentColor().blue.toString(),
                    labelStyle: TextStyle(
                      color: Colors.blue
                    )
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (val){
                    if(val.length >= 3){
                      setState(() {
                        setCurrentColor(getCurrentColor().withBlue(_validateColorInput(val)));
                        _callback();
                        _controllerB.clear();                    
                      });
                    }
                  },
                  onSubmitted: (val){
                    setState(() {
                      if(val != ""){
                        setCurrentColor(getCurrentColor().withBlue(_validateColorInput(val)));
                        _callback();
                      }
                      _controllerB.clear();
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          width: width,
          height: height,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details){
              RenderBox box = context.findRenderObject();
              Offset localOffset = box.globalToLocal(details.globalPosition);
              setState(() {
                this.hue = ((localOffset.dx.clamp(0.0, width) / width) * 300.0);
                this.saturation = 1 - (localOffset.dy.clamp(heightOffset, height + heightOffset) - heightOffset) / height;
                _callback();
              });
            },
            child: CustomPaint(
              size: Size(width, height),
              painter: ColorPainter(
                hue: this.hue,
                saturation: this.saturation,
                value: this.value
              ),
            ),
          ),
        ),
        Container(
          width: width,
          child: Slider(
            onChanged: (val){
              setState(() {
                this.value = val;
                _callback();
              });
            },
            value: this.value,
          ),
        ),
      ],
    ); 
  }
}

class ColorPainter extends CustomPainter {
  ColorPainter({
    this.hue: 0.0,
    this.saturation: 1.0,
    this.value: 1.0,
  });

  double hue;
  double saturation;
  double value;

  @override
  paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Gradient gradientBW = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 0, 0, 0),
        HSVColor.fromAHSV(1.0, 0.0, 0.0, value).toColor(),
      ],
    );

    Gradient gradientColor = LinearGradient(
      colors: [
        HSVColor.fromAHSV(1.0, 0.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 45.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 90.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 135.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 180.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 225.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 270.0, 1.0, value).toColor(),
        HSVColor.fromAHSV(1.0, 315.0, 1.0, value).toColor(),
      ],
    );
    
    
    canvas.drawRect(
        rect,
        Paint()
          ..shader = gradientColor.createShader(rect));
    canvas.drawRect(
        rect, 
        Paint()
          ..shader = gradientBW.createShader(rect)
          ..blendMode = BlendMode.lighten);
    canvas.drawCircle(
        Offset(size.width * (hue / 300.0), size.height * (1 - saturation)),
        size.height * 0.04,
        Paint()
          ..color = HSVColor.fromAHSV(1.0, hue, saturation, (1-pow(value, 0.3))).toColor()
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
