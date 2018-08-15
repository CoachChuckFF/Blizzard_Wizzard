import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/views/items/available_device_items/available_device_list.dart';
import 'package:blizzard_wizzard/views/screens/config_wizzard_screen.dart';
import 'package:blizzard_wizzard/views/items/controller_items/fixture_grid.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:d_artnet/d_artnet.dart';

class ControllerScreen extends StatefulWidget {
  @override
  createState() => ControllerScreenState();
}

class ControllerScreenState extends State<ControllerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool wide = (orientation == Orientation.landscape);

            if(wide){
              return Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: PatchesCard(3),
                  ),
                  Expanded(
                    flex: 3,
                    child: PatchesCard(6),
                  )
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: PatchesCard(3),
                  ),
                  Expanded(
                    flex: 3,
                    child: PatchesCard(6),
                  )
                ],
              );
            }
          },
        ), 
      ),
    );
  }

}
