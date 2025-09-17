import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/common_bg.dart';
import '../../../../core/common/common_fields.dart';
import '../../../../models/models.dart';
import '../../../global_widgets/toast_helper.dart';
import '../../../global_widgets/widget_helper.dart';
import '../bloc/device_bloc.dart';

class DeviceChannelsPage extends StatefulWidget {
  const DeviceChannelsPage({super.key, this.deviceId});
  final int? deviceId;
  static const String routePath = '/channels';

  @override
  State<DeviceChannelsPage> createState() => _DeviceChannelsPageState();
}

class _DeviceChannelsPageState extends State<DeviceChannelsPage> {
  List<Appliance>? appliances = <Appliance>[];

  List<Channel>? originalChannels = <Channel>[];

  late List<Channel>? currentChannels = [];
  final Map<int, TextEditingController> _controllers =
      <int, TextEditingController>{};
  bool _hasChanges = false;

  late DeviceBloc _deviceBloc;
  StreamSubscription<DeviceState>? _blocSubscription;

  @override
  void initState() {
    super.initState();
    _deviceBloc = context.read<DeviceBloc>();
    _setupBlocListener();
    _initializePage();
  }

  void _setupBlocListener() {
    _blocSubscription = _deviceBloc.stream.listen((DeviceState state) {
      if (!mounted) {
        return;
      }
      _handleBlocState(state);
    });
  }

  void _handleBlocState(DeviceState state) {
    setState(() {
      switch (state.runtimeType) {
        case const (FetchAllAppliancesSuccess):
          if (_deviceBloc.deviceStateData.appliances != null) {
            appliances = _deviceBloc.deviceStateData.appliances;
            if (widget.deviceId != null) {
              _deviceBloc.add(FetchDeviceChannelsEvent(id: widget.deviceId));
            }
          }

        case const (FetchDeviceChannelsSuccess):
          final FetchDeviceChannelsSuccess successState =
              state as FetchDeviceChannelsSuccess;
          originalChannels = successState.channels;
          currentChannels = List.from(originalChannels ?? []);
          _initializeControllers();

        case const (UpdateDeviceChannelsSuccess):
          _hasChanges = false;
          originalChannels = List.from(currentChannels ?? []);
          ToastHelper.showToast(
              context: context, message: 'Changes saved successfully!');
          context.pop();

        case const (DevicesError):
          ToastHelper.showToast(
              context: context,
              message: 'Error saving changes. Please try again.',
              isSuccess: false);
      }
    });
  }

  void _initializePage() {
    _deviceBloc.add(FetchAllAppliancesEvent());
  }

