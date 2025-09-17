import 'package:flutter/material.dart';

@immutable
class Appliance {

  const Appliance({
    required this.id,
    required this.name,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
  final int id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Appliance && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'Appliance(id: $id, name: $name)';
}

@immutable
class Channel {

  const Channel({
    required this.id,
    required this.applianceId,
    required this.personalizedName,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as int,
      applianceId: json['applianceId'] as int,
      personalizedName: json['personalizedName'] as String,
    );
  }
  final int id;
  final int applianceId;
  final String personalizedName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applianceId': applianceId,
      'personalizedName': personalizedName,
    };
  }

  Channel copyWith({
    int? id,
    int? applianceId,
    String? personalizedName,
  }) {
    return Channel(
      id: id ?? this.id,
      applianceId: applianceId ?? this.applianceId,
      personalizedName: personalizedName ?? this.personalizedName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Channel &&
        other.id == id &&
        other.applianceId == applianceId &&
        other.personalizedName == personalizedName;
  }

  @override
  int get hashCode => Object.hash(id, applianceId, personalizedName);

  @override
  String toString() =>
      'Channel(id: $id, applianceId: $applianceId, personalizedName: $personalizedName)';
}
