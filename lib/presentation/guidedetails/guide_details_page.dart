import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/activate_booking_usecase.dart';
import 'package:treveler/domain/usecases/add_booking_usecase.dart';
import 'package:treveler/domain/usecases/buy_booking_usecase.dart';
import 'package:treveler/domain/usecases/check_premium_usecase.dart';
import 'package:treveler/domain/usecases/check_user_is_logged_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';
import 'package:treveler/domain/usecases/get_payment_options.dart';
import 'package:treveler/domain/usecases/verify_discount_code_usecase.dart';
import 'package:treveler/presentation/guidedetails/guide_point_item.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_alert_dialog.dart';
import 'package:treveler/ui/network_images.dart';
import 'package:treveler/ui/payment_dialog.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:treveler/ui/snack_bar_service.dart';
import 'package:treveler/util/app_icons.dart';
import 'package:treveler/util/log.dart';

class GuideDetailsPage extends StatefulWidget {
  final Guide _guide;
  final GetPaymentOptionsUseCase _getPaymentOptionsUseCase;
  final VerifyDiscountCodeUseCase _verifyDiscountCodeUseCase;
  final CheckPremiumUseCase _checkPremiumUseCase;
  final FetchPremiumUseCase _fetchPremiumUseCase;
  final BuyBookingUseCase _buyBookingUseCase;
  final ActivateBookingUseCase _activateBookingUseCase;
  final CheckUserIsLoggedUseCase _checkUserIsLoggedUseCase;
  final AddBookingUseCase _addBookingUseCase;

  const GuideDetailsPage(
      this._guide,
      this._getPaymentOptionsUseCase,
      this._verifyDiscountCodeUseCase,
      this._checkPremiumUseCase,
      this._fetchPremiumUseCase,
      this._buyBookingUseCase,
      this._activateBookingUseCase,
      this._checkUserIsLoggedUseCase,
      this._addBookingUseCase,
      {super.key});

  @override
  State<GuideDetailsPage> createState() => _GuideDetailsPageState();
}

class _GuideDetailsPageState extends State<GuideDetailsPage> {
  bool _isLogged = false;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
    _checkPremium();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    _isLogged = await widget._checkUserIsLoggedUseCase.execute();
  }

  void _checkPremium() async {
    final result = await widget._checkPremiumUseCase.execute();
    result.fold(onSuccess: (isPremium) {
      setState(() {
        Log.show(isPremium ? "Is Premium" : "Is NOT Premium");
        _isPremium = isPremium;
      });
    }, onFailure: (message, error) {
      snackBarService.showErrorSnackBar(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.marginRegular),
              child: Column(
                children: [
                  ScreenHeader(title: widget._guide.name),
                  Row(
                    children: [
                      Text("${widget._guide.totalDistance}km", style: AppTextStyles.mediumSubtitle),
                      const Spacer(),
                      const Icon(AppIcons.ic_point_small, size: AppSizes.fontSmall, color: AppColors.primary),
                      Text(widget._guide.points.length.toString(), style: const TextStyle(color: AppColors.primary))
                    ],
                  ),
                  const SizedBox(height: AppSizes.marginRegular),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                    child: NetworkImages(
                      fit: BoxFit.cover,
                      image: widget._guide.image,
                      height: AppSizes.guideDetailsImageHeight,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: AppSizes.marginRegular),
                  Text(widget._guide.description, style: AppTextStyles.medium),
                  const SizedBox(height: AppSizes.marginRegular),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildGuidePointItem(index, _isPremium),
              childCount: widget._guide.points.length,
            ),
          ),
          if (!_isPremium)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.marginRegular),
                child: PrimaryButton(
                    width: double.infinity,
                    withLoading: true,
                    text: AppLocalizations.of(context)!.unblock,
                    onPressed: _showPaymentDialog),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGuidePointItem(int index, bool isPremium) {
    final point = widget._guide.points[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.marginSmall, horizontal: AppSizes.marginRegular),
      child: InkWell(
        onTap: () {
          if (point.isLocked && !isPremium) {
            _showPaymentDialog();
          } else {
            context.navigateToGuidePointDetails(point);
          }
        },
        child: GuidePointItem(
          point,
          index + 1,
          isPremium,
          key: ValueKey(point.id),
        ),
      ),
    );
  }

  Future<void> _showPaymentDialog() async {
    if (_isLogged) {
      final response = await widget._getPaymentOptionsUseCase.execute();
      response.fold(
        onSuccess: (paymentOptionList) {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return PaymentDialog(widget._verifyDiscountCodeUseCase, widget._addBookingUseCase,
                  widget._buyBookingUseCase, paymentOptionList, (booking) {
                _showConfirmationDialog(booking);
              });
            },
          );
        },
        onFailure: (message, errorType) {
          // changeErrorMessage(message);
        },
      );
    } else {
      context.navigateToLoginPage();
    }
  }

  Future<void> _showConfirmationDialog(Booking booking) async {
    AppAlertDialog.show(
        context: context,
        description: AppLocalizations.of(context)!.activate_booking_confirmation,
        primaryButtonText: AppLocalizations.of(context)!.yes,
        primaryButtonAction: () async {
          await _activateBooking(booking);
        },
        secondaryButtonText: AppLocalizations.of(context)!.no);
  }

  Future<void> _activateBooking(Booking booking) async {
    final result = await widget._activateBookingUseCase.execute(booking);
    await result.fold(onSuccess: (_) async {
      await widget._fetchPremiumUseCase.execute();
      await Future.delayed(const Duration(seconds: 2));
      _checkPremium();
    }, onFailure: (message, error) {
      snackBarService.showErrorSnackBar(message);
    });
  }
}
