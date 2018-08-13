import 'package:flutter/widgets.dart';

class BlizzardWizzardKeys {
  // Home Screens
  static final homeScreen = const Key('__homeScreen__');
  static final addTodoFab = const Key('__addTodoFab__');
  static final snackbar = const Key('__snackbar__');

  // Available Devices
  static final availableDevicesList = const Key('__availableDevices__');
  static final availableDevice = (String id) => new Key('availableDevice__${id}');
  static final availableDeviceName = (String id) => new Key('availableDevice__${id}__Name');
  static final availableDeviceIp = (String id) => new Key('availableDevice__${id}__Ip');
  static final availableDeviceType = (String id) => new Key('availableDevice__${id}__Type');

  // Config Wizzard Screen
  static final configWizzardScreen = const Key('__configWizzardScreen__');

  // Tabs
  static final tabs = const Key('__tabs__');
  static final todoTab = const Key('__todoTab__');
  static final statsTab = const Key('__statsTab__');

  // Extra Actions
  static final extraActionsButton = const Key('__extraActionsButton__');
  static final toggleAll = const Key('__markAllDone__');
  static final clearCompleted = const Key('__clearCompleted__');

  // Filters
  static final filterButton = const Key('__filterButton__');
  static final allFilter = const Key('__allFilter__');
  static final activeFilter = const Key('__activeFilter__');
  static final completedFilter = const Key('__completedFilter__');

  // Stats
  static final statsCounter = const Key('__statsCounter__');
  static final statsLoading = const Key('__statsLoading__');
  static final statsNumActive = const Key('__statsActiveItems__');
  static final statsNumCompleted = const Key('__statsCompletedItems__');

  // Details Screen
  static final editTodoFab = const Key('__editTodoFab__');
  static final deleteTodoButton = const Key('__deleteTodoFab__');
  static final todoDetailsScreen = const Key('__todoDetailsScreen__');
  static final detailsTodoItemCheckbox = new Key('DetailsTodo__Checkbox');
  static final detailsTodoItemTask = new Key('DetailsTodo__Task');
  static final detailsTodoItemNote = new Key('DetailsTodo__Note');

  // Add Screen
  static final addTodoScreen = const Key('__addTodoScreen__');
  static final saveNewTodo = const Key('__saveNewTodo__');

  // Edit Screen
  static final editTodoScreen = const Key('__editTodoScreen__');
  static final saveTodoFab = const Key('__saveTodoFab__');
}
