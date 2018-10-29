import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/ws_fixtures.dart';
import 'package:xml/xml.dart' as xml;

class FixtureManager{
  bool _updated = false;
  List<WSFixtureType> _userFixtures;

  writeTestFile() async{
    saveUserFixture(Fixture(
      name: "Test",
      brand: "Blizzard Pro",
      profile: <ChannelMode>[
        ChannelMode(
          name: "3 CH",
          channels: <Channel>[
            Channel(
              name: "Red",
              number: 1
            ),
            Channel(
              name: "Green",
              number: 2
            ),
            Channel(
              name: "Blue",
              number: 3
            )
          ],
        )
      ],
    ));
  }

  readTestFile() async{
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = File("${directory.path}/fixtures/Blizzard_Pro.Test");

    Directory("${directory.path}/fixtures/").list().forEach((entity){
      if(entity is File){
        print(basename(entity.path));
      }
    });

    if(file.existsSync()){
      print(file.readAsStringSync());
    }
  }

  Future<Fixture> getFixture(WSFixtureType fixture) async{
    if(Fixture == null){
      return null;
    }
    if(fixture.isWS){
      return await rootBundle.loadString(WSFixtures.preamble + fixture.filename).then<Fixture>((asset){
        return _parseWSFixture(asset);
      });
    } else {
      return await File(fixture.filename).readAsString().then<Fixture>((data){
        return _parseWSFixture(data);
      });
    }
  }

  Future<List<WSFixtureType>> getAllFixtures() async{
    List<WSFixtureType> fixtures = List<WSFixtureType>();

    if(!_updated){
      await _getUserFixtures();
    }
    
    fixtures.addAll(WSFixtures.fixtures);
    fixtures.addAll(_userFixtures);

    return fixtures;
  }

  deleteUserFixture(WSFixtureType fixture){
    File file = File(fixture.filename);
    if(file.existsSync()){
      file.deleteSync();
      _updated = false;
    }
  }

  Future saveUserFixture(Fixture fixture) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    File file;
    String fileString = "";

    fileString += '<?xml version="1.0" encoding="UTF-8"?><ofl>';

    fileString += '<brand name="${fixture.brand}"></brand>';

    fileString += '<fixture name="${fixture.name}">';

    fixture.profile.forEach((mode){
      fileString += '<mode name="${mode.name}">';
      mode.channels.forEach((channel){
        fileString += '<channel number="${channel.number + 1}" name="${channel.name}">';
        channel.segments.forEach((segment){
          fileString += '<segment name="${segment.name}" start="${segment.start}" end="${segment.end}"></segment>';
        });
        fileString += '</channel>';
      });
      fileString += '</mode>';
    });

    fileString += '</fixture></ofl>';

    _updated = false;

    file = File("${directory.path}/fixtures/${fixture.brand.replaceAll(" ", "_")}.${fixture.name.replaceAll(" ", "_")}");

    await file.create(recursive: true);

    return await file.writeAsString(fileString);
  }

  Future<List<WSFixtureType>> _getUserFixtures() async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory fixtureDir = Directory(directory.path + "/fixtures");
    List<WSFixtureType> fixtures = List<WSFixtureType>();

    if(!fixtureDir.existsSync()){
      fixtureDir.createSync();

      _userFixtures = fixtures;
      _updated = true;

      return fixtures;
    }

    await fixtureDir.list(recursive: true).forEach((entity){
      if(entity is File){
        List<String> split = basename((entity.path).replaceAll("_", " ")).split(".");
        fixtures.add(
          WSFixtureType(
            split[0],
            split[1],
            entity.path,
            isWS: false
          )
        );
      }
    });

    _userFixtures = fixtures;
    _updated = true;

    return fixtures;
  }

  Fixture _parseWSFixture(String asset){
    Fixture fixture = Fixture();
    xml.XmlElement file;

    file = xml.parse(asset).findElements("ofl").first;

    fixture.brand = file.findElements("brand").first.getAttribute("name");
    file = file.findElements("fixture").first;

    fixture.name = file.getAttribute("name");

    fixture.profile = List<ChannelMode>();

    file.findElements("mode").forEach((mode){
      ChannelMode cm = ChannelMode();
      cm.name = mode.getAttribute("name");
      cm.channels = List<Channel>();

      mode.findAllElements("channel").forEach((channel){
        Channel c = Channel();
        c.name = channel.getAttribute("name");
        c.number = int.parse(channel.getAttribute("number"))-1;
        c.segments = List<Segment>();
        
        channel.findElements("segment").forEach((segment){
          c.segments.add(Segment(
            name: segment.getAttribute("name"),
            start: int.parse(segment.getAttribute("start")),
            end: int.parse(segment.getAttribute("end"))
          ));
        });

        cm.channels.add(c);
      });

      fixture.profile.add(cm);
    });

    return fixture;
  }
}