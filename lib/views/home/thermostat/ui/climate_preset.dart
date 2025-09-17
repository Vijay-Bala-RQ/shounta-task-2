import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../core/common/common_bg.dart';
import '../../../../core/common/common_fields.dart';
import '../../../global_widgets/widget_helper.dart';
import '../bloc/thermostat_bloc.dart';

class ClimatePresetPage extends StatefulWidget {
  const ClimatePresetPage({super.key, this.deviceId});
  final String? deviceId;

  static const String routePath = '/climate';

  @override
  State<ClimatePresetPage> createState() => _ClimatePresetPageState();
}

class _ClimatePresetPageState extends State<ClimatePresetPage> {
  final TextEditingController _presetNameController = TextEditingController();
  final TextEditingController _presetKeyController = TextEditingController();

  String? _selectedHvacMode;
  String? _selectedFanMode;
  bool _manualOverrideAllowed = false;
  bool _isLoading = false;

  SfRangeValues _temperatureRange = const SfRangeValues(64.0, 74.0);

  final List<String> _hvacModes = ['Heat', 'Cool', 'Auto', 'Off', 'Heat/Cool'];
  final List<String> _fanModes = ['Auto', 'On', 'Circulate'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThermostatBloc>().stream.listen((state) {
        if (state is CreateClimatePresetLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is CreateClimatePresetSuccess) {
          setState(() {
            _isLoading = false;
          });
          _showSuccessMessage();
        } else if (state is ThermostatError) {
          setState(() {
            _isLoading = false;
          });
          _showErrorMessage();
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  void _showSuccessMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Climate preset created successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.pop();
    }
  }

  void _showErrorMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error creating climate preset. Please try again.',
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
  void dispose() {
    _presetNameController.dispose();
    _presetKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackgroundPage(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
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
                getSpace(0, 16.w),
                Text(
                  'Create\nClimate Preset',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  getSpace(20.h, 0),
                  CommonTextField(
                    controller: _presetNameController,
                    labelText: 'Preset Name',
                    isRequired: true,
                    isDisbaled: _isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Preset Name is required';
                      }
                      return null;
                    },
                  ),
                  getSpace(16.h, 0),
                  CommonTextField(
                    controller: _presetKeyController,
                    labelText: 'Preset Key',
                    isRequired: true,
                    isDisbaled: _isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Preset Key is required';
                      }
                      return null;
                    },
                  ),
                  getSpace(16.h, 0),
                  CommonDropdownField<String>(
                    labelText: 'HVAC Mode',
                    items: _hvacModes,
                    selectedValue: _selectedHvacMode,
                    isRequired: true,
                    isDisbaled: _isLoading,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedHvacMode = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'HVAC Mode is required';
                      }
                      return null;
                    },
                  ),
                  getSpace(24.h, 0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desired temperature range',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF919E80),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      getSpace(16.h, 0),
                      CommonSlider(
                        values: _temperatureRange,
                        onChanged: (SfRangeValues values) {
                          setState(() {
                            _temperatureRange = values;
                          });
                        },
                      ),
                    ],
                  ),
                  getSpace(24.h, 0),
                  CommonDropdownField<String>(
                    labelText: 'Fan Mode',
                    items: _fanModes,
                    selectedValue: _selectedFanMode,
                    isRequired: true,
                    isDisbaled: _isLoading,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedFanMode = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Fan Mode is required';
                      }
                      return null;
                    },
                  ),
                  getSpace(24.h, 0),
                  Row(
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Checkbox(
                          value: _manualOverrideAllowed,
                          onChanged: _isLoading
                              ? null
                              : (bool? value) {
                                  setState(() {
                                    _manualOverrideAllowed = value ?? false;
                                  });
                                },
                          activeColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      getSpace(0, 12.w),
                      Text(
                        'Manual Override Allowed',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: _isLoading ? Colors.grey : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  getSpace(20.h, 0),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : () => context.pop(),
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: _isLoading
                            ? Colors.grey.withOpacity(0.5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(width: 0.5.w),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: _isLoading ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                getSpace(0, 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _savePreset,
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.grey : Colors.black,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _savePreset() {
    bool isValid = true;
    String errorMessage = '';

    if (_presetNameController.text.trim().isEmpty) {
      isValid = false;
      errorMessage = 'Preset Name is required';
    } else if (_presetKeyController.text.trim().isEmpty) {
      isValid = false;
      errorMessage = 'Preset Key is required';
    } else if (_selectedHvacMode == null) {
      isValid = false;
      errorMessage = 'HVAC Mode is required';
    } else if (_selectedFanMode == null) {
      isValid = false;
      errorMessage = 'Fan Mode is required';
    } else if (widget.deviceId == null || widget.deviceId!.isEmpty) {
      isValid = false;
      errorMessage = 'Device ID is required';
    }

    final int heatingTemp = (_temperatureRange.start as double).round();
    final int coolingTemp = (_temperatureRange.end as double).round();

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: const Color(0xFFF35A5A),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<ThermostatBloc>().add(
          CreateClimatePreset(
            deviceId: widget.deviceId,
            climatePresetKey: _presetKeyController.text.trim(),
            name: _presetNameController.text.trim(),
            fanModeSetting: _selectedFanMode,
            hvacModeSetting: _selectedHvacMode,
            heatingSetPointFahrenheit: heatingTemp,
            coolingSetPointFahrenheit: coolingTemp,
            manualOverrideAllowed: _manualOverrideAllowed,
          ),
        );
  }
}
