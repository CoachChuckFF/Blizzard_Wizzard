import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/models/que.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/editior_title_bar.dart';

class SceneListArea extends StatefulWidget {

  @override
  createState() => SceneListAreaState();
}



class SceneListAreaState extends State<SceneListArea> {
  List<Scene> scenes = List<Scene>();

  @override
  initState() {
    super.initState();
    for(int i = 0; i < 100; i++){
      scenes.add(Scene());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: EditorTitleBar(
              title: "Scenes",
              callback: () => print("click")
            ),
          ),
          Expanded(
            flex: 13,
            child: _buildListView(),
          ),
        ]
      )
    );
  }

  ListView _buildListView() {
    bool isEmpty = (scenes.length == 0);

    return new ListView.builder(
      itemCount: (isEmpty) ? 1 : scenes.length,
      itemBuilder: (BuildContext context, int index) {
        if(isEmpty){
          return Center(child: Text("No Scenes Present"));
        }

        return SceneListItem(
          item: scenes[index],
          mode: (index % 2 == 0) ? QueMode.chase : QueMode.step
        );
      },
    );
  }
}

class SceneListItem extends StatelessWidget{
final Scene item;
final int mode;

SceneListItem({
  @required this.item,
  @required this.mode,
});

@override
Widget build(BuildContext context) {
    List<Widget> builder = <Widget>[
      Expanded(
            flex: 1,
            child: Center(child: Text(item.name))
          ), 
      Expanded(
        flex: 1,
        child:Text("Hold\n${item.hold}")
      ),
    ];

    if(mode == QueMode.chase){
      builder.add(
        Expanded(
          flex: 1,
          child:
            Center(child:Text("xFade\n${item.xFade}"))
        )
      );
    } else {
      builder.add(
        Expanded(
          flex: 1,
          child:
            Center(child:Text("Fade In\n${item.fadeIn}"))
        )
      );
      builder.add(
        Expanded(
          flex: 1,
          child:
            Center(child:Text("Fade Out\n${item.fadeOut}"))
        )
      );
    }

    return Card(

      child: SizedBox(
        height: 66.0,
        child: Row(
          children: builder
        ),
      )
    );
  }
}