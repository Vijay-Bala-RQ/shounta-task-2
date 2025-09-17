import 'dart:async';
import 'package:rq_network_flutter/helpers/typedefs.dart';
import 'package:rq_network_flutter/networking/response_model.dart';
import '../core/api_repository/api_repository.dart';

class ThermostatService extends ApiRepository {
  Future<Map<String, dynamic>?> fetchThermostats() async {
    final JSON res = await ApiRepository.apiService.get(
      endpoint: '/thermostats/list',
      requiresAuthToken: true,
      converter: (JSON? response) {
        return response;
      },
    );
    return res;
  }

  Future<Map<String, dynamic>?> fetchOneThermostat(
      Map<String, dynamic>? queryParams) async {
    final JSON res = await ApiRepository.apiService.get(
      endpoint: '/thermostats/get',
      queryParams: queryParams,
      requiresAuthToken: true,
      converter: (JSON? response) {
        return response;
      },
    );
    return res;
  }

  Future<Map<String, dynamic>?> createClimatePreset(
      Map<String, dynamic>? body) async {
    final ResponseModel<JSON?> res = await ApiRepository.apiService.post(
      endpoint: '/thermostats/create_climate_preset',
      requiresAuthToken: true,
      data: body,
      converter: (ResponseModel<JSON?> response) {
        return response;
      },
    );
    return res.body;
  }
}
