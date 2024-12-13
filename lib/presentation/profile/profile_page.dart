import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/check_user_is_logged_usecase.dart';
import 'package:treveler/domain/usecases/clean_user_data_usecase.dart';
import 'package:treveler/domain/usecases/contact_us_usecase.dart';
import 'package:treveler/domain/usecases/delete_account_usecase.dart';
import 'package:treveler/domain/usecases/get_email_usecase.dart';
import 'package:treveler/domain/usecases/send_code_usecase.dart';
import 'package:treveler/presentation/profile/profile_item.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/app_alert_dialog.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:treveler/ui/snack_bar_service.dart';
import 'package:treveler/util/app_icons.dart';
import 'package:treveler/util/log.dart';

class ProfilePage extends StatefulWidget {
  final GetEmailUseCase _getEmailUseCase;
  final SendCodeUseCase _sendCodeUseCase;
  final CleanUserDataUseCase _cleanUserDataUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final CheckUserIsLoggedUseCase _checkUserIsLoggedUseCase;
  final ContactUsUseCase _contactUsUseCase;

  const ProfilePage(this._getEmailUseCase, this._sendCodeUseCase, this._cleanUserDataUseCase,
      this._deleteAccountUseCase, this._checkUserIsLoggedUseCase, this._contactUsUseCase,
      {super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = "";
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    Log.show("Profile Page created");
    _fetchEmail();
    _checkIfUserIsLoggedIn();
  }

  void _checkIfUserIsLoggedIn() async {
    _isLogged = await widget._checkUserIsLoggedUseCase.execute();
  }

  void _fetchEmail() async {
    final result = await widget._getEmailUseCase.execute();
    result.fold(
      onSuccess: (email) {
        setState(() {
          _email = email;
        });
      },
      onFailure: (message, errorType) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(AppSizes.marginRegular),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.marginRegular),
            child: ScreenHeader(
              title: AppLocalizations.of(context)!.profile,
            ),
          ),
          Text(_email, style: AppTextStyles.medium),
          const SizedBox(height: AppSizes.marginRegular * 2),
          (_isLogged) ? _buildLoggedMenu() : _buildNotLoggedMenu()
        ],
      ),
    )));
  }

  Widget _buildLoggedMenu() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildChangePassword(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildChangeLanguage(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildBookings(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildTips(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildContactUs(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildLogout(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildRemoveAccount()
    ]);
  }

  Widget _buildNotLoggedMenu() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildLogin(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildTips(),
      const SizedBox(height: AppSizes.marginSmall),
      _buildContactUs()
    ]);
  }

  Widget _buildTips() {
    return ProfileItem(
        icon: AppIcons.ic_tip,
        arrow: true,
        text: AppLocalizations.of(context)!.profile_tips,
        onTap: () {
          context.navigateToTips();
        });
  }

  Widget _buildLogin() {
    return ProfileItem(
        icon: AppIcons.ic_password,
        arrow: true,
        text: AppLocalizations.of(context)!.login,
        onTap: () {
          context.navigateToLoginPage();
        });
  }

  Widget _buildContactUs() {
    return ProfileItem(
        icon: AppIcons.ic_contact_us,
        arrow: true,
        text: AppLocalizations.of(context)!.profile_contact_us,
        onTap: () {
          widget._contactUsUseCase.execute();
        });
  }

  Widget _buildChangePassword() {
    return ProfileItem(
        icon: AppIcons.ic_password,
        arrow: true,
        text: AppLocalizations.of(context)!.profile_change_password,
        onTap: () async {
          final response = await widget._sendCodeUseCase.execute(_email);
          response.fold(onSuccess: (_) {
            context.navigateToVerifyCodePage(_email);
          }, onFailure: (message, errorType) {
            snackBarService.showErrorSnackBar(message);
          });
        });
  }

  Widget _buildChangeLanguage() {
    return ProfileItem(
      icon: AppIcons.ic_language,
      arrow: true,
      text: AppLocalizations.of(context)!.profile_change_language,
      onTap: () {
        context.navigateToLanguage();
      },
    );
  }

  Widget _buildBookings() {
    return ProfileItem(
      icon: AppIcons.ic_booking,
      arrow: true,
      text: AppLocalizations.of(context)!.profile_bookings,
      onTap: () {
        context.navigateToBookingPage();
      },
    );
  }

  Widget _buildLogout() {
    return ProfileItem(
        icon: AppIcons.ic_logout,
        text: AppLocalizations.of(context)!.profile_log_out,
        onTap: () {
          AppAlertDialog.show(
              context: context,
              description: AppLocalizations.of(context)!.logout_confirmation,
              primaryButtonText: AppLocalizations.of(context)!.no,
              secondaryButtonText: AppLocalizations.of(context)!.yes,
              secondaryButtonAction: () async {
                await widget._cleanUserDataUseCase.execute();
                context.navigateToSplash();
              });
        });
  }

  Widget _buildRemoveAccount() {
    return ProfileItem(
        icon: AppIcons.ic_delete,
        text: AppLocalizations.of(context)!.profile_delete_account,
        onTap: () {
          AppAlertDialog.show(
              context: context,
              description: AppLocalizations.of(context)!.delete_account_confirmation,
              primaryButtonText: AppLocalizations.of(context)!.no,
              secondaryButtonText: AppLocalizations.of(context)!.yes,
              secondaryButtonAction: () async {
                final result = await widget._deleteAccountUseCase.execute();
                result.fold(onSuccess: (_) {
                  context.navigateToSplash();
                }, onFailure: (message, error) {
                  snackBarService.showErrorSnackBar(message);
                });
              });
        });
  }
}
