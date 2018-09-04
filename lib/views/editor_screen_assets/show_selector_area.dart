import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/editior_title_bar.dart';

class ShowSelectorArea extends StatefulWidget {

  @override
  createState() => ShowSelectorAreaState();
}

class ShowSelectorAreaState extends State<ShowSelectorArea> {
  int value = 0;
  List<String> shows = List<String>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: EditorTitleBar(
              title: "Show",
              callback: () => print("click")
            ),
          ),
          Expanded(
            flex: 1,
            child: DropdownButton(
              onChanged: (value){
                _onShowClick(value);
              },
              isDense: true,
              value: value,
              items: _generateList(),
            ),
          )
        ],
      )
    );
  }

  void _onShowClick(dynamic value){
    dynamic newValue = value;

    if(value == 0){
      shows.add("Show ${shows.length}");
      newValue = this.value;
    }

    setState((){
      this.value = newValue;
    });
  }

  List <DropdownMenuItem<dynamic>> _generateList(){
    List <DropdownMenuItem<dynamic>> list = List <DropdownMenuItem<dynamic>>();

    list.add(
      DropdownMenuItem(
        value: 0,
        child: Text(
          "New Show +",
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    int i = 1;
    this.shows.forEach((show){
      list.add(
        DropdownMenuItem(
          value: i,
          child: Text(
            show,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      i++;
    });
    return list;
  }
}
