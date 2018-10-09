import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_edit_dialog.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_item.dart';

class SceneListArea extends StatefulWidget {

  SceneListArea({Key key}) : super(key: key);

  @override
  createState() => SceneListAreaState();
}



class SceneListAreaState extends State<SceneListArea> {
  List<Scene> scenes;
  List<bool> selected;

  @override
  initState() {
    super.initState();
    scenes = List<Scene>();
    selected = List<bool>();
    for(int i = 0; i < 30; i++){
      scenes.add(Scene());
      selected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ReorderableListView(
        header: Text(
          "Scenes",
          style: TextStyle(
            fontSize: 20.0
          ),
        ),
        children: _buildListView(),
        onReorder: (pre, post){
          setState(() {
            scenes.insert(post, scenes.removeAt(pre));
          });
        },
      ),
    );
  }

  List<Widget> _buildListView() {
    List<Widget> list = List<Widget>();
    int i = 0;

    scenes.forEach((scene){
      list.add(
        SceneItem(
          key: Key("SCENE_${scene.id}"),
          scene: scene,
          selected: selected[i],
          index: i,
          onTap: (index){
            showDialog(
              context: context,
              child: SceneEditDialog(
                scene: scenes[index],
              )
            );
          },
          onDoubleTap: (index){
            setState(() {
              if(selected[index]){
                if(selected.contains(false)){
                  selected.fillRange(0, selected.length, true);
                } else {
                  selected.fillRange(0, selected.length, false);
                }
              } else {
                selected[index] = true;
              }    
            });
          },
        )
      );
      i++;
    });

    return list;
  }
}


