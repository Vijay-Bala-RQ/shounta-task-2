import 'dart:async';
import 'package:rq_network_flutter/helpers/typedefs.dart';
import 'package:rq_network_flutter/networking/response_model.dart';
import '../core/api_repository/api_repository.dart';

class DeviceService extends ApiRepository {
  Future<Map<String, dynamic>?> fetchDevices() async {
    final JSON res = await ApiRepository.apiService.get(
      endpoint: '/devices',
      requiresAuthToken: true,
      converter: (JSON? response) {
        return response;
      },
    );
    return res;
  }

  Future<Map<String, dynamic>?> fetchDeviceChannels(int? id) async {
    final JSON res = await ApiRepository.apiService.get(
      endpoint: '/devices/$id',
      requiresAuthToken: true,
      converter: (JSON? response) {
        return response;
      },
    );
    return res;
  }

  Future<Map<String, dynamic>?> fetchAllAppliances() async {
    final JSON res = await ApiRepository.apiService.get(
      endpoint: '/meta/appliances',
      requiresAuthToken: true,
      converter: (JSON? response) {
        return response;
      },
    );
    return res;
  }

  Future<Map<String, dynamic>?> updateDeviceChannels(
      int? id, Map<String, dynamic>? body) async {
    final ResponseModel<JSON?> res = await ApiRepository.apiService.put(
      endpoint: '/devices/$id',
      data: body,
      requiresAuthToken: true,
      converter: (ResponseModel<JSON?> response) {
        return response;
      },
    );
    return res.body;
  }
}
