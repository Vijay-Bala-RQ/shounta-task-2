import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../views/global_widgets/widget_helper.dart';

class CommonTextFieldWithLabel extends StatefulWidget {
  const CommonTextFieldWithLabel({
    super.key,
    this.customKey,
    required this.controller,
    required this.labelText,
    this.validator,
    this.isPassword = false,
    this.icon,
    this.inputFormatters,
    this.isDisbaled = false,
    this.errorText,
    this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.onEditingComplete,
    this.isReadOnly = false,
    this.maxlength,
    this.isRequired = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Key? customKey;
  final IconData? icon;
  final bool isPassword;
  final int? maxlength;
  final bool isDisbaled;
  final String? errorText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;
  final void Function()? onEditingComplete;
  final bool isReadOnly;
  final bool isRequired;

  @override
  State<CommonTextFieldWithLabel> createState() =>
      _CommonTextFieldWithLabelState();
}

class _CommonTextFieldWithLabelState extends State<CommonTextFieldWithLabel> {
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;
  late final ValueNotifier<String?> errorTextNotifier;

  @override
  void initState() {
    super.initState();
    errorTextNotifier = ValueNotifier<String?>(widget.errorText);
  }

  @override
  void didUpdateWidget(covariant CommonTextFieldWithLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    errorTextNotifier.value ??= widget.errorText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    errorTextNotifier.dispose();
    super.dispose();
  }

  String? _validateInput(String? value) {
    final String? result = widget.validator?.call(value);
    errorTextNotifier.value = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<String?>(
      valueListenable: errorTextNotifier,
      builder: (BuildContext context, String? errorValue, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 68.h,
              decoration: BoxDecoration(
                border: Border.all(
                    color: errorValue != null
                        ? const Color(0xFFF35A5A)
                        : const Color(0xFFE8EDE0)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Opacity(
                opacity: widget.isDisbaled ? 0.7 : 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: widget.labelText,
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color.fromRGBO(145, 158, 128, 1),
                          ),
                          children: <InlineSpan>[
                            if (widget.isRequired)
                              const TextSpan(
                                text: ' *',
                                style: TextStyle(color: Color(0xFFF35A5A)),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          key: widget.customKey,
                          controller: widget.controller,
                          focusNode: _focusNode,
                          obscureText: widget.isPassword && _obscureText,
                          obscuringCharacter: '*',
                          validator: !widget.isDisbaled && !widget.isReadOnly
                              ? _validateInput
                              : null,
                          minLines: widget.minLines,
                          maxLines: widget.maxLines,
                          maxLength: widget.maxlength,
                          maxLengthEnforcement: widget.maxlength != null
                              ? MaxLengthEnforcement.enforced
                              : null,
                          buildCounter: (
                            BuildContext context, {
                            required int currentLength,
                            required bool isFocused,
                            required int? maxLength,
                          }) =>
                              null,
                          inputFormatters: widget.inputFormatters,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          enabled: !widget.isDisbaled && !widget.isReadOnly,
                          onEditingComplete: widget.onEditingComplete,
                          onTapOutside: (PointerDownEvent event) =>
                              FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText:
                                widget.hintText ?? 'Enter ${widget.labelText}',
                            hintStyle: TextStyle(
                              color: const Color(0xFF919E80),
                              fontSize: 14.sp,
                            ),
                            prefixIcon: (widget.icon != null
                                ? Icon(
                                    widget.icon,
                                    size: 24,
                                    color: widget.controller.text.isEmpty
                                        ? const Color(0xFF919E80)
                                        : Colors.black,
                                  )
                                : null),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 24.w,
                              minHeight: 24.h,
                            ),
                            isCollapsed: true,
                            errorStyle: const TextStyle(fontSize: 0),
                            suffixIconConstraints: BoxConstraints(
                              minWidth: 24.w,
                              minHeight: 24.h,
                            ),
                            suffixIcon: (widget.isPassword
                                ? Padding(
                                    padding: EdgeInsets.only(right: 4.w),
                                    child: IconButton(
                                      highlightColor: Colors.transparent,
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 24.sp,
                                        color: widget.controller.text.isEmpty
                                            ? const Color(0xFF919E80)
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                  )
                                : null),
                          ),
                        ),
                      ),
                      getSpace(8.h, 0)
                    ],
                  ),
                ),
              ),
            ),
            if (errorValue != null && !(widget.isDisbaled || widget.isReadOnly))
              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      size: 16.sp,
                      color: const Color(0xFFF35A5A),
                    ),
                    getSpace(4.h, 0),
                    Expanded(
                      child: Text(
                        errorValue,
                        style: TextStyle(
                          color: const Color(0xFFF35A5A),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.customKey,
    required this.controller,
    required this.labelText,
    this.validator,
    this.isPassword = false,
    this.icon,
    this.inputFormatters,
    this.isDisbaled = false,
    this.errorText,
    this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.onEditingComplete,
    this.isReadOnly = false,
    this.maxlength,
    this.isRequired = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Key? customKey;
  final IconData? icon;
  final bool isPassword;
  final int? maxlength;
  final bool isDisbaled;
  final String? errorText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;
  final void Function()? onEditingComplete;
  final bool isReadOnly;
  final bool isRequired;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;
  late final ValueNotifier<String?> errorTextNotifier;

  @override
  void initState() {
    super.initState();
    errorTextNotifier = ValueNotifier<String?>(widget.errorText);
  }

  @override
  void didUpdateWidget(covariant CommonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    errorTextNotifier.value ??= widget.errorText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    errorTextNotifier.dispose();
    super.dispose();
  }

  String? _validateInput(String? value) {
    final String? result = widget.validator?.call(value);
    errorTextNotifier.value = result;
    return result;
  }

  String get _placeholderText {
    final String baseText = widget.hintText ?? widget.labelText;
    return widget.isRequired ? '$baseText *' : baseText;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorTextNotifier,
      builder: (BuildContext context, String? errorValue, _) {
        return Container(
          height: 68.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Opacity(
            opacity: widget.isDisbaled ? 0.7 : 1,
            child: TextFormField(
              key: widget.customKey,
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.isPassword && _obscureText,
              obscuringCharacter: '*',
              validator: !widget.isDisbaled && !widget.isReadOnly
                  ? _validateInput
                  : null,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              maxLength: widget.maxlength,
              maxLengthEnforcement: widget.maxlength != null
                  ? MaxLengthEnforcement.enforced
                  : null,
              buildCounter: (
                BuildContext context, {
                required int currentLength,
                required bool isFocused,
                required int? maxLength,
              }) =>
                  null,
              inputFormatters: widget.inputFormatters,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              enabled: !widget.isDisbaled && !widget.isReadOnly,
              onEditingComplete: widget.onEditingComplete,
              onTapOutside: (PointerDownEvent event) =>
                  FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 26.h),
                hintText: _placeholderText,
                hintStyle: TextStyle(
                  color: const Color(0xFF919E80),
                  fontSize: 14.sp,
                ),
                prefixIcon: (widget.icon != null
                    ? Icon(
                        widget.icon,
                        size: 24,
                        color: widget.controller.text.isEmpty
                            ? const Color(0xFF919E80)
                            : Colors.black,
                      )
                    : null),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 24.w,
                  minHeight: 24.h,
                ),
                isCollapsed: true,
                errorStyle: const TextStyle(fontSize: 0),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 24.w,
                  minHeight: 24.h,
                ),
                suffixIcon: (widget.isPassword
                    ? Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 24,
                            color: widget.controller.text.isEmpty
                                ? const Color(0xFF919E80)
                                : Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      )
                    : null),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CommonDropdownField<T> extends StatefulWidget {
  const CommonDropdownField({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.validator,
    this.isDisbaled = false,
    this.errorText,
    this.hintText,
    this.isRequired = false,
    this.displayText,
  });

  final String labelText;
  final List<T> items;
  final Function(T?) onChanged;
  final T? selectedValue;
  final String? Function(T?)? validator;
  final bool isDisbaled;
  final String? errorText;
  final String? hintText;
  final bool isRequired;
  final String Function(T)? displayText;

  @override
  State<CommonDropdownField<T>> createState() => _CommonDropdownFieldState<T>();
}

class _CommonDropdownFieldState<T> extends State<CommonDropdownField<T>> {
  late final ValueNotifier<String?> errorTextNotifier;

  @override
  void initState() {
    super.initState();
    errorTextNotifier = ValueNotifier<String?>(widget.errorText);
  }

  @override
  void didUpdateWidget(covariant CommonDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    errorTextNotifier.value ??= widget.errorText;
  }

  @override
  void dispose() {
    errorTextNotifier.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.items[index];
                    return ListTile(
                      title: Text(
                        widget.displayText?.call(item) ?? item.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        widget.onChanged(item);
                        context.pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorTextNotifier,
      builder: (BuildContext context, String? errorValue, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: widget.isDisbaled ? null : _showBottomSheet,
              child: Container(
                height: 68.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                child: Opacity(
                  opacity: widget.isDisbaled ? 0.7 : 1,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 26.h),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.selectedValue != null
                                    ? (widget.displayText
                                            ?.call(widget.selectedValue as T) ??
                                        widget.selectedValue.toString())
                                    : (widget.hintText ?? widget.labelText),
                                style: TextStyle(
                                  color: widget.selectedValue != null
                                      ? Colors.black
                                      : const Color(0xFF919E80),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFF919E80),
                              size: 24.sp,
                            ),
                          ],
                        ),
                      ),
                      if (widget.isRequired && widget.selectedValue == null)
                        Positioned(
                          left: 20.w,
                          top: 26.h,
                          child: IgnorePointer(
                            child: RichText(
                              text: TextSpan(
                                text: ''.padRight(
                                    ((widget.hintText ?? widget.labelText)
                                                .length *
                                            2.25)
                                        .round()),
                                style: const TextStyle(
                                  color: Color(0xFF919E80),
                                  fontSize: 14,
                                ),
                                children: const <InlineSpan>[
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Color(0xFFF35A5A)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (errorValue != null && !widget.isDisbaled)
              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      size: 16.sp,
                      color: const Color(0xFFF35A5A),
                    ),
                    getSpace(4.h, 0),
                    Expanded(
                      child: Text(
                        errorValue,
                        style: TextStyle(
                          color: const Color(0xFFF35A5A),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

class CommonSlider extends StatefulWidget {
  const CommonSlider({super.key, this.values, this.onChanged});
  final Function(SfRangeValues)? onChanged;
  final SfRangeValues? values;

  @override
  State<CommonSlider> createState() => _CommonSliderState();
}

class _CommonSliderState extends State<CommonSlider> {
  late SfRangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = widget.values ?? const SfRangeValues(64.0, 74.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: (((_values.start as double) - 50) / (90 - 50) * 100)
                    .round(),
                child: Container(),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '${(_values.start as double).round()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: (((_values.end as double) - (_values.start as double)) /
                        (90 - 50) *
                        100)
                    .round(),
                child: Container(),
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '${(_values.end as double).round()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex:
                    ((90 - (_values.end as double)) / (90 - 50) * 100).round(),
                child: Container(),
              ),
            ],
          ),
        ),
        getSpace(8.h, 0),
        SizedBox(
          height: 1.5.h,
          child: SfRangeSlider(
            min: 50.0,
            max: 90.0,
            values: _values,
            activeColor: const Color(0xFF141E05),
            inactiveColor: const Color(0xFFC6D2B6),
            startThumbIcon: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF67DCF2),
                shape: BoxShape.circle,
              ),
            ),
            endThumbIcon: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF16165),
                shape: BoxShape.circle,
              ),
            ),
            onChanged: (SfRangeValues values) {
              setState(() {
                widget.onChanged?.call(values);
                _values = values;
              });
            },
          ),
        ),
      ],
    );
  }
}
