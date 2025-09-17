part of 'thermostat_bloc.dart';

sealed class ThermostatState extends ErrorState {}

final class ThermostatStateData extends ThermostatState {
  ThermostatStateData({
    this.thermostats,
  });
  List<ThermostatDevice>? thermostats;
}

final class ThermostatInitial extends ThermostatState {}

final class ThermostatLoading extends ThermostatState {}

final class ThermostatError extends ThermostatState {}

final class FetchAllThermostatsLoading extends ThermostatState {}

final class FetchAllThermostatsSuccess extends ThermostatState {}

final class FetchOneThermostatLoading extends ThermostatState {}

final class FetchOneThermostatSuccess extends ThermostatState {
  FetchOneThermostatSuccess({this.thermostat});
  final ThermostatDevice? thermostat;
}

final class CreateClimatePresetLoading extends ThermostatState {}

final class CreateClimatePresetSuccess extends ThermostatState {}
