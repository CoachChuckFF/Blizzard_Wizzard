import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/scene.dart';

class FaderButton extends StatelessWidget {
  final Function onTap;
  final Function onDoubleTap; 
  final Function onLongPress;
  final Color primaryColor;
  final Color accentColor;
  final Widget child;

  FaderButton({
    Key key, 
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.primaryColor,
    this.accentColor,
    this.child,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      color: (primaryColor == null) ? Theme.of(context).primaryColor : primaryColor,
      child: InkWell(
        child: Center(
          child: child,
        ),
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
      )
    );
  }
}