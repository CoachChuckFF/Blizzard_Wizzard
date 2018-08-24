import 'package:flutter/material.dart';

class ColorProfile{
  final Color color;
  final Color splash;
  final String name;

  const ColorProfile(this.color, this.splash, this.name);
}

class ColorPresets{
  static const List<ColorProfile> presets = [
    const ColorProfile(Colors.red, Colors.redAccent, "Firetruck Red"),
    const ColorProfile(Colors.orange, Colors.orangeAccent, "Orange Orange"),
    const ColorProfile(Colors.yellow, Colors.yellowAccent, "Empire Yellow"),
    const ColorProfile(Colors.green, Colors.greenAccent, "Money Green"),
    const ColorProfile(Colors.cyan, Colors.cyanAccent, "Joel Blue"),
    const ColorProfile(Colors.blue, Colors.blueAccent, "Blizzard Blue"),
    const ColorProfile(Colors.indigo, Colors.indigoAccent, "Indi Gogo"),
    const ColorProfile(Colors.purple, Colors.purpleAccent,"Pretty Purple"),
    const ColorProfile(Colors.black, Colors.white, "'Like My Soul' Black"),
    const ColorProfile(Colors.white, Colors.black, "Fresh Linen Scent"), 
  ]; 
}

class PresetGrid extends StatefulWidget {

  PresetGrid();

  @override
  createState() => PresetGridState();
}

class PresetGridState extends State<PresetGrid> {

  PresetGridState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          
          Expanded(
            child: GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
              itemCount: ColorPresets.presets.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 33.0,
                  child: Tooltip(
                    message: ColorPresets.presets[index].name,
                    child: RaisedButton(
                      color: ColorPresets.presets[index].color,
                      elevation: 5.0,
                      splashColor: ColorPresets.presets[index].splash,
                      onPressed: () {

                      },
                    ),
                  )
                );
              },
            ) 
          )
        ],
      )
    );
  }
}
