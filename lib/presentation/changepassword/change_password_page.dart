import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/change_password_with_code_usecase.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_text_form_field.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';

class ChangePasswordPage extends StatefulWidget {
  final ChangePasswordWithCodeUseCase _changePasswordWithCodeUseCase;
  final String _email;
  final String _code;

  const ChangePasswordPage(this._changePasswordWithCodeUseCase,
      {super.key, required String email, required String code})
      : _code = code,
        _email = email;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerificationController = TextEditingController();
  final FocusNode _passwordVerificationFocusNode = FocusNode();
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.marginRegular),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ScreenHeader(
                        title: AppLocalizations.of(context)!.change_your_password,
                        subtitle: AppLocalizations.of(context)!.change_your_password_description,
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextFormField(
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                hintText: AppLocalizations.of(context)!.password,
                                controller: _passwordController,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_passwordVerificationFocusNode);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.email_empty;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.marginRegular),
                              AppTextFormField(
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                focusNode: _passwordVerificationFocusNode,
                                keyboardType: TextInputType.visiblePassword,
                                hintText: AppLocalizations.of(context)!.repeat_password,
                                controller: _passwordVerificationController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!.password_empty;
                                  } else if (_passwordController.text != _passwordVerificationController.text) {
                                    return AppLocalizations.of(context)!.password_do_not_match;
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(color: AppColors.error),
                                  )),
                              const SizedBox(height: AppSizes.marginRegular * 6),
                              PrimaryButton(
                                width: double.infinity,
                                text: AppLocalizations.of(context)!.accept,
                                withLoading: true,
                                onPressed: changePassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void changeErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      changeErrorMessage("");
      final response = await widget._changePasswordWithCodeUseCase
          .execute(widget._email, widget._code, _passwordVerificationController.text);
      response.fold(
        onSuccess: (user) {
          context.navigateToLoginPage();
        },
        onFailure: (message, errorType) {
          changeErrorMessage(message);
        },
      );
    }
  }
}
