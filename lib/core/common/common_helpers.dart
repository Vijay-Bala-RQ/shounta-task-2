import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../app_routes.dart';
import '../../models/device.dart';
import '../../views/global_widgets/widget_helper.dart';
import '../../views/home/devices/bloc/device_bloc.dart';
import '../constants/app_assets.dart';

class CommonHelpers {
  Widget buildDeviceCard(Device device, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(AppRoutes.deviceChannels, extra: {
          'id': device.id,
        });
      },
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

  Widget buildCarouselWithIndicators({
    required List<Device> devices,
    required BuildContext context,
    required int currentIndex,
    required Function(int) onPageChanged,
    CarouselSliderController? controller,
  }) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          itemCount: devices.length,
          itemBuilder: (context, index, realIndex) {
            return buildDeviceCard(devices[index], index, context);
          },
          options: CarouselOptions(
            height: 550.h,
            viewportFraction: 0.85,
            enableInfiniteScroll: false,
            enlargeFactor: 0.0,
            onPageChanged: (index, reason) {
              onPageChanged(index);
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
                color: currentIndex == entry.key
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

  Widget buildLoadingState() {
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

  Widget buildErrorState(BuildContext context) {
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

  Widget buildEmptyState() {
    return Center(
      child: Image.asset(
        AppAssets.device_empty,
        fit: BoxFit.cover,
      ),
    );
  }
}
