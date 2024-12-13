import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/payment_option.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/add_booking_usecase.dart';
import 'package:treveler/domain/usecases/buy_booking_usecase.dart';
import 'package:treveler/domain/usecases/verify_discount_code_usecase.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/app_text_field.dart';
import 'package:treveler/ui/payment_selector.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/util/app_icons.dart';
import 'package:treveler/util/dash_purchases.dart';
import 'package:treveler/util/log.dart';

class PaymentDialog extends StatefulWidget {
  final List<PaymentOption> _paymentOptions;
  final VerifyDiscountCodeUseCase _verifyDiscountCodeUseCase;
  final AddBookingUseCase _addBookingUseCase;
  final BuyBookingUseCase _buyBookingUseCase;
  final Function(Booking) _onSuccess;

  const PaymentDialog(this._verifyDiscountCodeUseCase, this._addBookingUseCase, this._buyBookingUseCase,
      this._paymentOptions, this._onSuccess,
      {super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  double total = 0.0;
  late DashPurchases dashPurchases;
  bool isLoading = true;

  final TextEditingController _discountCodeController = TextEditingController();
  final TextEditingController _purchaseCodeController = TextEditingController();
  DiscountCode? _discountCode;
  String _errorMessage = "";
  String _discountMessage = "";
  PaymentOption? optionSelected;
  List<PaymentOption> _paymentOptions = [];

  @override
  void initState() {
    super.initState();
    Log.show("Init State");
    dashPurchases = DashPurchases(widget._paymentOptions, onFail: () {
      Log.show("On Fail");
      setState(() {
        isLoading = false;
      });
    }, onSuccess: (purchaseDetails) async {
      Log.show("On Success");
      await _buyBooking(
          purchaseDetails.purchaseID!, int.parse(purchaseDetails.transactionDate!), optionSelected!.numberOfDays);
      setState(() {
        isLoading = false;
      });
    }, onLoadFinish: (paymentOptions) {
      Log.show("On Load Finish");
      setState(() {
        _paymentOptions = paymentOptions;
        if (_paymentOptions.isNotEmpty) {
          setOptionSelected(_paymentOptions[0]);
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.marginRegular),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radius), topRight: Radius.circular(AppSizes.radius)),
          ),
          child: isLoading
              ? _buildLoadingBox(context)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: AppSizes.roundedIconButton,
                        height: AppSizes.roundedIconButton,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.roundedIconButton / 2),
                            color: AppColors.lightGrey),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: const EdgeInsets.all(0.0),
                            icon: const Icon(AppIcons.ic_cross),
                            color: AppColors.primary)),
                    const SizedBox(height: AppSizes.marginSmall),
                    SizedBox(
                        width: double.infinity,
                        child:
                            Text(AppLocalizations.of(context)!.select_payment, style: AppTextStyles.mediumHighlight)),
                    const SizedBox(height: AppSizes.marginSmall),
                    SizedBox(
                        width: double.infinity,
                        child: Text(AppLocalizations.of(context)!.select_payment_description,
                            style: AppTextStyles.smallSubtitle)),
                    const SizedBox(height: AppSizes.marginRegular),
                    PaymentSelector(
                      paymentOptionList: _paymentOptions,
                      onItemSelected: (newOptionSelected) {
                        setState(() {
                          setOptionSelected(newOptionSelected);
                          _updateTotal();
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.marginSmall),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.marginRegular),
                      decoration: const BoxDecoration(
                          color: AppColors.lightGrey, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(AppIcons.ic_trolley, color: AppColors.text),
                              const SizedBox(width: AppSizes.marginSmall / 2),
                              Text(
                                AppLocalizations.of(context)!.purchase_code,
                                style: AppTextStyles.medium,
                              )
                            ],
                          ),
                          const SizedBox(height: AppSizes.marginSmall),
                          Row(
                            children: [
                              Expanded(
                                  child: AppTextField(
                                hintText: AppLocalizations.of(context)!.purchase_code,
                                controller: _purchaseCodeController,
                              )),
                              const SizedBox(width: AppSizes.marginSmall),
                              PrimaryButton(text: AppLocalizations.of(context)!.redeem, onPressed: _addBooking)
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.marginSmall),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.marginRegular),
                      decoration: const BoxDecoration(
                          color: AppColors.lightGrey, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(AppIcons.ic_discount, color: AppColors.text),
                              const SizedBox(width: AppSizes.marginSmall / 2),
                              Text(
                                AppLocalizations.of(context)!.discount_code,
                                style: AppTextStyles.medium,
                              )
                            ],
                          ),
                          const SizedBox(height: AppSizes.marginSmall),
                          Row(
                            children: [
                              Expanded(
                                  child: AppTextField(
                                hintText: AppLocalizations.of(context)!.discount_code,
                                controller: _discountCodeController,
                              )),
                              const SizedBox(width: AppSizes.marginSmall),
                              PrimaryButton(
                                  text: AppLocalizations.of(context)!.validate, onPressed: _verifyDiscountCode)
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.marginSmall),
                    Container(
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        child: _errorMessage.isNotEmpty
                            ? Text(_errorMessage, style: AppTextStyles.smallError)
                            : Text(_discountMessage, style: AppTextStyles.small)),
                    const SizedBox(height: AppSizes.marginSmall),
                    PrimaryButton(
                        text: AppLocalizations.of(context)!.pay,
                        width: double.infinity,
                        withLoading: true,
                        onPressed: () {
                          if (optionSelected != null) {
                            Log.show("Pay Pressed");
                            setState(() {
                              isLoading = true;
                            });
                            dashPurchases.buy(optionSelected!.paymentId, _discountCode);
                          }
                        }),
                    const SizedBox(height: AppSizes.marginSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(AppLocalizations.of(context)!.total, style: AppTextStyles.medium),
                        const SizedBox(width: AppSizes.marginSmall),
                        Text(
                          total.toStringAsFixed(2),
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: AppSizes.fontScreenTitle,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: AppSizes.marginRegular),
                  ],
                ),
          // Your custom bottom sheet content here
        ),
      ),
    );
  }

  Widget _buildLoadingBox(BuildContext context) {
    return SizedBox(
      height: AppSizes.paymentLoadingHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSizes.loadingSize, width: AppSizes.loadingSize, child: CircularProgressIndicator()),
          const SizedBox(height: AppSizes.marginRegular),
          Text(AppLocalizations.of(context)!.wait_do_not_close, style: AppTextStyles.medium)
        ],
      ),
    );
  }

  void _changeErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> _verifyDiscountCode() async {
    FocusScope.of(context).unfocus();
    _changeErrorMessage("");
    setDiscountCode(null);
    final response = await widget._verifyDiscountCodeUseCase.execute(_discountCodeController.text);
    response.fold(
      onSuccess: (discountCode) {
        setDiscountCode(discountCode);
      },
      onFailure: (message, errorType) {
        _changeErrorMessage(message);
      },
    );
  }

  Future<void> _buyBooking(String purchaseId, int transactionDate, int numberOfDays) async {
    final response = await widget._buyBookingUseCase.execute(purchaseId, transactionDate, numberOfDays, _discountCode);
    response.fold(
      onSuccess: (booking) {
        Log.show("Booking Completed ${booking.reference}");
        Navigator.pop(context);
        widget._onSuccess(booking);
      },
      onFailure: (message, errorType) {
        _changeErrorMessage(message);
      },
    );
  }

  Future<void> _addBooking() async {
    FocusScope.of(context).unfocus();
    _changeErrorMessage("");
    setDiscountCode(null);

    final result = await widget._addBookingUseCase.execute(_purchaseCodeController.text);
    await result.fold(onSuccess: (booking) async {
      Navigator.pop(context);
      widget._onSuccess(booking);
    }, onFailure: (message, error) {
      _changeErrorMessage(message);
    });
  }

  void _updateTotal() {
    String discountMessage = "";

    if (optionSelected != null) {
      double originalPrice = optionSelected!.rawPrice!;

      double discountAmount = 0.0;
      if (_discountCode != null) {
        int discountPercentage = _discountCode!.discount;
        discountAmount = originalPrice * discountPercentage / 100;
        discountMessage =
            AppLocalizations.of(context)!.discount_applied_x(discountPercentage, discountAmount.toStringAsFixed(2));
      }

      total = originalPrice - discountAmount;
    } else {
      total = 0.0;
    }

    setState(() {
      _discountMessage = discountMessage;
    });
  }

  void setOptionSelected(PaymentOption? newOptionSelected) {
    setState(() {
      optionSelected = newOptionSelected;
      _updateTotal();
    });
  }

  void setDiscountCode(DiscountCode? newDiscountCode) {
    setState(() {
      _discountCode = newDiscountCode;
      _updateTotal();
    });
  }
}
