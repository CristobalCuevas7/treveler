import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treveler/firebase_options.dart';
import 'package:treveler/presentation/main/main_page.dart';
import 'package:treveler/style/app_system_ui_overlay_style.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/presentation/introduction/introduction_screen.dart';
import 'package:treveler/ui/snack_bar_service.dart';
import 'package:treveler/util/locator.dart';
import 'config/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isInDebugMode = false;
  assert(isInDebugMode = true);

  if (!isInDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  setupLocator();
  final appRouter = AppRouter();

  SystemChrome.setSystemUIOverlayStyle(AppSystemUiOverlayStyle.style);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.okapolio.treveler.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(MyApp(
    goRouter: appRouter.goRouter,
    isFirstTime: isFirstTime,
  ));
}

class MyApp extends StatelessWidget {
  final GoRouter goRouter;

  const MyApp({super.key, required this.goRouter, required bool isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Treveler',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      scaffoldMessengerKey: snackBarService.scaffoldMessengerKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('it'),
        Locale('pt'),
        Locale('de'),
        Locale('fr'),
      ],
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: AppColors.primary,
            ),
          ),
          textTheme: ThemeData.light()
              .textTheme
              .apply(fontFamily: 'SFPro', bodyColor: AppColors.text),
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              secondary: AppColors.primary,
              onSecondary: AppColors.white,
              error: AppColors.error,
              onError: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.text)),
    );
  }
}
