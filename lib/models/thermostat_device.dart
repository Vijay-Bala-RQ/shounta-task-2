class ThermostatDevice {
  ThermostatDevice({
    this.deviceId,
    this.nickname,
    this.displayName,
    this.deviceType,
    this.capabilitiesSupported,
    this.properties,
    this.location,
    this.connectedAccountId,
    this.workspaceId,
    this.createdAt,
    this.errors,
    this.warnings,
    this.isManaged,
    this.customMetadata,
    this.canHvacCool,
    this.canHvacHeat,
    this.canTurnOffHvac,
    this.canHvacHeatCool,
  });

  factory ThermostatDevice.fromJson(Map<String, dynamic> json) {
    return ThermostatDevice(
      deviceId: json['device_id'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      deviceType: json['device_type'] as String? ?? '',
      capabilitiesSupported: (json['capabilities_supported'] as List<dynamic>?)
              ?.map((e) => e as String? ?? '')
              .toList() ??
          [],
      properties: DeviceProperties.fromJson(
          json['properties'] as Map<String, dynamic>? ?? {}),
      location: DeviceLocation.fromJson(
          json['location'] as Map<String, dynamic>? ?? {}),
      connectedAccountId: json['connected_account_id'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => DeviceError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      warnings: json['warnings'] as List<dynamic>? ?? [],
      isManaged: json['is_managed'] as bool? ?? false,
      customMetadata: json['custom_metadata'] as Map<String, dynamic>? ?? {},
      canHvacCool: json['can_hvac_cool'] as bool? ?? false,
      canHvacHeat: json['can_hvac_heat'] as bool? ?? false,
      canTurnOffHvac: json['can_turn_off_hvac'] as bool? ?? false,
      canHvacHeatCool: json['can_hvac_heat_cool'] as bool? ?? false,
    );
  }

  final String? deviceId;
  final String? nickname;
  final String? displayName;
  final String? deviceType;
  final List<String>? capabilitiesSupported;
  final DeviceProperties? properties;
  final DeviceLocation? location;
  final String? connectedAccountId;
  final String? workspaceId;
  final DateTime? createdAt;
  final List<DeviceError>? errors;
  final List<dynamic>? warnings;
  final bool? isManaged;
  final Map<String, dynamic>? customMetadata;
  final bool? canHvacCool;
  final bool? canHvacHeat;
  final bool? canTurnOffHvac;
  final bool? canHvacHeatCool;

  bool? get isOnline => properties?.online;
  bool? get isActive => (properties?.online ?? false) && (errors?.isEmpty ?? false);
}

class DeviceProperties {
  DeviceProperties({
    this.online,
    this.manufacturer,
    this.hasDirectPower,
    this.honeywellMetadata,
    this.name,
    this.appearance,
    this.model,
    this.imageUrl,
    this.imageAltText,
    this.availableFanModeSettings,
    this.availableClimatePresets,
    this.fallbackClimatePresetKey,
  });

  factory DeviceProperties.fromJson(Map<String, dynamic> json) {
    return DeviceProperties(
      online: json['online'] as bool? ?? false,
      manufacturer: json['manufacturer'] as String? ?? '',
      hasDirectPower: json['has_direct_power'] as bool? ?? false,
      honeywellMetadata: json['honeywell_resideo_metadata'] != null
          ? HoneywellMetadata.fromJson(
              json['honeywell_resideo_metadata'] as Map<String, dynamic>)
          : null,
      name: json['name'] as String? ?? '',
      appearance: DeviceAppearance.fromJson(
          json['appearance'] as Map<String, dynamic>? ?? {}),
      model: DeviceModel.fromJson(json['model'] as Map<String, dynamic>? ?? {}),
      imageUrl: json['image_url'] as String? ?? '',
      imageAltText: json['image_alt_text'] as String? ?? '',
      availableFanModeSettings:
          json['available_fan_mode_settings'] as List<dynamic>? ?? [],
      availableClimatePresets:
          json['available_climate_presets'] as List<dynamic>? ?? [],
      fallbackClimatePresetKey: json['fallback_climate_preset_key'],
    );
  }

  final bool? online;
  final String? manufacturer;
  final bool? hasDirectPower;
  final HoneywellMetadata? honeywellMetadata;
  final String? name;
  final DeviceAppearance? appearance;
  final DeviceModel? model;
  final String? imageUrl;
  final String? imageAltText;
  final List<dynamic>? availableFanModeSettings;
  final List<dynamic>? availableClimatePresets;
  final dynamic fallbackClimatePresetKey;
}

class HoneywellMetadata {
  HoneywellMetadata({
    this.deviceName,
    this.honeywellDeviceId,
  });

  factory HoneywellMetadata.fromJson(Map<String, dynamic> json) {
    return HoneywellMetadata(
      deviceName: json['device_name'] as String? ?? '',
      honeywellDeviceId: json['honeywell_resideo_device_id'] as String? ?? '',
    );
  }

  final String? deviceName;
  final String? honeywellDeviceId;
}

class DeviceAppearance {
  DeviceAppearance({
    this.name,
  });

  factory DeviceAppearance.fromJson(Map<String, dynamic> json) {
    return DeviceAppearance(
      name: json['name'] as String? ?? '',
    );
  }

  final String? name;
}

class DeviceModel {
  DeviceModel({
    this.displayName,
    this.manufacturerDisplayName,
    this.accessoryKeypadSupported,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      displayName: json['display_name'] as String? ?? '',
      manufacturerDisplayName:
          json['manufacturer_display_name'] as String? ?? '',
      accessoryKeypadSupported:
          json['accessory_keypad_supported'] as bool? ?? false,
    );
  }

  final String? displayName;
  final String? manufacturerDisplayName;
  final bool? accessoryKeypadSupported;
}

class DeviceLocation {
  DeviceLocation({
    this.timezone,
    this.locationName,
  });

  factory DeviceLocation.fromJson(Map<String, dynamic> json) {
    return DeviceLocation(
      timezone: json['timezone'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
    );
  }

  final String? timezone;
  final String? locationName;
}

class DeviceError {
  DeviceError({
    this.message,
    this.createdAt,
    this.errorCode,
    this.isDeviceError,
  });

  factory DeviceError.fromJson(Map<String, dynamic> json) {
    return DeviceError(
      message: json['message'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      errorCode: json['error_code'] as String? ?? '',
      isDeviceError: json['is_device_error'] as bool? ?? false,
    );
  }

  final String? message;
  final DateTime? createdAt;
  final String? errorCode;
  final bool? isDeviceError;
}
