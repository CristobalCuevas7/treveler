import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';

class AppTextStyles {
  static const TextStyle smallError = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );
  static const TextStyle small = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );
  static const TextStyle smallSubtitle = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.subtitle,
  );
  static const TextStyle medium = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );
  static const TextStyle mediumSubtitle = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.subtitle,
  );
  static const TextStyle mediumHighlight = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontMedium,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const TextStyle large = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const TextStyle screenTitle = TextStyle(
    fontFamily: 'SFPro',
    fontSize: AppSizes.fontScreenTitle,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
}