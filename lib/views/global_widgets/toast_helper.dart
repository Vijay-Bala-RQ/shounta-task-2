import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastHelper {
  static void showToast(
      {required BuildContext context,
      required String message,
      bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: isSuccess ? Colors.greenAccent : Colors.redAccent,
      content: Text(
        message,
        style: TextStyle(
            color: isSuccess ? Colors.black : Colors.white, fontSize: 14.sp),
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
