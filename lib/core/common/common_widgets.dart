import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../views/global_widgets/widget_helper.dart';
import '../constants/app_assets.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    required this.onTabChanged,
    this.initialIndex = 0,
  });
  final Function(int) onTabChanged;
  final int initialIndex;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;

  final List<TabItem> _tabs = [
    TabItem(
      title: 'Home',
      icon: AppAssets.home,
      selectedIcon: AppAssets.selected_home,
    ),
    TabItem(
      title: 'Thermostat',
      icon: AppAssets.thermostat,
      selectedIcon: AppAssets.selected_thermostat,
    ),
    TabItem(
      title: 'Others',
      icon: AppAssets.others,
      selectedIcon: AppAssets.selected_others,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      width: 250.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tabs.asMap().entries.map((entry) {
          final int index = entry.key;
          final TabItem tab = entry.value;
          final bool isSelected = _selectedIndex == index;

          return Flexible(
            flex: isSelected ? 3 : 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTabChanged(index);
              },
              child: Container(
                height: 54.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26.r),
                  image: isSelected
                      ? const DecorationImage(
                          image: AssetImage(AppAssets.selected_bg),
                          fit: BoxFit.fitHeight,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      isSelected ? tab.selectedIcon : tab.icon,
                    ),
                    if (isSelected) ...[
                      getSpace(0, 4.w),
                      Flexible(
                        child: Text(
                          tab.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TabItem {
  TabItem({
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });
  final String title;
  final String icon;
  final String selectedIcon;
}
