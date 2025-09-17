import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app_routes.dart';
import '../../../../core/common/common_bg.dart';
import '../../../../models/thermostat_device.dart';
import '../../../global_widgets/widget_helper.dart';
import '../bloc/thermostat_bloc.dart';

class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({super.key, this.deviceId});
  final String? deviceId;

  static const String routePath = '/details';

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThermostatBloc>().stream.listen((ThermostatState state) {
        if (state is ThermostatError) {
          _showErrorMessage();
        }
      });

      if (widget.deviceId != null) {
        context.read<ThermostatBloc>().add(
              FetchOneThermostat(deviceId: widget.deviceId),
            );
      }
    });
  }

  void _showErrorMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading thermostat details. Please try again.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundPage(
      body: BlocBuilder<ThermostatBloc, ThermostatState>(
        builder: (BuildContext context, ThermostatState state) {
          if (state is FetchOneThermostatLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          ThermostatDevice? device;
          if (state is FetchOneThermostatSuccess) {
            device = state.thermostat;
          }

          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    getSpace(0, 12.w),
                    Text(
                      device?.displayName ?? 'Device Details',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showMoreOptionsModal(context, device),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          size: 24.sp,
                          color: const Color.fromRGBO(141, 143, 138, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: <Widget>[
                              _buildDetailRow(
                                'Type',
                                device?.properties?.model
                                        ?.manufacturerDisplayName ??
                                    'Unknown',
                                isFirst: true,
                              ),
                              _buildDetailRow(
                                'Status',
                                _getDeviceStatus(device),
                                valueColor: _getStatusColor(device),
                                valueTextColor: _getStatusColor(device),
                                hasStatusIcon: true,
                              ),
                              _buildDetailRow(
                                'Battery',
                                (device?.properties?.hasDirectPower ?? false)
                                    ? 'Powered'
                                    : 'Battery',
                                hasStatusIcon: true,
                                statusIconData: Icons.power,
                                valueColor:
                                    (device?.properties?.hasDirectPower ??
                                            false)
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFFF9800),
                                valueTextColor: Colors.black,
                              ),
                              _buildDetailRow(
                                'Climate Setting',
                                _getClimateCapabilities(device),
                              ),
                              _buildDetailRow(
                                'Temperature Thresholds',
                                (device?.properties?.availableClimatePresets
                                            ?.isNotEmpty ??
                                        false)
                                    ? '${device!.properties!.availableClimatePresets!.length} presets'
                                    : 'None',
                              ),
                              _buildDetailRow(
                                'Fan Setting',
                                (device?.properties?.availableFanModeSettings
                                            ?.isNotEmpty ??
                                        false)
                                    ? '${device!.properties!.availableFanModeSettings!.length} modes'
                                    : 'Unknown',
                              ),
                              _buildDetailRow(
                                  'Others',
                                  (device?.errors?.isNotEmpty ?? false)
                                      ? '${device!.errors!.length} issues'
                                      : 'Unknown',
                                  isLast: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getDeviceStatus(ThermostatDevice? device) {
    if (device?.properties?.online ?? false) {
      if (device?.errors?.isNotEmpty ?? false) {
        return 'Error';
      }
      return 'Active';
    }
    return 'Offline';
  }

  Color _getStatusColor(ThermostatDevice? device) {
    if (device?.properties?.online ?? false) {
      if (device?.errors?.isNotEmpty ?? false) {
        return const Color(0xFFFF5722);
      }
      return const Color(0xFF4CAF50);
    }
    return const Color(0xFF757575);
  }

  String _getClimateCapabilities(ThermostatDevice? device) {
    if (device == null) {
      return 'Unknown';
    }

    final List<String> capabilities = <String>[];
    if (device.canHvacHeat ?? false) {
      capabilities.add('Heat');
    }
    if (device.canHvacCool ?? false) {
      capabilities.add('Cool');
    }
    if (device.canHvacHeatCool ?? false) {
      capabilities.add('Heat/Cool');
    }
    if (device.canTurnOffHvac ?? false) {
      capabilities.add('Off');
    }

    return capabilities.isNotEmpty ? capabilities.join(', ') : 'Unknown';
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool hasStatusIcon = false,
    IconData? statusIconData,
    bool isFirst = false,
    bool isLast = false,
    Color? valueTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.h,
                ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color.fromRGBO(145, 158, 128, 1),
                fontWeight: FontWeight.w300,
              ),
            ),
            getSpace(8.h, 0),
            Row(
              children: <Widget>[
                if (hasStatusIcon) ...<Widget>[
                  Icon(
                    statusIconData ?? Icons.circle,
                    size: statusIconData != null ? 16.sp : 8.sp,
                    color: valueColor ?? const Color(0xFF4CAF50),
                  ),
                  getSpace(0, 8.w),
                ],
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: valueTextColor ?? Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptionsModal(BuildContext context, ThermostatDevice? device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              getSpace(20.h, 0),
              _buildModalOption(
                'Create Schedule',
                () {
                  context.pop();
                  _navigateToPage('Create Schedule');
                },
              ),
              _buildModalOption(
                'Actions',
                () {
                  context.pop();
                  _navigateToPage('Actions');
                },
              ),
              _buildModalOption(
                'Create Climate Preset',
                () {
                  context.go(AppRoutes.climatePresetPage, extra: {
                    'device_id': device?.deviceId,
                  });
                },
              ),
              getSpace(20.h, 0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalOption(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to $pageName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
