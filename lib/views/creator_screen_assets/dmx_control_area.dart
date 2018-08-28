
import 'package:flutter/material.dart';
import 'package:d_artnet_4/d_artnet_4.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';


class DMXControlArea extends StatefulWidget{

  DMXControlArea();

  @override
  createState() => DMXControlAreaState();
}

class DMXControlAreaState extends State<DMXControlArea> {

  ArtnetDataPacket _packet = ArtnetDataPacket();

  @override
  void initState() {
    super.initState();
    /*if(widget.fixtures.length != 0){
      _packet.copyDmxToPacket(widget.fixtures[0].dmx);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new ButtonTheme.bar( // make buttons use the appropriate styles for cards
          child: new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: const Text('BLACKOUT'),
                onPressed: () { _blackout(); },
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
                  _zeroChannel(index + 1);
                },
                onDoubleTap: () {
                  _maxChannel(index + 1);
                },
                onTap: () {
                  print("short");
                  showDialog(
                    context: context,
                    child: new DMXDialog(
                      packet: _packet,
                      index: index,
                      changedCallback: _updateDMX,
                    )
                  );
                },
                child: new SizedBox(
                  height: 33.0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${_packet.dmx[index]}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              );
            }),
          ), 
        ),
      ],
    );
  }

  

  void _blackout(){
    _packet.blackout();
    _updateDMX();
  }

  void _maxChannel(int index){
    _packet.setDmxValue(index, 0xFF);
    _updateDMX();
  }

  void _zeroChannel(int index){
    _packet.setDmxValue(index, 0x00);
    _updateDMX();
  }

  void _updateDMX(){
    /*for(int i = 0; i < widget.fixtures.length; i++){
      tron.server.sendPacket(_packet.udpPacket, widget.fixtures[i].address);
    }*/
    setState(() {});
  }

}

class DMXDialog extends StatefulWidget {
  const DMXDialog({this.packet, this.index, this.changedCallback});

  final Function changedCallback;
  final ArtnetDataPacket packet;
  final int index;

  @override
  State createState() => new DMXDialogState();
}

class DMXDialogState extends State<DMXDialog> {
  ArtnetDataPacket _packet;
  Function _callback;
  int _index;

  @override
  void initState() {
    super.initState();
    _packet = widget.packet;
    _index = widget.index;
    _callback = widget.changedCallback;
  }

  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text("Set Channel: ${_index+1} : ${_packet.dmx[_index]}"),
      actions: [
        new Slider(
          value: _packet.dmx[_index].toDouble(),
          min: 0.0,
          max:255.0,
          divisions: 256,
          onChanged: (double value) {
            
            _packet.dmx[_index] = value.toInt();
            setState(() {
              _callback();
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