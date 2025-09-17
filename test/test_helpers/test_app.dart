import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_bp/app_config.dart';
import 'package:flutter_bloc_bp/bloc/app_bloc/app_bloc.dart';
import 'package:flutter_bloc_bp/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc_bp/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested/nested.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TestApp extends StatefulWidget {
  const TestApp({
    super.key,
    required this.testWidget,
  });
  final Widget testWidget;

  @override
  TestAppState createState() => TestAppState();
}

class TestAppState extends State<TestApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    TestWidgetsFlutterBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AppBloc>(create: (BuildContext context) => AppBloc()),
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 835),
        builder: (_, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme: themeData,
            home: widget.testWidget,
            debugShowCheckedModeBanner: AppConfig.shared.flavor == Flavor.staging,
          );
        },
      ),
    );
  }
}
