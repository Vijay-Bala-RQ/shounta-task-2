part of 'device_bloc.dart';

sealed class DeviceEvent {}

final class FetchAllDevicesEvent extends DeviceEvent {}

final class FetchDeviceChannelsEvent extends DeviceEvent {
  FetchDeviceChannelsEvent({required this.id});
  final int? id;
}

final class FetchAllAppliancesEvent extends DeviceEvent {}

final class UpdateDeviceChannelsEvent extends DeviceEvent {
  UpdateDeviceChannelsEvent({required this.id, required this.channels});
  final int? id;
  final List<Map<String, dynamic>> channels;
}
