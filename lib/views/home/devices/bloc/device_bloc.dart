import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../api_services/device_service.dart';
import '../../../../core/base_bloc/base_bloc.dart';
import '../../../../models/models.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends BaseBloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitial());

  DeviceStateData deviceStateData = DeviceStateData();
  final DeviceService deviceService = DeviceService();

  Future<void> _fetchAllDevices(
      FetchAllDevicesEvent event, Emitter<DeviceState> emit) async {
    emit(FetchAllDevicesLoading());

    final Map<String, dynamic>? res = await deviceService.fetchDevices();

    final List<Device> devices =
        (res?['devices'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => Device.fromJson(e as Map<String, dynamic>))
            .toList();

    emit(deviceStateData..devices = devices);
    emit(FetchAllDevicesSuccess());
  }

  Future<void> _fetchDeviceChannels(
      FetchDeviceChannelsEvent event, Emitter<DeviceState> emit) async {
    emit(FetchDeviceChannelsLoading());

    final Map<String, dynamic>? res =
        await deviceService.fetchDeviceChannels(event.id);

    final List<Channel> channels =
        (res?['channels'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => Channel.fromJson(e as Map<String, dynamic>))
            .toList();

    emit(FetchDeviceChannelsSuccess(channels: channels));
  }

  Future<void> _fetchAllAppliances(
      FetchAllAppliancesEvent event, Emitter<DeviceState> emit) async {
    emit(FetchAllAppliancesLoading());

    final Map<String, dynamic>? res = await deviceService.fetchAllAppliances();

    final List<Appliance> appliances =
        (res?['appliances'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => Appliance.fromJson(e as Map<String, dynamic>))
            .toList();

    emit(deviceStateData..appliances = appliances);
    emit(FetchAllAppliancesSuccess());
  }

  Future<void> _updateDeviceChannels(
      UpdateDeviceChannelsEvent event, Emitter<DeviceState> emit) async {
    emit(UpdateDeviceChannelsLoading());

    final Map<String, dynamic> body = {
      'channels': event.channels,
    };

    await deviceService.updateDeviceChannels(event.id, body);

    emit(UpdateDeviceChannelsSuccess());
  }

  @override
  Future<void> eventHandlerMethod(
      DeviceEvent event, Emitter<DeviceState> emit) async {
    switch (event.runtimeType) {
      case const (FetchAllDevicesEvent):
        return _fetchAllDevices(event as FetchAllDevicesEvent, emit);
      case const (FetchDeviceChannelsEvent):
        return _fetchDeviceChannels(event as FetchDeviceChannelsEvent, emit);
      case const (FetchAllAppliancesEvent):
        return _fetchAllAppliances(event as FetchAllAppliancesEvent, emit);
      case const (UpdateDeviceChannelsEvent):
        return _updateDeviceChannels(event as UpdateDeviceChannelsEvent, emit);
    }
  }

  @override
  DeviceState getErrorState() {
    return DevicesError();
  }
}
