import 'dart:async';
import 'package:rq_network_flutter/helpers/typedefs.dart';
import 'package:rq_network_flutter/networking/response_model.dart';
import '../core/api_repository/api_repository.dart';
import '../models/app_user.dart';
import '../models/token.dart';

class AuthService extends ApiRepository {
  Future<Map<String, dynamic>?> loginWithPassword(
      {Map<String, dynamic>? objToApi}) async {
    final ResponseModel<JSON?> res = await ApiRepository.apiService.post(
      endpoint: '/login',
      data: objToApi,
      converter: (ResponseModel<JSON?> response) {
        return response;
      },
    );
    return <String, dynamic>{
      'customer': AppUser.fromJson((res.body ?? <String, dynamic>{})['employee'] as Map<String, dynamic>),
      'token': Token.fromJson(
          (res.body ?? <String, dynamic>{})['token'] as Map<String, dynamic>)
    };
  }

  Future<Map<String, dynamic>?> logOut(
      {Map<String, dynamic>? headersToApi}) async {
    final JSON? res = await ApiRepository.apiService.delete(
      requiresAuthToken: true,
      endpoint: '/logout',
      headers: headersToApi,
      converter: (ResponseModel<JSON?> response) {
        return response.body;
      },
    );
    return res;
  }
}
