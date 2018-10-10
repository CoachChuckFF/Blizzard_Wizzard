import 'package:flutter/material.dart';

class ShowItem extends StatelessWidget {
  final String show;
  final bool selected;
  final Function onTap;
  final Function onLongPress;
  final Function onDoubleTap;

  ShowItem({Key key, @required this.show, this.selected, this.onTap, this.onLongPress, this.onDoubleTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color fontColor = (selected) ? Colors.white : Theme.of(context).primaryColor;
    Color bgColor = (!selected) ? Colors.white : Theme.of(context).primaryColor;

    return Card(
      color: bgColor,
      child: InkWell(
        child: ListTile(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(height: 3.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      show,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: fontColor
                      ),
                    ),
                  ),
                ]
              ),
              Container(height: 3.0),
            ],
          ),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
      )
    );
  }
}