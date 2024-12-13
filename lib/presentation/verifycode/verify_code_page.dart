import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/verify_code_usecase.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_text_field.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';

class VerifyCodePage extends StatefulWidget {
  final VerifyCodeUseCase _verifyCodeUseCase;
  final String email;

  const VerifyCodePage(this._verifyCodeUseCase, {super.key, required this.email});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _verificationCodeController = TextEditingController();
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
                        title: AppLocalizations.of(context)!.verify_code,
                        subtitle: AppLocalizations.of(context)!.verify_code_description,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppTextField(
                              hintText: AppLocalizations.of(context)!.verify_code,
                              controller: _verificationCodeController,
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
                              text: AppLocalizations.of(context)!.validate,
                              withLoading: true,
                              onPressed: verifyCode,
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

  Future<void> verifyCode() async {
    FocusScope.of(context).unfocus();
    changeErrorMessage("");
    final response = await widget._verifyCodeUseCase.execute(widget.email, _verificationCodeController.text);
    response.fold(
      onSuccess: (_) {
        context.navigateToChangePasswordCodePage(widget.email, _verificationCodeController.text);
      },
      onFailure: (message, errorType) {
        changeErrorMessage(message);
      },
    );
  }
}
