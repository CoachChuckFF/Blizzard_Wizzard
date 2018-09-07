import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  final int maxStrength;
  final int strength;
  final double size;
  final IconData icon;

  HealthBar({
    this.maxStrength,
    this.strength,
    this.icon,
    this.size = 21.0,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Color.fromARGB(
      0xFF,
      ((1 - (strength/maxStrength)) * 0xFF).toInt(),
      ((strength/maxStrength) * 0xFF).toInt(),
      0x00
    );

    return Icon(
      icon,
      color: color,
      size: size
    );
  }
}
