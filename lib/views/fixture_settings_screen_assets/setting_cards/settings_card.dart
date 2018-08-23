import 'package:flutter/material.dart';
import 'package:blizzard_wizzard/models/fixture.dart';

abstract class SettingsCard extends StatelessWidget{
  final Fixture fixture;
  final Function(String) alertMessage;

  SettingsCard([this.fixture, this.alertMessage]);
}