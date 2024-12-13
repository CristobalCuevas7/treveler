import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/guide_point.dart';
import 'package:treveler/domain/entities/interest_point.dart';

extension Navigation on BuildContext {
  void navigateToSplash() {
    final goRouter = GoRouter.of(this);
    goRouter.go('/');
  }

  void navigateToLoginPage() {
    final goRouter = GoRouter.of(this);
    goRouter.push('/login');
  }

  void navigateToMainPage() {
    final goRouter = GoRouter.of(this);
    goRouter.go('/main');
  }

  void navigateToRegisterPage() {
    final goRouter = GoRouter.of(this);
    goRouter.push('/register');
  }

  void navigateToBookingPage() {
    final goRouter = GoRouter.of(this);
    goRouter.push('/booking');
  }

  void navigateToLanguage() {
    final goRouter = GoRouter.of(this);
    goRouter.push('/language');
  }

  void navigateToRecoverPasswordPage() {
    final goRouter = GoRouter.of(this);
    goRouter.push('/recoverPassword');
  }

  void navigateToVerifyCodePage(String email) {
    final goRouter = GoRouter.of(this);
    goRouter.push('/verifyCode/$email');
  }

  void navigateToChangePasswordCodePage(String email, String code) {
    final goRouter = GoRouter.of(this);
    goRouter.push('/changePasswordPage/$email/$code');
  }

  void navigateToTips() {
    final goRouter = GoRouter.of(this);
    goRouter.push('/tips');
  }

  void navigateToGuideDetails(Guide guide) {
    final goRouter = GoRouter.of(this);
    goRouter.pushNamed("guide_details", extra: guide);
  }

  void navigateToInterestPointDetail(InterestPoint interestPoint) {
    final goRouter = GoRouter.of(this);
    goRouter.pushNamed("interest_point_details", extra: interestPoint);
  }

  void navigateToGuidePointDetails(GuidePoint guidePoint) {
    final goRouter = GoRouter.of(this);
    goRouter.pushNamed("guide_point_details", extra: guidePoint);
  }
}
