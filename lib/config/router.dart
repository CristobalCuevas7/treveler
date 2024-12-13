import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/guide_point.dart';
import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/domain/usecases/activate_booking_usecase.dart';
import 'package:treveler/domain/usecases/add_booking_usecase.dart';
import 'package:treveler/domain/usecases/buy_booking_usecase.dart';
import 'package:treveler/domain/usecases/change_password_with_code_usecase.dart';
import 'package:treveler/domain/usecases/check_premium_usecase.dart';
import 'package:treveler/domain/usecases/check_session_usecase.dart';
import 'package:treveler/domain/usecases/check_user_is_logged_usecase.dart';
import 'package:treveler/domain/usecases/contact_us_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';
import 'package:treveler/domain/usecases/get_all_bookings_usecase.dart';
import 'package:treveler/domain/usecases/get_payment_options.dart';
import 'package:treveler/domain/usecases/login_usecase.dart';
import 'package:treveler/domain/usecases/register_usecase.dart';
import 'package:treveler/domain/usecases/select_language_usecase.dart';
import 'package:treveler/domain/usecases/send_code_usecase.dart';
import 'package:treveler/domain/usecases/verify_code_usecase.dart';
import 'package:treveler/domain/usecases/verify_discount_code_usecase.dart';
import 'package:treveler/presentation/booking/booking_page.dart';
import 'package:treveler/presentation/changepassword/change_password_page.dart';
import 'package:treveler/presentation/guidedetails/guide_details_page.dart';
import 'package:treveler/presentation/guidepointdetails/guide_point_details_page.dart';
import 'package:treveler/presentation/interestpointdetails/interest_point_details_page.dart';
import 'package:treveler/presentation/language/language_page.dart';
import 'package:treveler/presentation/login/login_page.dart';
import 'package:treveler/presentation/main/main_page.dart';
import 'package:treveler/presentation/recoverpassword/recover_password_page.dart';
import 'package:treveler/presentation/register/register_page.dart';
import 'package:treveler/presentation/tips/tips_page.dart';
import 'package:treveler/presentation/verifycode/verify_code_page.dart';
import 'package:treveler/util/locator.dart';
import 'package:treveler/presentation/introduction/introduction_screen.dart';
import '../presentation/splash/splash_page.dart';

class AppRouter {
  late final GoRouter goRouter;

  AppRouter() {
    goRouter = GoRouter(
      routes: [
        // GoRoute(
        //   path: '/',
        //   pageBuilder: (context, state) => const MaterialPage(child: MockPreviewPage()),
        // ),
        GoRoute(
          path: '/',
          redirect: (context, state) async {
            final prefs = await SharedPreferences.getInstance();
            final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
            return isFirstTime ? '/introduction' : '/main';
          },
        ),
        GoRoute(
          path: '/introduction',
          pageBuilder: (context, state) => const MaterialPage(
            child: IntroductionScreen(),
          ),
        ),

        GoRoute(
          path: '/main',
          pageBuilder: (context, state) =>
              const MaterialPage(child: MainPage()),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => MaterialPage(
              child:
                  LoginPage(getIt<LoginUseCase>(), getIt<ContactUsUseCase>())),
        ),
        GoRoute(
          path: '/language',
          pageBuilder: (context, state) =>
              MaterialPage(child: LanguagePage(getIt<SelectLanguageUseCase>())),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) =>
              MaterialPage(child: RegisterPage(getIt<RegisterUseCase>())),
        ),
        GoRoute(
          path: '/booking',
          pageBuilder: (context, state) => MaterialPage(
              child: BookingPage(
                  getIt<GetAllBookingsUseCase>(),
                  getIt<ActivateBookingUseCase>(),
                  getIt<FetchPremiumUseCase>())),
        ),
        GoRoute(
          path: '/recoverPassword',
          pageBuilder: (context, state) => MaterialPage(
              child: RecoverPasswordPage(getIt<SendCodeUseCase>())),
        ),
        GoRoute(
          path: '/tips',
          pageBuilder: (context, state) =>
              const MaterialPage(child: TipsPage()),
        ),
        GoRoute(
            path: '/changePasswordPage/:email/:code',
            pageBuilder: (context, state) {
              final email = state.pathParameters['email'] ?? '';
              final code = state.pathParameters['code'] ?? '';
              return MaterialPage(
                  child: ChangePasswordPage(
                      getIt<ChangePasswordWithCodeUseCase>(),
                      email: email,
                      code: code));
            }),
        GoRoute(
            path: '/verifyCode/:email',
            pageBuilder: (context, state) {
              final email = state.pathParameters['email'] ?? '';
              return MaterialPage(
                  child:
                      VerifyCodePage(getIt<VerifyCodeUseCase>(), email: email));
            }),
        GoRoute(
            name: 'guide_details',
            path: '/guide_details',
            pageBuilder: (context, state) {
              final guide = state.extra as Guide;
              return MaterialPage(
                  child: GuideDetailsPage(
                      guide,
                      getIt<GetPaymentOptionsUseCase>(),
                      getIt<VerifyDiscountCodeUseCase>(),
                      getIt<CheckPremiumUseCase>(),
                      getIt<FetchPremiumUseCase>(),
                      getIt<BuyBookingUseCase>(),
                      getIt<ActivateBookingUseCase>(),
                      getIt<CheckUserIsLoggedUseCase>(),
                      getIt<AddBookingUseCase>()));
            }),
        GoRoute(
            name: 'interest_point_details',
            path: '/interest_point_details',
            pageBuilder: (context, state) {
              final interestPoint = state.extra as InterestPoint;
              return MaterialPage(
                  child: InterestPointDetailPage(interestPoint));
            }),
        GoRoute(
            name: 'guide_point_details',
            path: '/guide_point_details',
            pageBuilder: (context, state) {
              final guidePoint = state.extra as GuidePoint;
              return MaterialPage(child: GuidePointDetailsPage(guidePoint));
            }),
      ],
    );
  }
}
