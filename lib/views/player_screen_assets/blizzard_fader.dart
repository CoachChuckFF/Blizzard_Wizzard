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

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: BlizzardSizes.vertSliderPadding,
        horizontal: BlizzardSizes.vertSliderPadding,
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbShape: _CustomThumbShape(
            valueSlider: value,
            max: max,
            activeColor: activeColor,
            inactiveColor: inactiveColor
          ),
          thumbColor: Colors.blue,
          //thumbShape: _ThumbShape(),
          activeTrackColor: activeColor,
          inactiveTrackColor: inactiveColor,
          overlayColor: (value/max <= 0.5) ? 
            inactiveColor.withOpacity(1 - (value/max*2)) 
            : activeColor.withOpacity(((value/max)-0.5)*2)
        ),
        child: VerticalSlider(
          value: value,
          onChanged: callback,
          min: 0.0,
          max: max,
          divisions: max.truncate(),
        )
      )
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = BlizzardSizes.vertSliderPadding;
  static const double _disabledThumbSize = 1.0;

  final double valueSlider;
  final double max;

  final Color activeColor;
  final Color inactiveColor;

  _CustomThumbShape({this.valueSlider = 0, this.max = 255, this.activeColor = Colors.red, this.inactiveColor = Colors.grey});

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

    Paint notValid = Paint()
    ..strokeWidth = 10.0
    ..color = inactiveColor
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

    canvas.drawCircle(thumbCenter, _thumbSize, notValid);    

    Paint valid = Paint()
    ..strokeWidth = 10.0
    ..color = activeColor
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(
        center: thumbCenter,
        radius: _thumbSize,
      ), 
      (math.pi),
      ((math.pi)) * (this.valueSlider/this.max), 
      false, 
      valid
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: thumbCenter,
        radius: _thumbSize,
      ), 
      (math.pi),
      ((math.pi)) * (this.valueSlider/this.max) * -1, 
      false, 
      valid
    );
  }
}

