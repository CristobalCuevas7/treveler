import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/category.dart';
import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/domain/entities/location.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/activate_booking_usecase.dart';
import 'package:treveler/domain/usecases/add_booking_usecase.dart';
import 'package:treveler/domain/usecases/buy_booking_usecase.dart';
import 'package:treveler/domain/usecases/check_premium_usecase.dart';
import 'package:treveler/domain/usecases/check_user_is_logged_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';
import 'package:treveler/domain/usecases/get_all_interest_points_usecase.dart';
import 'package:treveler/domain/usecases/get_payment_options.dart';
import 'package:treveler/domain/usecases/verify_discount_code_usecase.dart';
import 'package:treveler/presentation/interestpoint/interest_point_item.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/app_alert_dialog.dart';
import 'package:treveler/ui/category_filter.dart';
import 'package:treveler/ui/payment_dialog.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:treveler/ui/snack_bar_service.dart';
import 'package:treveler/util/geolocation.dart';
import 'package:treveler/util/log.dart';

class InterestPointPage extends StatefulWidget {
  final GetAllInterestPointsUseCase _getAllInterestPointsUseCase;
  final CheckPremiumUseCase _checkPremiumUseCase;
  final FetchPremiumUseCase _fetchPremiumUseCase;
  final GetPaymentOptionsUseCase _getPaymentOptionsUseCase;
  final VerifyDiscountCodeUseCase _verifyDiscountCodeUseCase;
  final BuyBookingUseCase _buyBookingUseCase;
  final ActivateBookingUseCase _activateBookingUseCase;
  final CheckUserIsLoggedUseCase _checkUserIsLoggedUseCase;
  final AddBookingUseCase _addBookingUseCase;
  final Geolocation _geolocation;

  const InterestPointPage(
      this._getAllInterestPointsUseCase,
      this._checkPremiumUseCase,
      this._fetchPremiumUseCase,
      this._getPaymentOptionsUseCase,
      this._verifyDiscountCodeUseCase,
      this._buyBookingUseCase,
      this._activateBookingUseCase,
      this._checkUserIsLoggedUseCase,
      this._addBookingUseCase,
      this._geolocation,
      {super.key});

  @override
  State<InterestPointPage> createState() => _InterestPointPageState();
}

class _InterestPointPageState extends State<InterestPointPage> {
  bool _isLogged = false;
  bool _isPremium = false;
  List<Category> categories = [];
  List<InterestPoint> _interestPointList = List.empty(growable: true);
  List<InterestPoint> _filteredInterestPointList = List.empty(growable: true);
  bool _isLoading = true;
  Set<int> _selectedCategoryIds = {0};
  Location? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
    _checkPremium();
    _fetchInterestPoints();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      _checkPremium();
    }
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    _isLogged = await widget._checkUserIsLoggedUseCase.execute();
  }

  Future<void> _fetchGeolocation() async {
    try {
      final position = await widget._geolocation.determinePosition();
      setState(() {
        _currentPosition = position;
      });
      Log.show("Latitude: ${position.latitude}");
      Log.show("Longitude: ${position.longitude}");
    } catch (error) {
      Log.show("Error fetching geolocation: $error");
    }
  }

  void _fetchInterestPoints() async {
    await _fetchGeolocation();

    final result = await widget._getAllInterestPointsUseCase.execute();
    result.fold(
      onSuccess: (interestPointList) {
        var uniqueCategories = <int, Category>{};
        for (var interestPoint in interestPointList) {
          var category = interestPoint.category;
          if (_currentPosition != null) {
            interestPoint.distance = widget._geolocation.calculateDistance(_currentPosition!, interestPoint.location);
          }
          if (!uniqueCategories.containsKey(category.id)) {
            uniqueCategories[category.id] = category;
          }
        }
        var uniqueCategoryList = uniqueCategories.values.toList();
        uniqueCategoryList.sort((a, b) => a.order.compareTo(b.order));

        interestPointList.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

        setState(() {
          _interestPointList = interestPointList;
          categories = uniqueCategoryList;
          _filterInterestPoints();
          _isLoading = false;
        });
      },
      onFailure: (message, errorType) {
        setState(() {
          snackBarService.showErrorSnackBar(message);
          _isLoading = false;
        });
      },
    );
  }

  void _checkPremium() async {
    Log.show("Checking premium inside interest page");
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

  void _filterInterestPoints() {
    if (_selectedCategoryIds.contains(0) || _selectedCategoryIds.isEmpty) {
      _filteredInterestPointList = _interestPointList;
    } else {
      _filteredInterestPointList =
          _interestPointList.where((point) => _selectedCategoryIds.contains(point.category.id)).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.marginRegular),
            child: ScreenHeader(
              title: AppLocalizations.of(context)!.interest_points,
            ),
          ),
          CategoryFilter(
            categories: categories,
            onCategorySelected: (Set<int> selectedCategories) {
              _selectedCategoryIds = selectedCategories;
              _filterInterestPoints();
            },
          ),
          const SizedBox(height: AppSizes.marginRegular),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredInterestPointList.isEmpty
                  ? Center(
                      child: Text(
                      AppLocalizations.of(context)!.no_guides_found,
                      style: const TextStyle(color: AppColors.subtitle),
                    ))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginRegular),
                        child: SingleChildScrollView(
                          child: StaggeredGrid.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: AppSizes.marginRegular,
                            crossAxisSpacing: AppSizes.marginRegular,
                            children: List.generate(
                              _filteredInterestPointList.length,
                              (index) => StaggeredGridTile.fit(
                                crossAxisCellCount: 2, // Each item takes up half the width of the grid
                                child: InkWell(
                                    onTap: () {
                                      if (_filteredInterestPointList[index].requiresPayment && !_isPremium) {
                                        _showPaymentDialog();
                                      } else {
                                        context.navigateToInterestPointDetail(_filteredInterestPointList[index]);
                                      }
                                    },
                                    child: InterestPointItem(_filteredInterestPointList[index], _isPremium)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      )),
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
          snackBarService.showErrorSnackBar(message);
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
