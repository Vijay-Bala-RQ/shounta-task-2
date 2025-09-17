import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app_routes.dart';
import '../../../../models/models.dart';
import '../../../global_widgets/toast_helper.dart';
import '../../../global_widgets/widget_helper.dart';
import '../../common_components.dart';
import '../bloc/thermostat_bloc.dart';

class ThermostatTabPage extends StatefulWidget {
  const ThermostatTabPage({super.key});

  @override
  State<ThermostatTabPage> createState() => _ThermostatTabPageState();
}

class _ThermostatTabPageState extends State<ThermostatTabPage> {
  List<ThermostatDevice> devices = <ThermostatDevice>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThermostatBloc>().stream.listen((state) {
        if (state is ThermostatError) {
          if (mounted) {
            ToastHelper.showToast(
                context: context,
                message: 'Error loading thermostat devices. Please try again.',
                isSuccess: false);
          }
        }
      });

      context.read<ThermostatBloc>().add(FetchAllThermostats());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            'Devices',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ThermostatBloc, ThermostatState>(
            builder: (context, state) {
              final ThermostatBloc bloc = context.read<ThermostatBloc>();
              final List<ThermostatDevice> devices =
                  bloc.thermostatStateData.thermostats ?? [];
              if (state is ThermostatInitial ||
                  state is FetchAllThermostatsLoading) {
                return Skeletonizer(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.3,
                      ),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return ThermostatCard(
                          device: ThermostatDevice(),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                );
              }

              if (devices.isEmpty && state is! FetchAllThermostatsLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.thermostat_outlined,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      getSpace(16.h, 0),
                      Text(
                        'No thermostat devices found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.3,
                  ),
                  itemCount: devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ThermostatDevice device = devices[index];
                    return ThermostatCard(
                      device: device,
                      onTap: () {
                        _onDeviceTap(device);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        getSpace(100.h, 0),
      ],
    );
  }

  void _onDeviceTap(ThermostatDevice device) {
    context.go(AppRoutes.deviceDetailsPage, extra: {'id': device.deviceId});
  }
}
