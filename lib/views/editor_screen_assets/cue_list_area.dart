import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_edit_dialog.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_item.dart';

class CueListArea extends StatefulWidget {

  CueListArea({Key key}) : super(key: key);

  @override
  createState() => CueListAreaState();
}

class CueListAreaState extends State<CueListArea> {
  List<Cue> cues;
  int selected;

  void _handleEdit(Cue cue, int index){

    if(cue == null){
      print("delete ${cues[index].name}");
    } else {
      cues[index] = cues[index].copyWith(name: cue.name);
    }
  }

  @override
  initState() {
    super.initState();
    cues = List<Cue>();
    selected = 0;
    for(int i = 0; i < 50; i++){
      cues.add(Cue());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        controller: ScrollController(),
        children: _buildListView(),
      ),
    );
  }

  List<Widget> _buildListView() {
    List<Widget> list = List<Widget>();
    int i = 0;

    list.add(
      Text(
        "Cues",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0
        ),
      ),
    );

    cues.forEach((cue){
      list.add(
        CueItem(
          key: Key("CUE_${cue.id}"),
          cue: cue,
          selected: (i == selected),
          index: i++,
          onTap: (index){
            if(index != selected){
              setState(() {
                selected = index;                
              });
            }
          },
          onDoubleTap: (index){
            showDialog(
              context: context,
              child: CueEditDialog(
                cue: cues[index],
                callback: (cue){
                  setState(() {
                    _handleEdit(cue, index);                                 
                  });
                },
              )
            );
          },
        )
      );
    });

    return list;
  }
}
