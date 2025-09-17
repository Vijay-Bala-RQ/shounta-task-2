import 'views/auth/init_page.dart';
import 'views/auth/login_page.dart';
import 'views/home/devices/ui/channels.dart';
import 'views/home/devices/ui/devices.dart';
import 'views/home/home_page.dart';
import 'views/home/thermostat/ui/climate_preset.dart';
import 'views/home/thermostat/ui/device_details.dart';

class AppRoutes {
  static const String initPage = InitPage.routePath;
  static const String loginPage = LoginPage.routePath;
  static const String homePage = HomePage.routePath;
  static const String deviceDetailsPage =
      '${HomePage.routePath}${DeviceDetailsPage.routePath}';
  static const String climatePresetPage =
      '$deviceDetailsPage${ClimatePresetPage.routePath}';
  static const String devicesPage =
      '${HomePage.routePath}${DeviceListPage.routePath}';
  static const String deviceChannels = '$devicesPage${DeviceChannelsPage.routePath}';
}
