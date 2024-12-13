import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/entities/payment_option.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';

class PaymentSelector extends StatefulWidget {
  final List<PaymentOption> paymentOptionList;
  final Function(PaymentOption?) onItemSelected;

  const PaymentSelector({Key? key, required this.paymentOptionList, required this.onItemSelected}) : super(key: key);

  @override
  State<PaymentSelector> createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<PaymentSelector> {
  int? _selectedOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.paymentOptionList.asMap().entries.map((entry) {
        final int index = entry.key;
        final PaymentOption option = entry.value;
        final bool isSelected = index == _selectedOptionIndex;
        return Container(
          decoration: const BoxDecoration(
              color: AppColors.lightGrey, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
          margin: const EdgeInsets.symmetric(vertical: AppSizes.marginSmall / 2),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.option_x(index + 1), style: AppTextStyles.small),
                Text(
                  "${AppLocalizations.of(context)!.days_x(option.numberOfDays)} - ${option.price ?? ""}${option.discount != null && (option.discount ?? 0) > 0 ? " (${AppLocalizations.of(context)!.discount_x(option.discount!)})" : ""}",
                  style: AppTextStyles.medium,
                ),
              ],
            ),
            trailing: isSelected
                ? const Icon(Icons.radio_button_checked, color: AppColors.primary)
                : const Icon(Icons.radio_button_unchecked, color: AppColors.text),
            onTap: () {
              setState(() {
                _selectedOptionIndex = index;
                widget.onItemSelected(option);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
