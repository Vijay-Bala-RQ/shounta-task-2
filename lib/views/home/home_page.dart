import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app_routes.dart';
import '../../bloc/app_bloc/app_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../core/common/common_bg.dart';
import '../../core/common/common_widgets.dart';
import '../global_widgets/common_button.dart';
import 'bloc/home_bloc.dart';
import 'thermostat/ui/thermostat_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routePath = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppBloc appBloc;
  late final AuthBloc authBloc;
  late final HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    homeBloc = BlocProvider.of<HomeBloc>(context);

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      authBloc.stream.listen((AuthState state) => (mounted
          ? onAuthBlocChange(context: context, state: state, appBloc: appBloc)
          : null));
    });
  }

  Widget _buildHomeTab() {
    return Center(
      child: CommonButton(
        onPressed: () {
          context.go(AppRoutes.devicesPage);
        },
        text: 'Devices',
        loadingText: 'navigating',
      ),
    );
  }

  Widget _buildThermostatTab() {
    return const ThermostatTabPage();
  }

  Widget _buildOthersTab() {
    return const Center(
      child: Text('Others Tab'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState authState) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState homeState) {
            final homeBloc = BlocProvider.of<HomeBloc>(context);

            return CommonBackgroundPage(
                body: Expanded(
                  child: IndexedStack(
                    index: homeState.activeViewIndex,
                    children: [
                      _buildHomeTab(),
                      _buildThermostatTab(),
                      _buildOthersTab(),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: CustomTabBar(
                  initialIndex: homeState.activeViewIndex,
                  onTabChanged: (int index) {
                    homeBloc.add(TabItemTap(activeIndex: index));
                  },
                ));
          },
        );
      },
    );
  }
}
