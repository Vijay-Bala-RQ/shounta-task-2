import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_provider/go_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

import 'app_routes.dart';
import 'bloc/app_bloc/app_bloc.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'views/auth/init_page.dart';
import 'views/auth/login_page.dart';
import 'views/home/bloc/home_bloc.dart';
import 'views/home/devices/bloc/device_bloc.dart';
import 'views/home/devices/ui/channels.dart';
import 'views/home/devices/ui/devices.dart';
import 'views/home/home_page.dart';
import 'views/home/thermostat/bloc/thermostat_bloc.dart';
import 'views/home/thermostat/ui/climate_preset.dart';
import 'views/home/thermostat/ui/device_details.dart';

class GoRouterInit {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String initialLocation = InitPage.routePath;
  static final RouteObserver<ModalRoute<dynamic>> routeObserver =
      RouteObserver<ModalRoute<dynamic>>();
  static Object? initialExtra;

  static GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    observers: <NavigatorObserver>[
      GoRouterInit.routeObserver,
    ],
    initialLocation: initialLocation,
    initialExtra: initialExtra,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoProviderRoute(
        path: AppRoutes.initPage,
        providers: <SingleChildWidget>[
          BlocProvider<AppBloc>(create: (_) => AppBloc()),
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        ],
        builder: (BuildContext context, GoRouterState state) {
          return const InitPage();
        },
        routes: <RouteBase>[
          GoProviderRoute(
            path: AppRoutes.loginPage,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginPage();
            },
            providers: [
              BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
              BlocProvider<AppBloc>(create: (_) => AppBloc()),
            ],
          ),
          GoProviderRoute(
            path: AppRoutes.homePage,
            providers: <SingleChildWidget>[
              BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
              BlocProvider<AppBloc>(create: (_) => AppBloc()),
              BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
              BlocProvider(create: (_) => ThermostatBloc()),
              BlocProvider(create: (_) => DeviceBloc())
            ],
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
            routes: [
              GoRoute(
                  path: 'devices',
                  builder: (BuildContext context, GoRouterState state) =>
                      const DeviceListPage(),
                  routes: [
                    GoRoute(
                        path: 'channels',
                        builder: (BuildContext context, GoRouterState state) {
                          final int? deviceId = state.extra != null &&
                                  (state.extra! as Map<String, dynamic>)
                                      .containsKey('id')
                              ? (state.extra! as Map<String, dynamic>)['id']
                                  as int
                              : null;
                          return DeviceChannelsPage(
                            deviceId: deviceId,
                          );
                        }),
                  ]),
              GoRoute(
                  path: 'details',
                  builder: (BuildContext context, GoRouterState state) {
                    final String? deviceId = state.extra != null &&
                            (state.extra! as Map<String, dynamic>)
                                .containsKey('id')
                        ? (state.extra! as Map<String, dynamic>)['id'] as String
                        : null;
                    return DeviceDetailsPage(deviceId: deviceId);
                  },
                  routes: [
                    GoRoute(
                        path: 'climate',
                        builder: (BuildContext context, GoRouterState state) {
                          final String? deviceId = state.extra != null &&
                                  (state.extra! as Map<String, dynamic>)
                                      .containsKey('device_id')
                              ? (state.extra!
                                      as Map<String, dynamic>)['device_id']
                                  as String
                              : null;
                          return ClimatePresetPage(deviceId: deviceId);
                        }),
                  ]),
            ],
          ),
        ],
      ),
    ],
  );
}
