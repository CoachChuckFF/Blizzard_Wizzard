import 'dart:math';
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
  final double fontSize = 20.0;
  final String fontFamily = "Roboto";
  int state;

  List<int> selectedDevices;
  List<int> selectedFixtures;

  FixtureGridState(this.cols);

  @override
  void initState() {
    super.initState();
    state = DeviceFixtureGridState.device;
    selectedDevices = List<int>();
    selectedFixtures = List<int>();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Tooltip(
                    message: "Devices",
                    child: FlatButton(
                      color: (state == DeviceFixtureGridState.device) ? Colors.black : Colors.white,
                      child: Icon(
                        Icons.ac_unit,
                        color: (state == DeviceFixtureGridState.device) ? Colors.white : Colors.black,
                      ), 
                      onPressed: (){
                        if(state != DeviceFixtureGridState.device){
                          setState(() {
                            state = DeviceFixtureGridState.device;
                          });
                        }
                      },
                    )
                  )
                ),
                Expanded(
                  child: Tooltip(
                  message: "Fixtures",
                    child: FlatButton(
                      color: (state == DeviceFixtureGridState.fixture) ? Colors.black : Colors.white,
                      child: Icon(
                        Icons.adjust,
                        color: (state == DeviceFixtureGridState.fixture) ? Colors.white : Colors.black,
                      ), 
                      onPressed: (){
                        if(state != DeviceFixtureGridState.fixture){
                          setState(() {
                            state = DeviceFixtureGridState.fixture;
                          });
                        }
                      },
                    )
                  )
                ),
              ]
            )
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    (state == DeviceFixtureGridState.device) ? "Devices" : "Fixtures",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: fontFamily
                    )
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
                    itemCount: BlizzardWizzardConfigs.artnetMaxUniverses,
                    itemBuilder: (BuildContext context, int index) {
                      Color textColor = Colors.black;
                      Color boxColor = Colors.white;

                      switch(state){
                        case DeviceFixtureGridState.device:
                          if(selectedDevices.contains(index)){
                            boxColor = Colors.lightBlue;
                            textColor = Colors.white;
                          }
                          break;
                        case DeviceFixtureGridState.fixture:
                          if(selectedFixtures.contains(index)){
                            boxColor = Colors.purple;
                            textColor = Colors.white;
                          }
                          break;
                      }

                      return GestureDetector(
                        child: SizedBox(
                          height: 33.0,
                          child: Container(
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: fontFamily,
                                  color: textColor,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: boxColor
                            ),
                          ),
                        ),
                        onTap: (){
                          if(state == DeviceFixtureGridState.device){
                            selectedDevices.clear();
                            selectedDevices.add(index);
                          } else {
                            selectedFixtures.clear();
                            selectedFixtures.add(index);
                          }
                          setState(() {});
                        },
                        onDoubleTap: (){
                          if(state == DeviceFixtureGridState.device){
                            if(selectedDevices.contains(index)){
                              selectedDevices.remove(index);
                            } else {
                              selectedDevices.add(index);
                            }
                          } else {
                            if(selectedFixtures.contains(index)){
                              selectedFixtures.remove(index);
                            } else {
                              selectedFixtures.add(index);
                            }
                          }
                          setState(() {});
                        },
                        onLongPress: (){
                          if(state == DeviceFixtureGridState.device){
                            selectedDevices.clear();
                          } else {
                            selectedFixtures.clear();
                          }
                          setState(() {});
                        },
                      );
                    },
                  ) 
                )
              ],
            )
          ),
        ]
      )
    );
  }
}
