import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/fixture.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/ws_fixtures.dart';
import 'package:blizzard_wizzard/views/fixes/list_view_alert_buttons_dialog.dart';
import 'package:blizzard_wizzard/controllers/fixture_manager.dart';

class LibraryPatchFixturePage extends StatefulWidget {
 
  final ValueChanged<int> callback;
  final ValueChanged<Fixture> changeFixture;
  final Fixture fixture;

  LibraryPatchFixturePage({this.callback, this.fixture, this.changeFixture});

  @override
  createState() => LibraryPatchFixturePageState();
}

class LibraryPatchFixturePageState extends State<LibraryPatchFixturePage>  {
  int state;
  bool isLoading;
  String brand;
  WSFixtureType fixture;
  List<String> fixtureList;
  List<WSFixtureType> wsFixtureList;

  initState(){
    super.initState();
    state = PatchFixtureLibraryState.brand;
    isLoading = true;
    brand = "";
    _buildList();
  }

  _setFixture(bool longPress){

    setState(() {
      isLoading = true;    
    });
    sid.getFixture(
      fixture
    ).then((fix){
      widget.changeFixture(fix);
      widget.callback((!longPress) ? 
        (fix.profile.length == 1) ? 
          PatchFixtureState.patchFromLibrary :
          PatchFixtureState.mode : 
        PatchFixtureState.manufacturer);
    });
  }

  _buildList(){
    fixtureList = List<String>();
    setState(() {
      isLoading = true;  
    });
    switch(state){
      case PatchFixtureLibraryState.brand:
        sid.getAllFixtures().then((fixList){
          fixList.forEach((fix){
          if(!fixtureList.contains(fix.brand)){
              fixtureList.add(fix.brand);
            }
          });
          setState(() {
            fixtureList.sort((a, b){
              return a.toUpperCase().compareTo(b.toUpperCase());
            });
            isLoading = false;    
          });
        });
      break;
      case PatchFixtureLibraryState.fixture:
        wsFixtureList = List<WSFixtureType>();
        sid.getAllFixtures().then((fixList){
          fixList.where((fix){
            return fix.brand == brand;
          }).forEach((fix){
            fixtureList.add(fix.name);
            wsFixtureList.add(fix);
          });
          setState(() {
            if(fixtureList.length != 0){
              fixtureList.sort((a, b){
                return a.toUpperCase().compareTo(b.toUpperCase());
              });
              wsFixtureList.sort((a, b){
                return a.name.toUpperCase().compareTo(b.name.toUpperCase());
              });

              isLoading = false;

            } else {
              state = PatchFixtureLibraryState.brand;
              _buildList();
            }  
          });
        });
      break;
    }
  }

  Widget build(BuildContext context) {
    return ListViewAlertButtonsDialog(
      title: Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Library",
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        )
      ),
      actions: <Widget>[
        BlizzardDialogButton(
          text: "Back",
          color: Colors.red,
          onTap: (){
            widget.callback(PatchFixtureState.main);
          }
        ),
      ],
      content: (!isLoading) ?
      Column(
        children: <Widget>[
          (state == PatchFixtureLibraryState.fixture) ?
          ListTile(
            selected: true,
            leading: Icon(
              Icons.arrow_back,
              size: 30.0
            ),
            title: Text(
              brand,
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold
              )
            ),
            onTap: (){   
              setState(() {
                state = PatchFixtureLibraryState.brand;
                _buildList();
              });
            },
          ): 
          Container(),
          Expanded(
            child: ListView.builder(
              itemCount: fixtureList.length,
              itemBuilder: (context, index){
                Widget tile = Card(
                  child: ListTile(
                    title: Text(
                      fixtureList[index],
                      style: TextStyle(
                        fontSize: 21.0,
                      )
                    ),
                    trailing: (state == PatchFixtureLibraryState.fixture) ?
                      (!wsFixtureList[index].isWS) ?
                        Icon(
                          Icons.ac_unit
                        ) : 
                        null : 
                      null,
                    onTap: (){
                      if(state == PatchFixtureLibraryState.brand){
                        setState(() {
                          print("here");
                          state = PatchFixtureLibraryState.fixture;
                          brand = fixtureList[index];
                          _buildList();
                        });
                      } else {
                        fixture = wsFixtureList[index];
                        _setFixture(false);
                      }
                    },
                    onLongPress: (state == PatchFixtureLibraryState.fixture) ?
                      (){
                        WSFixtureType fix = wsFixtureList[index];
                        if(fix.isWS){
                          fixture = fix;
                          _setFixture(true);
                        } else {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text(
                                "${fix.brand} ${fix.name}"
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Colors.green
                                    ),
                                  ),
                                  onPressed: (){
                                    fixture = fix;
                                    _setFixture(true);
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.red
                                    ),
                                  ),
                                  onPressed: (){
                                    sid.deleteUserFixture(fix);
                                    Navigator.pop(context);
                                    _buildList();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                          );
                        }
                      } :
                    null,
                  )
                );
                if(state == PatchFixtureLibraryState.brand){
                  switch(fixtureList[index]){
                    case "American DJ":
                      tile = Tooltip(
                        message: "Ew",
                        child: tile,
                      );
                    break;
                    case "Chauvet":
                      tile = Tooltip(
                        message: "Gross",
                        child: tile,
                      );
                    break;
                    case "Blizzard Lighting":
                    case "Blizzard Pro":
                      tile = Tooltip(
                        message: "Good Choice",
                        child: tile,
                        preferBelow: false,
                      );
                    break;
                  }
                }
                return tile;
              }
            ),
          )
        ]
      ) : 
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

