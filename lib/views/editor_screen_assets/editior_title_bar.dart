import 'package:flutter/material.dart';

class EditorTitleBar extends StatelessWidget{
  final Function callback;
  final String title;
  final TextStyle style;

  EditorTitleBar({@required this.callback, @required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Center(
            child:Text(
              title,
              style: style,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: IconButton(
              onPressed: callback,
              padding: const EdgeInsets.all(0.0),
              icon: Icon(
                Icons.add,
              )
            )
          ),
        ),
      ]
    );
  }
}