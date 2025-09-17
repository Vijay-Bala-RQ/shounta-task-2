import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../api_services/thermostat_service.dart';
import '../../../../core/base_bloc/base_bloc.dart';
import '../../../../models/thermostat_device.dart';

part 'thermostat_event.dart';
part 'thermostat_state.dart';

class ThermostatBloc extends BaseBloc<ThermostatEvent, ThermostatState> {
  ThermostatBloc() : super(ThermostatInitial());

  final ThermostatService thermostatService = ThermostatService();

  ThermostatStateData thermostatStateData = ThermostatStateData();

  Future<void> _fetchAllThermostats(
      FetchAllThermostats event, Emitter<ThermostatState> emit) async {
    emit(FetchAllThermostatsLoading());

    final Map<String, dynamic>? res =
        await thermostatService.fetchThermostats();
    final List<ThermostatDevice> thermostats =
        (res?['thermostats'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => ThermostatDevice.fromJson(e as Map<String, dynamic>))
            .toList();
    emit(thermostatStateData..thermostats = thermostats);
    emit(FetchAllThermostatsSuccess());
  }

  Future<void> _fetchOneThermostat(
      FetchOneThermostat event, Emitter<ThermostatState> emit) async {
    emit(FetchOneThermostatLoading());

    final Map<String, dynamic> queryParams = <String, dynamic>{};

    if (event.deviceId != null) {
      queryParams['device_id'] = event.deviceId;
    }

    final Map<String, dynamic>? res =
        await thermostatService.fetchOneThermostat(queryParams);
    final ThermostatDevice thermostat = ThermostatDevice.fromJson(
        (res?['thermostat'] ?? <dynamic, dynamic>{}) as Map<String, dynamic>);

    emit(FetchOneThermostatSuccess(thermostat: thermostat));
  }

  Future<void> _createClimatePreset(
      CreateClimatePreset event, Emitter<ThermostatState> emit) async {
    emit(CreateClimatePresetLoading());

    final Map<String, dynamic> body = <String, dynamic>{};
    if (event.deviceId != null) {
      body['device_id'] = event.deviceId;
    }
    if (event.climatePresetKey != null) {
      body['climate_preset_key'] = event.climatePresetKey;
    }
    if (event.name != null) {
      body['name'] = event.name;
    }
    if (event.fanModeSetting != null) {
      body['fan_mode_setting'] = event.fanModeSetting;
    }
    if (event.hvacModeSetting != null) {
      body['hvac_mode_setting'] = event.hvacModeSetting;
    }
    if (event.heatingSetPointFahrenheit != null) {
      body['heating_set_point_fahrenheit'] = event.heatingSetPointFahrenheit;
    }
    if (event.coolingSetPointFahrenheit != null) {
      body['cooling_set_point_fahrenheit'] = event.coolingSetPointFahrenheit;
    }
    if (event.manualOverrideAllowed != null) {
      body['manual_override_allowed'] = event.manualOverrideAllowed;
    }

    await thermostatService.createClimatePreset(body);

    emit(CreateClimatePresetSuccess());
  }

  @override
  Future<void> eventHandlerMethod(
      ThermostatEvent event, Emitter<ThermostatState> emit) async {
    switch (event.runtimeType) {
      case const (FetchAllThermostats):
        return _fetchAllThermostats(event as FetchAllThermostats, emit);
      case const (FetchOneThermostat):
        return _fetchOneThermostat(event as FetchOneThermostat, emit);
      case const (CreateClimatePreset):
        return _createClimatePreset(event as CreateClimatePreset, emit);
    }
  }

  @override
  ThermostatState getErrorState() {
    return ThermostatError();
  }
}
