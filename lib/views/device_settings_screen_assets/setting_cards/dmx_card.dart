
import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';


class DMXCard extends StatefulWidget{
  final Device device;

  DMXCard(this.device);

  @override
  createState() => DMXCardState();
}

class DMXCardState extends State<DMXCard> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(height: 13.0,),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container()
              ),
              Expanded(
                flex:3,
                child: Text(
                  "DMX",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Theme.of(context).hintColor
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container()
              ),
            ],
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('BLACKOUT'),
                  onPressed: () { _blackout(); },
                ),
              ],
            ),
          ),
          GridView.count(
            scrollDirection: Axis.vertical,
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this would produce 2 rows.
            crossAxisCount: 8,
            shrinkWrap: true,
            primary: false,
            // Generate 100 Widgets that display their index in the List
            children: List.generate(512, (index) {
              return InkWell(
                onLongPress: () {
                  _zeroChannel(index + 1);
                },
                onDoubleTap: () {
                    _maxChannel(index + 1);
                },
                onTap: () {
                  showDialog(
                    context: context,
                    child: DMXDialog(
                      startValue: widget.device.dmxData.dmx[index],
                      index: index,
                      callback: (value) => _setChannel(index + 1, value),
                    )
                  );
                },
                child: SizedBox(
                  height: 33.0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${widget.device.dmxData.dmx[index]}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              );
            }),
          ), 
        ],
      )
    );
  }

  void _blackout(){
    widget.device.dmxData.blackout();
    _updateDMX();
  }

  void _maxChannel(int index){
    widget.device.dmxData.setDmxValue(index, 0xFF);
    _updateDMX();
  }

  void _zeroChannel(int index){
    widget.device.dmxData.setDmxValue(index, 0x00);
    _updateDMX();
  }

  void _setChannel(int index, int value){
    widget.device.dmxData.setDmxValue(index, value);
    _updateDMX();
  }

  void _updateDMX(){

    tron.server.sendPacket(widget.device.dmxData.udpPacket, widget.device.address);
    setState(() {});
  }

}

class DMXDialog extends StatefulWidget {
  const DMXDialog({this.startValue, this.index, this.callback});

  final ValueChanged<int> callback;
  final int startValue;
  final int index;

  @override
  State createState() => DMXDialogState();
}

class DMXDialogState extends State<DMXDialog> {
  int _value;


  @override
  void initState() {
    super.initState();
    _value = widget.startValue;
  }

  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Set Channel: ${widget.index} : $_value"),
      actions: [
        Slider(
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
        FlatButton(
          child: const Text("Ok"),
          onPressed: ()=> Navigator.pop(context),
        ),
      ],
    );
  }
}