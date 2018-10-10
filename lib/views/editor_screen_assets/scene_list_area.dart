import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_edit_dialog.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/scene_item.dart';

class SceneListArea extends StatefulWidget {
  final List<Scene>scenes;
  final int cueIndex;

  SceneListArea({Key key, this.scenes, this.cueIndex}) : super(key: key);

  @override
  createState() => SceneListAreaState();
}


class SceneListAreaState extends State<SceneListArea> {
  List<bool> _selected;
  List<Scene> _scenes;

  void _handleEdit(Scene scene, int index){
    int count = 0;

    if(_selected.contains(true)){
      if(scene == null){
        _scenes.removeWhere((test){
          return _selected[count++];
        });
      } else {
        count = 1;
        for(int i = 0; i < _selected.length; i++){
          if(_selected[i]){
            _scenes[i] = _scenes[i].copyWith(
              name: (_scenes[index].name == scene.name) ?
              null : "${scene.name} ${count++}",
              hold: scene.hold,
              xFade: scene.xFade,
              fadeIn: scene.fadeIn,
              fadeOut: scene.fadeOut,
            );
          }
        }
      }
    } else {
      if(scene == null){
        _scenes.removeAt(index);
      } else {
        _scenes[index] = _scenes[index].copyWith(
          name: scene.name,
          hold: scene.hold,
          xFade: scene.xFade,
          fadeIn: scene.fadeIn,
          fadeOut: scene.fadeOut,
        );
      }
    }

    StoreProvider.of<AppState>(context).dispatch(UpdateSceneList(
      cueIndex: widget.cueIndex,
      scenes: _scenes
    ));
  }


  @override
  initState() {
    super.initState();
    if(widget.scenes != null){
      _scenes = List.from(widget.scenes);
      _selected = List<bool>(widget.scenes.length)..fillRange(0, widget.scenes.length, false);
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
        onReorder: (_scenes == null) ? 
        (pre, post){
          print("Nope");
        } :
        (pre, post){
          if(post == _scenes.length){
            post = _scenes.length - 1;
          }
          print("$pre, $post");
          _scenes.insert(post, _scenes.removeAt(pre));
          StoreProvider.of<AppState>(context).dispatch(UpdateSceneList(
            cueIndex: widget.cueIndex,
            scenes: _scenes
          ));
        },
      ),
    );
  }

  List<Widget> _buildListView() {
    List<Widget> list = List<Widget>();
    int i = 0;

    if(_scenes == null){
      return list..add(
        Text(
          "No Scenes Created",
          key: Key("NADA_SCENES")
        )
      );
    }

    _scenes.forEach((scene){
      list.add(
        SceneItem(
          key: Key("SCENE_${scene.id}"),
          scene: scene,
          selected: _selected[i],
          index: i,
          onTap: (index){
            showDialog(
              context: context,
              child: SceneEditDialog(
                scene: _scenes[index],
                callback: (scene){
                  _handleEdit(scene, index);                                 
                },
              )
            );
          },
          onDoubleTap: (index){
            setState(() {
              if(_selected[index]){
                if(_selected.contains(false)){
                  _selected.fillRange(0, _selected.length, true);
                } else {
                  _selected.fillRange(0, _selected.length, false);
                }
              } else {
                _selected[index] = true;
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


