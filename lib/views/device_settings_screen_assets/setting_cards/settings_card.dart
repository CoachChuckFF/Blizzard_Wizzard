import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/device.dart';

abstract class SettingsCard extends StatelessWidget{
  final Device device;
  final Function(String) alertMessage;

  SettingsCard([this.device, this.alertMessage]);
}