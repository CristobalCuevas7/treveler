import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/contact_us_usecase.dart';
import 'package:treveler/domain/usecases/login_usecase.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_text_field.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/secondary_button.dart';

class LoginPage extends StatefulWidget {
  final LoginUseCase _loginUseCase;
  final ContactUsUseCase _contactUsUseCase;

  const LoginPage(this._loginUseCase, this._contactUsUseCase, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(AppSizes.marginRegular),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.1),
            Image.asset('assets/images/logo.png', width: screenWidth * 0.5),
            const SizedBox(height: AppSizes.marginRegular * 4),

            // Email TextField
            AppTextField(
              focusNode: emailFocusNode,
              hintText: AppLocalizations.of(context)!.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: _emailController,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
            ),
            const SizedBox(height: AppSizes.marginRegular),

            // Password TextField
            AppTextField(
              focusNode: passwordFocusNode,
              obscureText: true,
              hintText: AppLocalizations.of(context)!.password,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: AppColors.error),
                )),
            const SizedBox(height: AppSizes.marginRegular * 2),

            // Login Button
            PrimaryButton(
              width: double.infinity,
              text: AppLocalizations.of(context)!.login,
              withLoading: true,
              onPressed: login,
            ),
            const SizedBox(height: AppSizes.marginSmall),

            // Register Button
            SecondaryButton(
              width: double.infinity,
              text: AppLocalizations.of(context)!.register,
              onPressed: () {
                context.navigateToRegisterPage();
              },
            ),
            const SizedBox(height: AppSizes.marginSmall),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  context.navigateToRecoverPasswordPage();
                },
                child: Text(AppLocalizations.of(context)!.forgot_password,
                    style: const TextStyle(color: AppColors.subtitle)),
              ),
            ),
            Expanded(child: Container()),

            // Contact Us Text
            InkWell(
              onTap: () {
                widget._contactUsUseCase.execute();
              },
              child: Text(AppLocalizations.of(context)!.contact_us, style: const TextStyle(color: AppColors.subtitle)),
            ),
          ],
        ),
      ),
    );
  }

  void changeErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    changeErrorMessage("");
    final loginResponse = await widget._loginUseCase.execute(
      _emailController.text,
      _passwordController.text,
    );
    loginResponse.fold(
      onSuccess: (user) {
        context.navigateToSplash();
      },
      onFailure: (message, errorType) {
        changeErrorMessage(message);
      },
    );
  }
}
