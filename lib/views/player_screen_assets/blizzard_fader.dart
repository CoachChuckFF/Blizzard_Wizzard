import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/delay_time.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/scene.dart';
import 'package:blizzard_wizzard/views/fixes/vertical_slider.dart';

class BlizzardFader extends StatelessWidget {
  final ValueChanged<double> callback;
  final double max;
  final double value;
  
  final Color activeColor;
  final Color inactiveColor;

  BlizzardFader({this.callback, this.max = 255.0, this.value, this.activeColor = Colors.red, this.inactiveColor = Colors.grey});

  Widget build(BuildContext context) {

    print("$max, ${(max+1).truncate().toString()}");

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbShape: _CustomThumbShape(
            value: value,
            max: max,
            activeColor: activeColor,
            inactiveColor: inactiveColor
          ),
          activeTrackColor: activeColor,
          inactiveTrackColor: inactiveColor,
          overlayColor: (value/max <= 0.5) ? 
            inactiveColor.withOpacity(1 - (value/max*2)) 
            : activeColor.withOpacity(((value/max)-0.5)*2)
        ),
        child: VerticalSlider(
          value: value,
          onChanged: callback,
          min: 0,
          max: max,
          divisions: (max + 1).truncate(),
        )
      )
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 25.0;
  static const double _disabledThumbSize = 1.0;

  final double value;
  final double max;

  final Color activeColor;
  final Color inactiveColor;

  _CustomThumbShape({this.value = 0, this.max = 255, this.activeColor = Colors.red, this.inactiveColor = Colors.grey});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled ? const Size.fromRadius(_thumbSize) : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;
    final double size = _thumbSize * sizeTween.evaluate(enableAnimation);
    //canvas.drawPath(thumbPath, Paint()..color = colorTween.evaluate(enableAnimation));
    Paint notValid = Paint()
    ..strokeWidth = 10.0
    ..color = inactiveColor
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

    /*canvas.drawArc(
      Rect.fromCircle(
        center: thumbCenter,
        radius: size,
      ), 
      (math.pi+(math.pi/4)),
      ((math.pi*2)-(math.pi/2)), 
      false, 
      notValid
    );*/

    canvas.drawCircle(thumbCenter, size, notValid);    

    Paint valid = Paint()
    ..strokeWidth = 10.0
    ..color = activeColor
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(
        center: thumbCenter,
        radius: size,
      ), 
      (math.pi),
      ((math.pi)) * (this.value/this.max), 
      false, 
      valid
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: thumbCenter,
        radius: size,
      ), 
      (math.pi),
      ((math.pi)) * (this.value/this.max) * -1, 
      false, 
      valid
    );
  }
}

