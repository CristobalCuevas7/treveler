import 'package:flutter/material.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/util/app_icons.dart';

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool arrow;
  final Function? onTap;

  const ProfileItem({super.key, required this.icon, required this.text, this.arrow = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap?.call();
      },
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.lightGrey, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.marginSmall),
          child: Row(
            children: [
              Icon(icon),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginSmall),
                  child: Text(text, style: AppTextStyles.medium),
                ),
              ),
              if (arrow) const Icon(AppIcons.ic_arrow, color: AppColors.text)
            ],
          ),
        ),
      ),
    );
  }
}
