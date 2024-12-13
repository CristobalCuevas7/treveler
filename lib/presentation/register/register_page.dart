import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/register_usecase.dart';
import 'package:treveler/style/app_system_ui_overlay_style.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/app_text_form_field.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:treveler/util/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  final RegisterUseCase _signupUseCase;

  const RegisterPage(this._signupUseCase, {super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordVerificationFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerificationController = TextEditingController();

  String _errorMessage = "";
  bool _isTermsAndConditionChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: AppSystemUiOverlayStyle.style,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.marginRegular),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ScreenHeader(
                        title: AppLocalizations.of(context)!.register,
                        subtitle: AppLocalizations.of(context)!.register_description,
                      ),
                      const SizedBox(height: AppSizes.marginRegular * 4),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextFormField(
                              controller: _emailController,
                              hintText: AppLocalizations.of(context)!.email,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.email_empty;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSizes.marginSmall),
                            AppTextFormField(
                              focusNode: _passwordFocusNode,
                              controller: _passwordController,
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_passwordVerificationFocusNode);
                              },
                              hintText: AppLocalizations.of(context)!.password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.password_empty;
                                } else if (_passwordController.text != _passwordVerificationController.text) {
                                  return AppLocalizations.of(context)!.password_do_not_match;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSizes.marginSmall),
                            AppTextFormField(
                              focusNode: _passwordVerificationFocusNode,
                              controller: _passwordVerificationController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              hintText: AppLocalizations.of(context)!.repeat_password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.password_empty;
                                } else if (_passwordController.text != _passwordVerificationController.text) {
                                  return AppLocalizations.of(context)!.password_do_not_match;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSizes.marginSmall),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(color: AppColors.error),
                                )),
                            const SizedBox(height: AppSizes.marginSmall),
                            buildTermsAndConditionsBox(),
                            const SizedBox(height: AppSizes.marginRegular * 2),
                            PrimaryButton(
                              width: double.infinity,
                              text: AppLocalizations.of(context)!.create_account,
                              enabled: _isTermsAndConditionChecked,
                              onPressed: register,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  void changeErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Widget buildTermsAndConditionsBox() {
    return InkWell(
      onTap: () {
        setState(() {
          _isTermsAndConditionChecked = !_isTermsAndConditionChecked;
        });
      },
      child: Row(
        children: <Widget>[
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border:
                    Border.all(color: _isTermsAndConditionChecked ? AppColors.primary : AppColors.subtitle, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.check_rounded,
                color: _isTermsAndConditionChecked ? AppColors.primary : AppColors.subtitle,
                size: 24.0,
              )),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.subtitle, fontSize: 12.0),
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context)!.terms_and_conditions_checkbox_pre,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.terms_and_conditions_checkbox,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = ()  {
                        launchUrl(Uri.parse(termsAndConditions));
                      },
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.terms_and_conditions_checkbox_post,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      changeErrorMessage("");
      final signupResponse = await widget._signupUseCase.execute(
        _emailController.text,
        _passwordController.text,
      );
      signupResponse.fold(
        onSuccess: (user) {
          context.navigateToLanguage();
        },
        onFailure: (message, errorType) {
          changeErrorMessage(message);
        },
      );
    }
  }
}
