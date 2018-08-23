import 'package:meta/meta.dart';
import 'package:blizzard_wizzard/models/fixture.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Fixture> availableDevices;

  AppState(
      {this.isLoading = true,
       this.availableDevices = const []});

  factory AppState.init() => new AppState(isLoading: true, availableDevices: new List<Fixture>());

  AppState copyWith({
    bool isLoading,
    List<Fixture> availableDevices,
  }) {
    return new AppState(
      isLoading: isLoading ?? this.isLoading,
      availableDevices: availableDevices ?? this.availableDevices,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      availableDevices.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          availableDevices == other.availableDevices;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading}';
  }

}