  void _initializeControllers() {
    for (final TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();

    for (int i = 0; i < (currentChannels?.length ?? 0); i++) {
      _controllers[i] =
          TextEditingController(text: currentChannels?[i].personalizedName);
      _controllers[i]!.addListener(() => _checkForChanges());
    }
  }

  void _checkForChanges() {
    bool hasChanges = false;
    for (int i = 0; i < (currentChannels?.length ?? 0); i++) {
      if (_controllers[i]!.text !=
          (originalChannels?[i].personalizedName ?? '')) {
        hasChanges = true;
        break;
      }
    }

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  String? _getApplianceName(int? applianceId) {
    return appliances
        ?.firstWhere((Appliance? appliance) => appliance?.id == applianceId,
            orElse: () => const Appliance(id: -1, name: 'Unknown Appliance'))
        .name;
  }

  void _onSave() {
    if (currentChannels == null) {
      return;
    }

    final List<Map<String, dynamic>> channelsData = <Map<String, dynamic>>[];
    for (int i = 0; i < currentChannels!.length; i++) {
      channelsData.add(<String, dynamic>{
        'id': currentChannels![i].id,
        'applianceId': currentChannels![i].applianceId,
        'personalizedName': _controllers[i]!.text,
      });
    }

    for (int i = 0; i < currentChannels!.length; i++) {
      final updatedChannel = currentChannels![i].copyWith(
        personalizedName: _controllers[i]!.text,
      );
      currentChannels![i] = updatedChannel;
    }

    if (widget.deviceId != null) {
      _deviceBloc.add(UpdateDeviceChannelsEvent(
        id: widget.deviceId,
        channels: channelsData,
      ));
    }
  }

  void _onCancel() {
    for (int i = 0; i < (originalChannels?.length ?? 0); i++) {
      _controllers[i]?.text = originalChannels?[i].personalizedName ?? '';
    }

    setState(() {
      _hasChanges = false;
    });
  }

  List<Channel> _getSkeletonChannels() {
    return List.generate(
        3,
        (index) => Channel(
              id: index,
              applianceId: index,
              personalizedName: 'Skeleton Channel Name ${index + 1}',
            ));
  }

  void _initializeSkeletonControllers() {
    _controllers.clear();
    for (int i = 0; i < 3; i++) {
      _controllers[i] =
          TextEditingController(text: 'Skeleton Custom Name ${i + 1}');
    }
  }

  @override
  void dispose() {
    _blocSubscription?.cancel();
    for (final TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        final List<Channel> displayChannels =
            (state is FetchAllAppliancesLoading ||
                    state is FetchDeviceChannelsLoading)
                ? _getSkeletonChannels()
                : (currentChannels ?? []);

        if ((state is FetchAllAppliancesLoading ||
                state is FetchDeviceChannelsLoading) &&
            _controllers.isEmpty) {
          _initializeSkeletonControllers();
        }

        return AbsorbPointer(
          absorbing: state is FetchAllAppliancesLoading ||
              state is FetchDeviceChannelsLoading ||
              state is UpdateDeviceChannelsLoading,
          child: CommonBackgroundPage(
            extendBodyBehindAppBar: true,
            safeAreaBottom: false,
            appBar: AppBar(
              centerTitle: false,
              title: Skeletonizer(
                enabled: state is FetchAllAppliancesLoading ||
                    state is FetchDeviceChannelsLoading,
                child: Text(
                  'Device 01',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 32.sp,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: EdgeInsets.only(left: 16.w),
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
            ),
            body: Skeletonizer(
              enabled: state is FetchAllAppliancesLoading ||
                  state is FetchDeviceChannelsLoading,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        children: <Widget>[
                          for (int i = 0;
                              i < displayChannels.length;
                              i++) ...<Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Channel ${i + 1}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromRGBO(145, 158, 128, 1),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: CommonTextFieldWithLabel(
                                isRequired: true,
                                controller: TextEditingController(
                                    text: (state is FetchAllAppliancesLoading ||
                                            state
                                                is FetchDeviceChannelsLoading)
                                        ? 'Skeleton Appliance Name'
                                        : _getApplianceName(
                                            displayChannels[i].applianceId)),
                                labelText: 'Appliance Name',
                                isReadOnly: true,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 32.h),
                              child: CommonTextFieldWithLabel(
                                controller:
                                    _controllers[i] ?? TextEditingController(),
                                labelText: 'Customise Name',
                                hintText:
                                    'Enter custom name for this appliance',
                              ),
                            ),
                          ],
                          if (_hasChanges &&
                              !(state is FetchAllAppliancesLoading ||
                                  state is FetchDeviceChannelsLoading ||
                                  state is UpdateDeviceChannelsLoading))
                            getSpace(100.h, 0),
                        ],
                      ),
                    ),
                  ),
                  if (_hasChanges ||
                      (state is FetchAllAppliancesLoading ||
                          state is FetchDeviceChannelsLoading ||
                          state is UpdateDeviceChannelsLoading))
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 24.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: (state is FetchAllAppliancesLoading ||
                                      state is FetchDeviceChannelsLoading ||
                                      state is UpdateDeviceChannelsLoading)
                                  ? null
                                  : () => _onCancel(),
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: (state is FetchAllAppliancesLoading ||
                                          state is FetchDeviceChannelsLoading ||
                                          state is UpdateDeviceChannelsLoading)
                                      ? Colors.grey.shade300
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
                                      color: (state is FetchAllAppliancesLoading ||
                                              state
                                                  is FetchDeviceChannelsLoading ||
                                              state
                                                  is UpdateDeviceChannelsLoading)
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          getSpace(0, 16.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: (state is FetchAllAppliancesLoading ||
                                      state is FetchDeviceChannelsLoading ||
                                      state is UpdateDeviceChannelsLoading)
                                  ? null
                                  : _onSave,
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: (state is FetchAllAppliancesLoading ||
                                          state is FetchDeviceChannelsLoading ||
                                          state is UpdateDeviceChannelsLoading)
                                      ? Colors.grey
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                child: Center(
                                  child: (state is FetchAllAppliancesLoading ||
                                          state is FetchDeviceChannelsLoading ||
                                          state is UpdateDeviceChannelsLoading)
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child:
                                              const CircularProgressIndicator(
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
            ),
          ),
        );
      },
    );
  }
}
