import 'package:flutter/material.dart';
import 'package:treveler/style/text_styles.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const ScreenHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.screenTitle),
        if (subtitle != null) Text(subtitle!, style: AppTextStyles.medium),
      ]),
    );
  }
}
