import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class FixtureGrid extends StatefulWidget {
  final int cols;

  FixtureGrid(this.cols);

  @override
  createState() => FixtureGridState(cols);
}

class FixtureGridState extends State<FixtureGrid> {

  final int cols;

  FixtureGridState(this.cols);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(
            "Patches",
          ),
          Expanded(
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
          )
        ],
      )
    );
  }
}
