enum Flavor { production, staging, dev, qa, uat }

final Map<String, Flavor> flavorMap = <String, Flavor>{
  'production': Flavor.production,
  'staging': Flavor.staging,
  'dev': Flavor.dev,
  'qa': Flavor.qa,
  'uat': Flavor.uat,
};

class AppConfig {
  AppConfig({
    required this.flavor,
    required this.appLabel,
    required this.scheme,
    required this.scope,
    required this.host,
    required this.baseUrl,
  });
  factory AppConfig.initiate() {
    const String environment = String.fromEnvironment('ENVIRONMENT');
    const String appLabel = String.fromEnvironment('APP_LABEL');
    const String scheme = String.fromEnvironment('SCHEME');
    const String scope = String.fromEnvironment('SCOPE');
    const String host = String.fromEnvironment('HOST');

    final Flavor flavor = flavorMap[environment] ?? Flavor.production;

    return shared = AppConfig(
      flavor: flavor,
      appLabel: appLabel,
      scheme: scheme,
      scope: scope,
      host: host,
      baseUrl: '$scheme://${scope != '' ? '$scope/' : ''}$host',
    );
  }
  Flavor flavor;
  String appLabel;
  String scheme;
  String scope;
  String host;
  String baseUrl;

  static AppConfig shared = AppConfig.initiate();
}
