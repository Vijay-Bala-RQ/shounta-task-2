part of 'device_bloc.dart';

sealed class DeviceState extends ErrorState {}

final class DeviceStateData extends DeviceState {
  DeviceStateData({this.devices, this.appliances});
  List<Device>? devices;
  List<Appliance>? appliances;
}

final class DeviceInitial extends DeviceState {}

final class DeviceLoading extends DeviceState {}

final class DevicesError extends DeviceState {}

final class FetchAllDevicesLoading extends DeviceState {}

final class FetchAllDevicesSuccess extends DeviceState {}

final class FetchDeviceChannelsLoading extends DeviceState {}

final class FetchDeviceChannelsSuccess extends DeviceState {
  FetchDeviceChannelsSuccess({required this.channels});
  final List<Channel> channels;
}

final class FetchAllAppliancesLoading extends DeviceState {}

final class FetchAllAppliancesSuccess extends DeviceState {}

final class UpdateDeviceChannelsLoading extends DeviceState {}

final class UpdateDeviceChannelsSuccess extends DeviceState {}
