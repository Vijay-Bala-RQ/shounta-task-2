import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/common_bg.dart';
import '../../../../core/common/common_helpers.dart';
import '../../../../models/models.dart';
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

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Device> get _mockDevices => List.generate(
      3,
      (int i) => const Device(
            order: 1,
            id: 1,
            modelNumber: 1,
            serialNumber: 'Loading...',
            channelCount: 0,
          ));

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
                child: _buildBody(state, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(DeviceState state, BuildContext context) {
    final isLoading = state is FetchAllDevicesLoading;

    if (state is DevicesError) {
      return CommonHelpers().buildErrorState(context);
    } else if (state is FetchAllDevicesSuccess) {
      final deviceBloc = context.read<DeviceBloc>();
      if (deviceBloc.deviceStateData.devices != null) {
        final devices = deviceBloc.deviceStateData.devices!;
        if (devices.isEmpty) {
          return CommonHelpers().buildEmptyState();
        }
        return Skeletonizer(
          enabled: false,
          child: CommonHelpers().buildCarouselWithIndicators(
            devices: devices,
            context: context,
            currentIndex: _currentIndex,
            onPageChanged: _onPageChanged,
            controller: _controller,
          ),
        );
      }
    }

    return Skeletonizer(
      enabled: isLoading,
      child: CommonHelpers().buildCarouselWithIndicators(
        devices: _mockDevices,
        context: context,
        currentIndex: 0,
        onPageChanged: (_) {},
        controller: _controller,
      ),
    );
  }
}
