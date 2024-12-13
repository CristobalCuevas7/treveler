import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/select_language_usecase.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';

class LanguagePage extends StatefulWidget {
  final SelectLanguageUseCase _selectLanguageUseCase;

  const LanguagePage(this._selectLanguageUseCase, {super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _errorMessage = "";
  List<String> languages = ["es", "en", "de", "it", "pt", "fr"];
  String _languageSelected = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        padding: const EdgeInsets.all(AppSizes.marginRegular),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeader(
                title: AppLocalizations.of(context)!.language,
                subtitle: AppLocalizations.of(context)!.language_description),
            SizedBox(height: screenHeight * 0.10),
            GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSizes.marginRegular,
                mainAxisSpacing: AppSizes.marginRegular,
              ),
              children: languages.map<Widget>((language) => _buildFlag(language)).toList(),
            ),
            const SizedBox(height: AppSizes.marginRegular),
            Text(_errorMessage, style: AppTextStyles.smallError),
            SizedBox(height: screenHeight * 0.10),
            PrimaryButton(
                width: double.infinity,
                text: AppLocalizations.of(context)!.accept,
                enabled: _languageSelected.isNotEmpty,
                onPressed: _changeLanguage)
          ],
        ),
      ),
    );
  }

  Widget _buildFlag(String language) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.languageIcon / 2),
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.languageIcon / 2),
        color: Colors.transparent,
        child: InkWell(
          radius: AppSizes.languageIcon / 2,
          onTap: () {
            setState(() {
              _languageSelected = language;
            });
          },
          child: Stack(children: [
            Image.asset("assets/images/$language.webp", fit: BoxFit.cover),
            if (_languageSelected != language)
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.whiteOverlay,
                  shape: BoxShape.circle,
                ),
              ),
          ]),
        ),
      ),
    );
  }

  void changeErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> _changeLanguage() async {
    FocusScope.of(context).unfocus();
    changeErrorMessage("");
    final loginResponse = await widget._selectLanguageUseCase.execute(_languageSelected);
    loginResponse.fold(
      onSuccess: (_) {
        context.navigateToSplash();
      },
      onFailure: (message, errorType) {
        changeErrorMessage(message);
      },
    );
  }
}
