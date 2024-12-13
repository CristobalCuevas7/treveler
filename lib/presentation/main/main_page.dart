import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/usecases/activate_booking_usecase.dart';
import 'package:treveler/domain/usecases/add_booking_usecase.dart';
import 'package:treveler/domain/usecases/buy_booking_usecase.dart';
import 'package:treveler/domain/usecases/check_premium_usecase.dart';
import 'package:treveler/domain/usecases/check_user_is_logged_usecase.dart';
import 'package:treveler/domain/usecases/clean_user_data_usecase.dart';
import 'package:treveler/domain/usecases/contact_us_usecase.dart';
import 'package:treveler/domain/usecases/delete_account_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';
import 'package:treveler/domain/usecases/get_all_guides_usecase.dart';
import 'package:treveler/domain/usecases/get_all_interest_points_usecase.dart';
import 'package:treveler/domain/usecases/get_email_usecase.dart';
import 'package:treveler/domain/usecases/get_payment_options.dart';
import 'package:treveler/domain/usecases/send_code_usecase.dart';
import 'package:treveler/domain/usecases/verify_discount_code_usecase.dart';
import 'package:treveler/presentation/guide/guide_page.dart';
import 'package:treveler/presentation/interestpoint/interest_point_page.dart';
import 'package:treveler/presentation/profile/profile_page.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/util/app_icons.dart';
import 'package:treveler/util/geolocation.dart';
import 'package:treveler/util/locator.dart';
import 'package:treveler/presentation/experiences/experiences_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  static final List<Widget> _pages = [
    InterestPointPage(
        getIt<GetAllInterestPointsUseCase>(),
        getIt<CheckPremiumUseCase>(),
        getIt<FetchPremiumUseCase>(),
        getIt<GetPaymentOptionsUseCase>(),
        getIt<VerifyDiscountCodeUseCase>(),
        getIt<BuyBookingUseCase>(),
        getIt<ActivateBookingUseCase>(),
        getIt<CheckUserIsLoggedUseCase>(),
        getIt<AddBookingUseCase>(),
        getIt<Geolocation>()),
    ExperiencesPage(),
    //  GuidePage(getIt<GetAllGuidesUseCase>()),
    ProfilePage(
        getIt<GetEmailUseCase>(),
        getIt<SendCodeUseCase>(),
        getIt<CleanUserDataUseCase>(),
        getIt<DeleteAccountUseCase>(),
        getIt<CheckUserIsLoggedUseCase>(),
        getIt<ContactUsUseCase>())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.white),
        child: Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: AppColors.text,
              elevation: 0.0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.ic_interest_point,
                      size: AppSizes.navigationBarIcon),
                  label: AppLocalizations.of(context)!.interest_points,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.ic_guide,
                      size: AppSizes.navigationBarIcon),
                  label: AppLocalizations.of(context)!.guides,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(AppIcons.ic_profile,
                      size: AppSizes.navigationBarIcon),
                  label: AppLocalizations.of(context)!.profile,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.primary,
              onTap: _onItemTapped,
            )));
  }
}
