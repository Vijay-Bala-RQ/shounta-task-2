import 'package:flutter_config/flutter_config.dart';

void loadTestEnvVariables(){
  FlutterConfig.loadValueForTesting(<String, String>{
    'ENVIRONMENT': 'staging',
    'APP_LABEL': 'BP testing',
    'SCHEME': 'http',
    'SCOPE': 'api/v1',
    'HOST': 'api.example.test'
  });
}
