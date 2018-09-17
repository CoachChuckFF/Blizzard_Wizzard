
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';


class DMXControlArea extends StatefulWidget{
  final List<Device> devices;

  DMXControlArea({@required this.devices});

  @override
  createState() => DMXControlAreaState();
}

class DMXControlAreaState extends State<DMXControlArea> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelected = false;
    Device firstDev;

    if(widget.devices.length != 0){
      hasSelected = true;
      firstDev = widget.devices.first;
    }

    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new ButtonTheme.bar( // make buttons use the appropriate styles for cards
          child: new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: const Text('BLACKOUT'),
                onPressed: () { if(hasSelected){_blackout();} },
              ),
            ],
          ),
        ),
        new Expanded(
          child: GridView.count(
            scrollDirection: Axis.vertical,
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this would produce 2 rows.
            crossAxisCount: 8,
            shrinkWrap: true,
            primary: false,
            // Generate 100 Widgets that display their index in the List
            children: List.generate(512, (index) {
              return new InkWell(
                onLongPress: () {
                  if(hasSelected){
                    _zeroChannel(index + 1);
                  }
                },
                onDoubleTap: () {
                  if(hasSelected){
                    _maxChannel(index + 1);
                  }
                },
                onTap: () {
                  if(hasSelected){
                    showDialog(
                      context: context,
                      child: DMXDialog(
                        startValue: firstDev.dmxData.dmx[index],
                        index: index,
                        callback: (value) => _setChannel(index + 1, value),
                      )
                    );
                  }
                },
                child: new SizedBox(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          (hasSelected) ? 
                          '${firstDev.dmxData.dmx[index]}' : 'N/A',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                )
              );
            }),
          ), 
        ),
      ],
    );
  }

  

  void _blackout(){
    widget.devices.forEach((device){
      device.dmxData.blackout();
    });
    _updateDMX();
  }

  void _maxChannel(int index){
    widget.devices.forEach((device){
      device.dmxData.setDmxValue(index, 0xFF);
    });
    _updateDMX();
  }

  void _zeroChannel(int index){
    widget.devices.forEach((device){
      device.dmxData.setDmxValue(index, 0x00);
    });
    _updateDMX();
  }

  void _setChannel(int index, int value){
    widget.devices.forEach((device){
      device.dmxData.setDmxValue(index, value);
    });
    _updateDMX();
  }

  void _updateDMX(){
    widget.devices.forEach((device){
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });

    setState(() {});
  }

}

class DMXDialog extends StatefulWidget {
  const DMXDialog({this.startValue, this.index, this.callback});

  final ValueChanged<int> callback;
  final int startValue;
  final int index;

  @override
  State createState() => new DMXDialogState();
}

class DMXDialogState extends State<DMXDialog> {
  int _value;


  @override
  void initState() {
    super.initState();
    _value = widget.startValue;
  }

  Widget build(BuildContext context) {

    return new AlertDialog(
      title: new Text("Set Channel: ${widget.index} : $_value"),
      actions: [
        new Slider(
          value: _value.toDouble(),
          min: 0.0,
          max:255.0,
          divisions: 256,
          onChanged: (double value) {
            setState(() {
              _value = value.toInt();
              widget.callback(_value);
            });
          },
          //onChangeEnd: (double value) => print("end: ${value.toString()}"),
        ),
        new FlatButton(
          child: const Text("Ok"),
          onPressed: ()=> Navigator.pop(context),
        ),
      ],
    );
  }
}