import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/primary_button.dart';

class BookingItem extends StatefulWidget {
  final Booking _booking;
  final Function(Booking) _onTap;

  const BookingItem(this._booking, this._onTap, {super.key});

  @override
  State<BookingItem> createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  @override
  Widget build(BuildContext context) {
    final bool isActivated = widget._booking.activated != null;
    return Container(
        height: AppSizes.buttonHeight,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius)), color: AppColors.lightGrey),
        child: isActivated ? buildUsed(context) : buildNotUsed(context));
  }

  Widget buildNotUsed(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginRegular),
          child: Text(AppLocalizations.of(context)!.days_x(widget._booking.numberOfDays), style: AppTextStyles.medium),
        )),
        PrimaryButton(
            text: AppLocalizations.of(context)!.activate,
            onPressed: () {
              widget._onTap(widget._booking);
            })
      ],
    );
  }

  Widget buildUsed(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginRegular),
      child: Row(
        children: [
          Expanded(
              child: Text(AppLocalizations.of(context)!.days_x(widget._booking.numberOfDays),
                  style: AppTextStyles.mediumSubtitle)),
          Text(AppLocalizations.of(context)!.used, style: AppTextStyles.mediumSubtitle)
        ],
      ),
    );
  }
}
