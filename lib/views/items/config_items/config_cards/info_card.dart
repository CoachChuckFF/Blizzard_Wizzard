import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:d_artnet/d_artnet.dart';
import 'package:blizzard_wizzard/models/models.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';
import 'package:blizzard_wizzard/controllers/artnet_server.dart';
import 'package:blizzard_wizzard/architecture/globals.dart';

class InfoCard extends ConfigCard {

  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  InfoCard(profile, alertMessage) : super(profile, alertMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(this.profile.address.toString()),
    );
  }
}
