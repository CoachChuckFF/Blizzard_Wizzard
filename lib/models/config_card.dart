import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/models.dart';

abstract class ConfigCard extends StatelessWidget{
  final Profile profile;
  final Function(String) alertMessage;

  ConfigCard([this.profile, this.alertMessage]);
}