import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/entities/guide_point.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/network_images.dart';
import 'package:treveler/util/app_icons.dart';

class GuidePointItem extends StatelessWidget {
  final GuidePoint _guidePoint;
  final int _index;
  final bool _isPremium;

  const GuidePointItem(this._guidePoint, this._index, this._isPremium,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLocked = _guidePoint.isLocked && !_isPremium;

    final textScaleFactor =
        MediaQuery.of(context).textScaler.scale(AppSizes.fontMedium) /
            AppSizes.fontMedium;
    double baseHeight = 80;
    double dynamicHeight = baseHeight * textScaleFactor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      child: Container(
        height: dynamicHeight,
        color: AppColors.lightGrey,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: AppSizes.marginSmall),
              child: Icon(AppIcons.ic_point_big,
                  color: AppColors.primary, size: AppSizes.guidePointBigIcon),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.marginSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.point_x(_index),
                        style: AppTextStyles.smallSubtitle),
                    buildName()
                  ],
                ),
              ),
            ),
            SizedBox(
              width: AppSizes.guidePointThumbnailImageWidth,
              height: dynamicHeight,
              child: ClipRect(
                child: isLocked
                    ? Stack(alignment: Alignment.center, children: [
                        buildImage(),
                        buildLock(),
                      ])
                    : buildImage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildLock() {
    return Container(
      width: AppSizes.guidePointLockerBackground,
      height: AppSizes.guidePointLockerBackground,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(AppSizes.guidePointLockerBackground / 2),
      ),
      child: const Center(
        child: Icon(
          AppIcons.ic_password,
          size: AppSizes.guidePointLocker,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget buildImage() {
    return NetworkImages(
      fit: BoxFit.cover,
      width: AppSizes.guidePointThumbnailImageWidth,
      image: _guidePoint.image,
    );
  }

  Flexible buildName() {
    return Flexible(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(_guidePoint.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.mediumHighlight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
