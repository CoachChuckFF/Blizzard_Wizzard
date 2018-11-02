import 'package:flutter/material.dart';


class RSHealthBar extends StatelessWidget {
  final int maxStrength;
  final int strength;
  final double size;

  RSHealthBar({
    this.maxStrength,
    this.strength,
    this.size = 21.0,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: size,
      height: size * 0.1545,
      alignment: AlignmentDirectional.centerStart,
      color: Color.fromARGB(0xFF, 251, 0x00, 0x00),
      child: Container(
        constraints: BoxConstraints(
          minHeight: size * 0.1545,
          maxWidth: size * (strength / maxStrength),
        ),
        alignment: AlignmentDirectional.centerStart,
        color: Color.fromARGB(0xFF, 46, 255, 58),
      )
    );
  }
}
