import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/secondary_button.dart';

class AppAlertDialog {
  static void show({
    required BuildContext context,
    required String description,
    required String primaryButtonText,
    VoidCallback? primaryButtonAction,
    String? secondaryButtonText,
    VoidCallback? secondaryButtonAction,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(AppSizes.marginRegular),
            decoration: const BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(description, style: AppTextStyles.medium),
                const SizedBox(height: AppSizes.marginRegular),
                Row(
                  children: [
                    if (secondaryButtonText != null)
                      Expanded(
                        child: SecondaryButton(
                          text: secondaryButtonText,
                          onPressed: () {
                            secondaryButtonAction?.call();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    if (secondaryButtonText != null) const SizedBox(width: AppSizes.marginSmall),
                    Expanded(
                      child: PrimaryButton(
                        text: primaryButtonText,
                        onPressed: () {
                          primaryButtonAction?.call();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
