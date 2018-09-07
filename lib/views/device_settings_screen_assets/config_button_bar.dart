import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class ConfigButtonBar extends StatelessWidget {
  final int state;
  final Function(int) callback;

  ConfigButtonBar({
    this.state = DeviceConfigureCategoryState.device,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.category),
              tooltip: 'Device Settings',
              onPressed: () => callback(DeviceConfigureCategoryState.device),
              splashColor: Colors.deepOrangeAccent,
              highlightColor: Colors.deepOrangeAccent,
              color: (state == DeviceConfigureCategoryState.device) ? Colors.deepOrange : Theme.of(context).disabledColor,
            ),
          ),
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.color_lens),
              tooltip: 'Protocol Settings',
              onPressed: () => callback(DeviceConfigureCategoryState.protocol),
              splashColor: Colors.deepPurpleAccent,
              highlightColor: Colors.deepPurpleAccent,
              color: (state == DeviceConfigureCategoryState.protocol) ? Colors.deepPurple : Theme.of(context).disabledColor,
            ),
          ),
          Expanded(
            child: new IconButton(
              icon: new Icon(Icons.network_check),
              tooltip: 'Network Settings',
              onPressed: () => callback(DeviceConfigureCategoryState.network),
              splashColor: Colors.greenAccent,
              highlightColor: Colors.greenAccent,
              color: (state == DeviceConfigureCategoryState.network) ? Colors.green : Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}