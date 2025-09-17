import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app_routes.dart';
import '../../../../core/common/common_bg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../models/device.dart';
import '../../../global_widgets/widget_helper.dart';
import '../bloc/device_bloc.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});
  static const String routePath = '/devices';

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    context.read<DeviceBloc>().add(FetchAllDevicesEvent());
  }

  void _onDeviceTap(Device device, int index) {
    context.go(AppRoutes.deviceChannels, extra: {
      'id': device.id,
    });
  }

  Widget _buildDeviceCard(Device device, int index) {
    return GestureDetector(
      onTap: () => _onDeviceTap(device, index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  AppAssets.device_bg,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Device ${device.id}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      device.serialNumber,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Serial Number',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    getSpace(20.h, 0),
                    Text(
                      device.channelCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Total sensors',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    getSpace(20.h, 0),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x268AE012),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8AE012),
                              shape: BoxShape.circle,
                            ),
                          ),
                          getSpace(0, 6.w),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: const Color(0xFF8AE012),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselWithIndicators(List<Device> devices) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: devices.length,
          itemBuilder: (context, index, realIndex) {
            return _buildDeviceCard(devices[index], index);
          },
          options: CarouselOptions(
            height: 550.h,
            viewportFraction: 0.85,
            enableInfiniteScroll: false,
            enlargeFactor: 0.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        getSpace(30.h, 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: devices.asMap().entries.map((entry) {
            return Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: _currentIndex == entry.key
                    ? Colors.black
                    : const Color.fromRGBO(189, 228, 215, 1),
                borderRadius: BorderRadius.circular(4.r),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          getSpace(16.h, 0),
          Text(
            'Loading devices...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          ),
          getSpace(16.h, 0),
          Text(
            'Failed to load devices',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          getSpace(8.h, 0),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          getSpace(24.h, 0),
          ElevatedButton(
            onPressed: () {
              context.read<DeviceBloc>().add(FetchAllDevicesEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.device_empty,
            fit: BoxFit.cover,
          ),
          getSpace(24.h, 0),
          Text(
            'No devices found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          getSpace(8.h, 0),
          Text(
            'Add your first device to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundPage(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            getSpace(0, 8.w),
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
            getSpace(0, 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Devices',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "You're making an impact",
                  style: TextStyle(
                    color: const Color.fromRGBO(91, 91, 91, 1),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ],
        ),
        toolbarHeight: 80.h,
      ),
      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          return Column(
            children: [
              getSpace(40.h, 0),
              Expanded(
                child: _buildBody(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(DeviceState state) {
    if (state is FetchAllDevicesLoading) {
      return _buildLoadingState();
    } else if (state is DevicesError) {
      return _buildErrorState();
    } else if (state is DeviceStateData && state.devices != null) {
      final devices = state.devices!;
      if (devices.isEmpty) {
        return _buildEmptyState();
      }
      return _buildCarouselWithIndicators(devices);
    } else if (state is FetchAllDevicesSuccess) {
      final deviceBloc = context.read<DeviceBloc>();
      if (deviceBloc.deviceStateData.devices != null) {
        final devices = deviceBloc.deviceStateData.devices!;
        if (devices.isEmpty) {
          return _buildEmptyState();
        }
        return _buildCarouselWithIndicators(devices);
      }
      return _buildEmptyState();
    }

    return _buildEmptyState();
  }
}
