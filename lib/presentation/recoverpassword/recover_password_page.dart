import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/send_code_usecase.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_text_field.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';

class RecoverPasswordPage extends StatefulWidget {
  final SendCodeUseCase _sendCodeUseCase;

  const RecoverPasswordPage(this._sendCodeUseCase, {super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
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
                        title: AppLocalizations.of(context)!.recover_your_password,
                        subtitle: AppLocalizations.of(context)!.recover_your_password_description,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppTextField(
                              hintText: AppLocalizations.of(context)!.email,
                              controller: _emailController,
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
                              text: AppLocalizations.of(context)!.send_code,
                              withLoading: true,
                              onPressed: sendCode,
                            ),
                          ],
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

  Future<void> sendCode() async {
    FocusScope.of(context).unfocus();
    changeErrorMessage("");
    final response = await widget._sendCodeUseCase.execute(_emailController.text);
    response.fold(
      onSuccess: (_) {
        context.navigateToVerifyCodePage(_emailController.text);
      },
      onFailure: (message, errorType) {
        changeErrorMessage(message);
      },
    );
  }
}
