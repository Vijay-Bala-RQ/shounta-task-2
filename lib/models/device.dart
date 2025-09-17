import 'package:flutter/foundation.dart';

@immutable
class Device {
  const Device({
    required this.id,
    required this.order,
    required this.modelNumber,
    required this.serialNumber,
    required this.channelCount,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      order: json['order'] as int,
      modelNumber: json['modelNumber'] as int,
      serialNumber: json['serialNumber'] as String,
      channelCount: json['channelCount'] as int,
    );
  }

  final int id;
  final int order;
  final int modelNumber;
  final String serialNumber;
  final int channelCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order': order,
        'modelNumber': modelNumber,
        'serialNumber': serialNumber,
        'channelCount': channelCount,
      };

  @override
  String toString() =>
      'Device(id: $id, order: $order, modelNumber: $modelNumber, serialNumber: $serialNumber, channelCount: $channelCount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Device &&
          id == other.id &&
          order == other.order &&
          modelNumber == other.modelNumber &&
          serialNumber == other.serialNumber &&
          channelCount == other.channelCount;

  @override
  int get hashCode =>
      id.hashCode ^
      order.hashCode ^
      modelNumber.hashCode ^
      serialNumber.hashCode ^
      channelCount.hashCode;

  static List<Device> fromJsonList(List<dynamic> jsonList) => jsonList
      .map((json) => Device.fromJson(json as Map<String, dynamic>))
      .toList();
}
