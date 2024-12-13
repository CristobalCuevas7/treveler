import 'package:flutter/material.dart';
import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/network_images.dart';
import 'package:treveler/util/app_icons.dart';

class GuideItem extends StatelessWidget {
  final Guide _guide;

  const GuideItem(this._guide, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          child: NetworkImages(
            fit: BoxFit.cover,
            image: _guide.image,
            height: AppSizes.guideItemImageHeight,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: AppSizes.marginSmall),
        Row(
          children: [
            Text(_guide.name, style: AppTextStyles.mediumHighlight),
            const Spacer(),
            const Icon(AppIcons.ic_point_small, size: AppSizes.fontSmall, color: AppColors.primary),
            Text(_guide.points.length.toString(), style: const TextStyle(color: AppColors.primary))
          ],
        ),
        Text("${_guide.totalDistance}km", style: AppTextStyles.smallSubtitle)
      ],
    );
  }
}
