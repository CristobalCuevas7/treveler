import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/app_text_field.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/secondary_button.dart';

class AddBookingDialog {
  static void show({required BuildContext context, required Function(String) onAdd}) {
    final TextEditingController codeController = TextEditingController();

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
                Text(AppLocalizations.of(context)!.add_booking_description, style: AppTextStyles.medium),
                const SizedBox(height: AppSizes.marginRegular),
                AppTextField(hintText: AppLocalizations.of(context)!.code, controller: codeController),
                const SizedBox(height: AppSizes.marginRegular),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: AppLocalizations.of(context)!.cancel,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: AppSizes.marginSmall),
                    Expanded(
                      child: PrimaryButton(
                        text: AppLocalizations.of(context)!.accept,
                        onPressed: () {
                          onAdd.call(codeController.text);
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
