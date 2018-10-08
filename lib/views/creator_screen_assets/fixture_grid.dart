import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/views/creator_screen_assets/fixture_grid_assets/patch_fixture_dialog.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';


class FixtureGrid extends StatelessWidget {
  final int cols;
  final String fontFamily = "Roboto";
  final Map<int, PatchedFixture> patchedFixtures;
  final List<int> selectedFixtures;
  final ValueChanged<List<int>> callback;

  FixtureGrid({
    this.cols = 5,
    this.patchedFixtures,
    this.selectedFixtures,
    this.callback
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
      itemCount: BlizzardWizzardConfigs.artnetMaxUniverses,
      itemBuilder: (BuildContext context, int index) {
        bool isPatched = false;
        bool isConnected = false;
        bool isSelected = false;
        double fontSize = 21.0;
        Color textColor = Theme.of(context).primaryColor;
        Color boxColor = Colors.white;
        String info = "${index + 1}";

        if(patchedFixtures.containsKey(index)){
          Mac searchMac = patchedFixtures[index].mac;
          Device dev = StoreProvider.of<AppState>(context).state.availableDevices.firstWhere((device) => device.mac == searchMac, orElse: () => null);
          info = patchedFixtures[index].name;
          if(dev == null){
            if(isSelected){
              callback(List.from(selectedFixtures)..remove(index));
            }
            
            boxColor = Colors.grey;
            textColor = Colors.white;
          } else {
            isConnected = true;
          }
          isPatched = true;
          fontSize = 13.0; 

          if(selectedFixtures.contains(index)){
            textColor = Colors.white;
            boxColor = Theme.of(context).primaryColor;
            isSelected = true;
          }
        }

        return Material(
          color: boxColor,
          child: Container(
            child: InkWell(
              child: Center(
                child: Text(
                  info,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                    color: textColor,
                  ),
                ),
              ),
              onTap: (){
                if(callback != null){
                  if(isPatched && isConnected){
                    if(isSelected){
                      callback(List.from(selectedFixtures)..remove(index));
                    } else {
                      callback(List.from(selectedFixtures)..add(index));
                    }
                  } else if(!isPatched){
                    showDialog(
                      context: context,
                      child: StoreConnector<AppState, List<Device>>(
                        converter: (store) => store.state.availableDevices,
                        builder: (context, availableDevices) {
                          return Theme(
                            child: PatchFixtureDialog(index),
                            data: ThemeData(
                              primarySwatch: Colors.blue,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
              onDoubleTap: (){
                if(callback != null){
                  if(isPatched && isConnected){
                    if(isSelected){
                      callback(<int>[]);
                    } else {
                      callback(patchedFixtures.keys.toList());
                    }
                  } else if(!isPatched){
                    /*showDialog(
                      context: context,
                      child: StoreConnector<AppState, List<Device>>(
                        converter: (store) => store.state.availableDevices,
                        builder: (context, availableDevices) {
                          return PatchDeviceDialog(
                            index: index,
                            devices: availableDevices,
                            patchedDevices: patchedDevices,
                            callback: callback,
                          );
                        },
                      ),
                    );*/
                  }
                }
              },
              onLongPress: (){
                if(isPatched && isConnected){
                  showDialog(
                    context: context,
                    child: StoreConnector<AppState, List<Device>>(
                      converter: (store) => store.state.availableDevices,
                      builder: (context, availableDevices) {
                        return EditFixtureDialog(
                          index: index,
                          fixture: patchedFixtures[index],
                          callback: callback,
                        );
                      },
                    ),
                  );
                } else if(!isPatched){
                  /*showDialog(
                    context: context,
                    child: StoreConnector<AppState, List<Device>>(
                      converter: (store) => store.state.availableDevices,
                      builder: (context, availableDevices) {
                        return PatchDeviceDialog(
                          index: index,
                          devices: availableDevices,
                          patchedDevices: patchedDevices,
                          callback: callback,
                        );
                      },
                    ),
                  );*/
                }
              },
            ),
          )
        );
      },
    );
  }
}

class EditFixtureDialog extends StatefulWidget {
 
  EditFixtureDialog({this.fixture, this.callback, this.index});

  final PatchedFixture fixture;
  final ValueChanged<List<int>> callback;
  final int index;

  @override
  createState() => EditFixtureDialogState();
}

class EditFixtureDialogState extends State<EditFixtureDialog> {
  bool _clearAll;
  int _startAddress;
  int _startMode;
  Key _startKey;


  EditFixtureDialogState();

  @override
  initState() {
    super.initState();
    _clearAll = false;
    _startAddress = widget.fixture.fixture.patchAddress;
    _startMode = widget.fixture.fixture.channelMode;
    _startKey = Key("SK");
  }

  Widget build(BuildContext context) {


    return ListViewAlertButtonsDialog(
      title: Text(
        widget.fixture.name,
        style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Robot",
        ),
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: (_clearAll) ? "Unpatch All" : "Unpatch Fixture",
          color: Colors.red,
          onTap: (){
            if(_clearAll){
              StoreProvider.of<AppState>(context).dispatch(ClearPatchFixture());
            } else {
              StoreProvider.of<AppState>(context).dispatch(RemovePatchFixture(
                widget.index));
            }
            widget.callback([]);
            Navigator.pop(context);
          },
          onLongPress: (){
            setState(() {
              _clearAll = !_clearAll;
            });
          },
        ),
        BlizzardDialogButton(
          text: (widget.fixture.fixture.patchAddress == _startAddress &&
          widget.fixture.fixture.channelMode == _startMode) ? "Cancel" : "Save",
          color: (widget.fixture.fixture.patchAddress == _startAddress &&
          widget.fixture.fixture.channelMode == _startMode) ? Colors.blue : Colors.green,
          onTap: (){
            StoreProvider.of<AppState>(context).dispatch(AddPatchFixture(
              widget.index,
              widget.fixture
            ));
            Navigator.pop(context);
          },
        ),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          (widget.fixture.fixture.profile.length == 1) ?
          Container() :
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Channel Mode",
                    style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: widget.fixture.fixture.profile.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          selected: (widget.fixture.fixture.channelMode == index),
                          title: Text(
                            widget.fixture.fixture.profile[index].name,
                            style: TextStyle(
                              fontSize: 21.0,
                            )
                          ),
                          onTap: (){
                            setState(() {
                              widget.fixture.fixture.channelMode = index;
                            });
                          },
                        )
                      );
                    }
                  ),
                )
              ],
            )
          ),
          Expanded(
            flex: 2,
            child: Card(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onLongPress: (){
                      setState(() {
                        _startKey = Key("SK${widget.fixture.fixture.patchAddress}");
                        widget.fixture.fixture.patchAddress = _startAddress;
                      });
                    }
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.copyWith(
                        headline: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold
                        ),
                        body1: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        )
                      )
                    ),
                    child: NumberPicker.integer(
                      key: _startKey,
                      listViewWidth: double.infinity,
                      itemExtent: 69.0,
                      initialValue: widget.fixture.fixture.patchAddress,
                      minValue: 1,
                      maxValue: 512,
                      onChanged: (address){
                      setState(() {
                        widget.fixture.fixture.patchAddress = address;
                      });
                    }),
                  )
                ],
              ),
            )
          ),
        ]
      )
    );
  }
}