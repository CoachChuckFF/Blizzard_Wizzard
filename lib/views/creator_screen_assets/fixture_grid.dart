import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/globals.dart';

class FixtureGrid extends StatelessWidget {
  final int cols;
  final double fontSize = 20.0;
  final String fontFamily = "Roboto";
  final Map<int, int> patchedFixtures;
  final List<int> selectedFixtures;
  final ValueChanged<List<int>> callback;

  FixtureGrid({
    this.cols = 5,
    this.patchedFixtures,
    this.selectedFixtures,
    this.callback
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
      itemCount: BlizzardWizzardConfigs.artnetMaxUniverses,
      itemBuilder: (BuildContext context, int index) {
        Color textColor = Colors.purple;
        Color boxColor = Colors.white;

        if(selectedFixtures.contains(index)){
          textColor = Colors.white;
          boxColor = Colors.purple;
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
            if(callback != null){
              if(patchedFixtures.containsKey(index)){
                callback(List<int>()..add(index));
              } else {
                //bring up patcher
              }
            }
          },
          onDoubleTap: (){
            if(callback != null){
              if(patchedFixtures.containsKey(index)){
                if(selectedFixtures.contains(index)){
                  callback(List.from(selectedFixtures)..remove(index));
                } else {
                  callback(List.from(selectedFixtures)..add(index));
                }
              } else {
                //nothing?
              }
            }
          },
          onLongPress: (){
            if(callback != null){
              if(patchedFixtures.containsKey(index)){
                if(selectedFixtures.contains(index)){
                  //remove patch?
                } else {
                  //info?
                }
              } else {
                //nothing?
              }
            }
          },
        );
      },
    );
  }
}
