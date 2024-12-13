import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';

class TipsItem extends StatelessWidget {
  final int index;
  final String text;

  const TipsItem({super.key, required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: AppColors.lightGrey, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
      margin: const EdgeInsets.symmetric(vertical: AppSizes.marginSmall / 2),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.marginSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.tip_x(index), style: AppTextStyles.small),
            const SizedBox(height: AppSizes.marginSmall),
            Text(
              text,
              style: AppTextStyles.medium,
            ),
          ],
        ),
      ),
    );
  }
}
