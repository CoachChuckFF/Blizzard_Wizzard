import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';

abstract class SettingsCard extends StatelessWidget{
  final Device device;
  final Function(String) onSubmit;
  final Function(List<int>, String) onReturn;

  SettingsCard([this.device, this.onSubmit, this.onReturn]);
}