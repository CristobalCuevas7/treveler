import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/presentation/tips/tips_item.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/screen_header.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.marginRegular),
          child: Column(
            children: [
              ScreenHeader(
                  title: AppLocalizations.of(context)!.tips_title,
                  subtitle: AppLocalizations.of(context)!.tips_subtitle),
              const SizedBox(height: AppSizes.marginRegular),
              TipsItem(index: 1, text: AppLocalizations.of(context)!.tips_one),
              const SizedBox(height: AppSizes.marginRegular),
              TipsItem(index: 2, text: AppLocalizations.of(context)!.tips_two),
              const SizedBox(height: AppSizes.marginRegular),
              TipsItem(index: 3, text: AppLocalizations.of(context)!.tips_three),
              const SizedBox(height: AppSizes.marginRegular),
              TipsItem(index: 4, text: AppLocalizations.of(context)!.tips_four)
            ],
          ),
        ),
      ),
    );
  }
}
