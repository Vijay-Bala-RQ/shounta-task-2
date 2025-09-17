import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';

import 'login_mock_api_response.dart';

class LoginMockApi {
  static void initializeMockServer({required DioAdapter dioAdapter}) {
    dioAdapter.onPost(
      '/user_management/employee/login',
      data: <String, dynamic>{
        'employee': <String, Object>{
          'email': 'TCRO1',
          'password': 'Password@123',
          'build_number': 100,
          'is_mobile': true,
          'grant_type': 'password'
        }
      },
      (MockServer server) {
        return server.reply(
          201,
          LoginMockApiResponse.loginSuccessResponse,
          statusMessage: 'Created',
          delay: const Duration(
            milliseconds: 1000,
          ),
        );
      },
    );

    dioAdapter.onPost(
      '/user_management/employee/login',
      data: <String, dynamic>{
        'employee': <String, Object>{
          'email': 'TCR',
          'password': 'Password@456',
          'build_number': 100,
          'is_mobile': true,
          'grant_type': 'password'
        }
      },
      (MockServer server) {
        return server.reply(
          422,
          LoginMockApiResponse.unauthorizedLoginResponse,
          statusMessage: 'Unprocessable Entity',
          delay: const Duration(
            milliseconds: 1000,
          ),
        );
      },
    );
  }
}
