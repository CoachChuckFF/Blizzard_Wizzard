import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:d_artnet/d_artnet.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'dart:async';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';

class PatchesCard extends StatefulWidget {
  final int cols;

  PatchesCard(this.cols);

  @override
  createState() => PatchesCardState(cols);
}

class PatchesCardState extends State<PatchesCard> {

  final int cols;

  PatchesCardState(this.cols);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
        itemCount: BlizzardWizzardConfigs.artnetMaxUniverses,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 33.0,
            child: new Center(
              child: new Text(
                '${index + 1}'
              ),
            ),
          );
        },
      ) 
    );
  }
}
