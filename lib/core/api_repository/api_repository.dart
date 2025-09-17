import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:rq_network_flutter/api_manager.dart';
import 'package:rq_network_flutter/helpers/preferences.dart';
import 'package:rq_network_flutter/local/path_provider_service.dart';
import 'package:rq_network_flutter/networking/api_endpoint.dart';
import 'package:rq_network_flutter/networking/api_service.dart';

import '../../app_config.dart';


class ApiRepository {
  static String baseUrlConfig = AppConfig.shared.baseUrl;
  static late ApiManager apiManager;
  static late ApiService apiService;

  static Future<void> init({
    Dio? dioArg,
    String? baseUrl,
    PathProviderService? pathProviderServiceArg,
    HiveCacheStore? hiveCacheStore,
  }) async {
    ApiEndpoint.baseUrl = baseUrl ?? baseUrlConfig;
    ApiEndpoint.baseMockUrl =
        'https://bcce9666-ddf5-428e-9199-e7bb91eb15ae.mock.pstmn.io/api/v1';
    ApiEndpoint.refreshTokenUrl = '/auth/login';
    ApiEndpoint.refreshTokenReqBody = () async {
      final Map<String, dynamic>? token = await Preference.getUserAccessToken();

      return <String, dynamic>{
        'grant_type': 'refresh_token',
        'refresh_token': token?[ApiEndpoint.refreshTokenKey],
      };
    };
    ApiEndpoint.getTokenDataFromRefreshResponse =
        (Map<String, dynamic>? tokenData) {
      return (tokenData?['data']
              as Map<String, dynamic>?)?[ApiEndpoint.tokenKey]
          as Map<String, dynamic>?;
    };
    ApiEndpoint.enableRefreshToken = true;
    ApiEndpoint.accessTokenKey = 'accessToken';
    ApiEndpoint.refreshTokenKey = 'refreshToken';
    if (pathProviderServiceArg == null) {
      pathProviderServiceArg = PathProviderService();
      await pathProviderServiceArg.init();
    }

    apiManager = ApiManager(
      dioArg: dioArg ??
          Dio(
            BaseOptions(
              baseUrl: ApiEndpoint.baseUrl,
              connectTimeout: const Duration(seconds: 120),
              receiveTimeout: const Duration(seconds: 120),
              headers: <String, Object?>{'User-Agent': 'Mobile'},
            ),
          )
        ..interceptors.addAll(<Interceptor>[
        ]),
      diowithoutBaseUrl: Dio(
        BaseOptions(
          headers: <String, Object?>{'User-Agent': 'Mobile'},
          // baseUrl: ApiEndpoint.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
      pathProviderServiceArg: pathProviderServiceArg,
      hiveCacheStore:
          hiveCacheStore ?? HiveCacheStore(pathProviderServiceArg.path),
    );
    apiService = apiManager.apiService;
  }
}
