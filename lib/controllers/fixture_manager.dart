import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:xml/xml.dart' as xml;

class FixtureManager{

  static Future<Fixture> getFixture(String filename) async{
    return await rootBundle.loadString(filename).then<Fixture>((asset){
      return _parseWSFixture(asset);
    });
  }

  static Fixture _parseWSFixture(String asset){
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
    /*
    print(fixture.name);
    print(fixture.brand);
    print(fixture.profile.length);
    fixture.profile.forEach((profile){
      print("* " + profile.name);
      print("* " + profile.channels.length.toString());
      profile.channels.forEach((channel){
        print("** " + channel.name);
        print("** " + channel.number.toString());
        print("** " + channel.segments.length.toString());
        channel.segments.forEach((segment){
          print("*** " + segment.name);
          print("*** " + segment.start.toString());
          print("*** " + segment.end.toString());
        });
      });
    });*/

    return fixture;
  }
}