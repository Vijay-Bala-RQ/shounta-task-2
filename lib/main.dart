import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nested/nested.dart';
import 'app_config.dart';
import 'bloc/app_bloc/app_bloc.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'core/api_repository/api_repository.dart';
import 'core/base_bloc/base_bloc.dart';
import 'go_router_init.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// flavor & env setup
  await FlutterConfig.loadEnvVariables();
  AppConfig.initiate();
  
  await ApiRepository.init();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  await ScreenUtil.ensureScreenSize();

  Bloc.observer = AppBlocObserver();

  runApp(MultiBlocProvider(providers: <SingleChildWidget>[
    BlocProvider<AppBloc>(create: (BuildContext context) => AppBloc()),
    BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
  ], child: const App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 835),
        builder: (_, Widget? child) {
          return MaterialApp.router(
            routerConfig: GoRouterInit.router,
            theme: themeData,
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
