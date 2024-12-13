import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treveler/style/colors.dart';

class AppSystemUiOverlayStyle {
  static const style = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
