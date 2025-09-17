import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_assets.dart';
import '../../models/models.dart';
import '../global_widgets/widget_helper.dart';

class ThermostatCard extends StatelessWidget {
  const ThermostatCard({
    super.key,
    required this.device,
    this.onTap,
  });
  final ThermostatDevice device;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: AssetImage(
              (device.isActive ?? false)
                  ? AppAssets.card_active
                  : AppAssets.card,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSpace(8.h, 0),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 244, 244, 244),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                AppAssets.thermostat,
                width: 26.w,
                height: 26.h,
              ),
            ),
            getSpace(24.h, 0),
            Text(
              device.displayName ?? 'Unknown Device',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            getSpace(2.h, 0),
            Text(
              device.properties?.model?.manufacturerDisplayName ?? 'Unknown',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            getSpace(8.h, 0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(234, 249, 220, 1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                device.location?.locationName ?? 'Unknown Location',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
