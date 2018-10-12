import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/cue.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_edit_dialog.dart';
import 'package:blizzard_wizzard/views/editor_screen_assets/cue_item.dart';

class CueListArea extends StatefulWidget {
  final List<Cue> cues;
  final ValueChanged<int> callback;
  final int startIndex;

  CueListArea({Key key, this.cues, this.callback, this.startIndex = 0}) : super(key: key);

  @override
  createState() => CueListAreaState();
}

class CueListAreaState extends State<CueListArea> {
  List<Cue> _cues;
  int _selected;

  void _hideAllScenes(){
    List<Mac> macs = List<Mac>();

    _cues[_selected].scenes.forEach((scene){
      scene.sceneData.forEach((data){
        if(!macs.contains(data.mac)){
          macs.add(data.mac);
        }
      });
    });

    StoreProvider.of<AppState>(context).state.availableDevices.where((device){
      return macs.contains(device.mac);
    }).forEach((device){
      device.dmxData.blackout();
      tron.server.sendPacket(device.dmxData.udpPacket, device.address);
    });
  }

  void _handleEdit(Cue cue, int index){

    if(cue == null){
      if(index == _selected){
        _hideAllScenes();
        setState(() {
          _selected = 0;               
        });
      } else if(index < _selected){
        setState(() {
          _selected--;               
        });
      }
      _cues.removeAt(index);
      widget.callback(_selected);
    } else {
      _cues[index] = _cues[index].copyWith(name: cue.name);
    }

    StoreProvider.of<AppState>(context).dispatch(UpdateCueList(
      _cues,
    ));
  }

  @override
  initState() {
    super.initState();
    _cues = List.from(widget.cues);
    _selected = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        controller: ScrollController(),
        children: _buildListView(),
      ),
    );
  }

  List<Widget> _buildListView() {
    List<Widget> list = List<Widget>();
    int i = 0;

    list.add(
      Text(
        "Cues",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0
        ),
      ),
    );

    _cues.forEach((cue){
      list.add(
        CueItem(
          key: Key("CUE_${cue.id}"),
          cue: cue,
          selected: (i == _selected),
          index: i++,
          onTap: (index){
            if(index != _selected){
              setState(() {
                _hideAllScenes();
                _selected = index;    
                widget.callback(index);       
              });
            }
          },
          onDoubleTap: (index){
            showDialog(
              context: context,
              child: CueEditDialog(
                cue: _cues[index],
                callback: (cue){
                  setState(() {
                    _handleEdit(cue, index);                                 
                  });
                },
              )
            );
          },
        )
      );
    });

    return list;
  }
}
