import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:blizzard_wizzard/models/actions.dart';
import 'package:blizzard_wizzard/models/app_state.dart';
import 'package:blizzard_wizzard/models/globals.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_fixture.dart';
import 'package:blizzard_wizzard/models/ws_fixtures.dart';
import 'package:blizzard_wizzard/views/screens/blizzard_screen.dart';
import 'package:blizzard_wizzard/controllers/artnet_controller.dart';
import 'package:blizzard_wizzard/controllers/fixture_manager.dart';
import 'package:blizzard_wizzard/controllers/reducers.dart';

void main(){
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
  );

  runApp(MyApp(
    title: 'Artnet Tester',
    store: store,
  ));
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;
  final String title;

  MyApp({Key key, this.store, this.title}){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tron = ArtnetController(widget.store);
    sid = FixtureManager();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    switch(state){
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.suspending:
        tron.dispose();
        break;
      case AppLifecycleState.resumed:
        tron = ArtnetController(widget.store);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        showPerformanceOverlay: false,
        title: widget.title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlizzardScreen()
      ),
    );
  }
}