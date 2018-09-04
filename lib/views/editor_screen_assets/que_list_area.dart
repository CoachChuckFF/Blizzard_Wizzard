import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/editior_title_bar.dart';

class QueListArea extends StatefulWidget {

  @override
  createState() => QueListAreaState();
}



class QueListAreaState extends State<QueListArea> {
  List<String> ques = List<String>();

  @override
  initState() {
    super.initState();
    for(int i = 0; i < 50; i++){
      ques.add("Que ${i + 1}");
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
              title: "Ques",
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
    return new ListView.builder(
      itemCount: ques.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if(index == 0){
          return Text("Add New +");
        } else {
          return Text(ques[index-1]);
        }
      },
    );
  }
}