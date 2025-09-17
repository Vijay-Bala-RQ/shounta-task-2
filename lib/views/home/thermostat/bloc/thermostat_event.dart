part of 'thermostat_bloc.dart';

sealed class ThermostatEvent {}

final class FetchAllThermostats extends ThermostatEvent {}

final class FetchOneThermostat extends ThermostatEvent {
  FetchOneThermostat({this.deviceId});
  final String? deviceId;
}

final class CreateClimatePreset extends ThermostatEvent {
  CreateClimatePreset(
      {this.deviceId,
      this.climatePresetKey,
      this.name,
      this.fanModeSetting,
      this.hvacModeSetting,
      this.heatingSetPointFahrenheit,
      this.coolingSetPointFahrenheit,
      this.manualOverrideAllowed});
  final String? deviceId;
  final String? climatePresetKey;
  final String? name;
  final String? fanModeSetting;
  final String? hvacModeSetting;
  final int? heatingSetPointFahrenheit;
  final int? coolingSetPointFahrenheit;
  final bool? manualOverrideAllowed;
}
