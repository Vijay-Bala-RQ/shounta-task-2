import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app_routes.dart';
import '../../bloc/app_bloc/app_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../core/utils/utils.dart';
import '../loader/app_loader.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  static const String routePath = '/';

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late final AuthBloc authBloc;
  late final AppBloc appBloc;

  @override
  void initState() {
    super.initState();

    authBloc = BlocProvider.of<AuthBloc>(context);
    appBloc = BlocProvider.of<AppBloc>(context);
    authBloc.add(CheckForPreference());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) {
      return BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (AuthState previous, AuthState current) =>
              current is CheckForPreferenceSuccess,
          builder: (BuildContext context, AuthState state) {
            switch (state.runtimeType) {
              case const (AuthLoading):
                return const AppLoader();
              case const (CheckForPreferenceSuccess):
                final CheckForPreferenceSuccess currentState =
                    state as CheckForPreferenceSuccess;
                appBloc.add(SaveCurrentUser(user: currentState.user));
                if (Utils.nullOrEmpty(currentState.user?.firstname)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go(AppRoutes.loginPage);
                  });
                  return const AppLoader();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go(AppRoutes.homePage);
                  });
                  return const AppLoader();
                }
              default:
                return const AppLoader();
            }
          });
    });
  }
}
