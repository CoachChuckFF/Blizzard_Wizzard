import 'package:meta/meta.dart';
import 'package:blizzard_wizzard/models/device.dart';
import 'package:blizzard_wizzard/models/mac.dart';
import 'package:blizzard_wizzard/models/patched_device.dart';
import 'package:blizzard_wizzard/models/show.dart';

@immutable
class AppState {
  final bool isLoading;
  final bool hasKeyboard;
  final List<Device> availableDevices;
  final Show show;

  AppState(
      {this.isLoading = true,
      this.hasKeyboard = false,
      this.availableDevices = const [],
      this.show});

  factory AppState.init() => new AppState(isLoading: true, 
    availableDevices: new List<Device>(), 
    hasKeyboard: false, 
    show: Show(
      ques: const [],
      patchedDevices: Map<int,PatchedDevice>(),
      patchedQues: Map<int,int>(),
      patchedFixtures: Map<int,int>(), 
      name: "Test"
    ));

  AppState copyWith({
    bool isLoading,
    bool hasKeyboard,
    List<Device> availableDevices,
    Show show
  }) {
    return new AppState(
      isLoading: isLoading ?? this.isLoading,
      hasKeyboard: isLoading ?? this.isLoading,
      availableDevices: availableDevices ?? this.availableDevices,
      show: show ?? this.show,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      hasKeyboard.hashCode ^
      availableDevices.hashCode ^
      show.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          hasKeyboard == other.hasKeyboard &&
          availableDevices == other.availableDevices &&
          show == other.show;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading}';
  }

}