import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/network_images.dart';
import 'package:treveler/util/app_icons.dart';

class InterestPointItem extends StatelessWidget {
  final bool _isPremium;
  final InterestPoint _interestPoint;

  const InterestPointItem(this._interestPoint, this._isPremium, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isBlocked = !_isPremium && _interestPoint.requiresPayment;

    return Stack(
      children: [
        _buildContent(isBlocked),
      ],
    );
  }

  Widget _buildContent(bool isBlocked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            isBlocked
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSizes.cardRadius),
                        child: _buildImage(),
                      ),
                      buildLock(),
                    ],
                  )
                : _buildImage(),
            Positioned(
              top: AppSizes.interestPointLabelMargin,
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppSizes.radius),
                        bottomRight: Radius.circular(AppSizes.radius))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: AppSizes.marginSmall / 2,
                      bottom: AppSizes.marginSmall / 2,
                      left: AppSizes.marginSmall,
                      right: AppSizes.marginRegular),
                  child: Text(
                    _interestPoint.category.name,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSizes.fontMedium,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            if (_interestPoint.price != null)
              Positioned(
                right: 0,
                bottom: AppSizes.interestPointLabelMargin,
                child: Container(
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radius),
                          bottomLeft: Radius.circular(AppSizes.radius))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: AppSizes.marginSmall / 2,
                        bottom: AppSizes.marginSmall / 2,
                        right: AppSizes.marginSmall,
                        left: AppSizes.marginRegular),
                    child: _blockWidget(
                        isBlocked,
                        Text(_interestPoint.price!,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: AppSizes.fontMedium,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
              )
          ],
        ),
        const SizedBox(height: AppSizes.marginSmall),
        _blockWidget(
            isBlocked,
            Text(_interestPoint.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.mediumHighlight)),
        _blockWidget(
            isBlocked,
            Text("${_interestPoint.distance?.toStringAsFixed(2) ?? 0}km",
                style: AppTextStyles.smallSubtitle))
      ],
    );
  }

  AspectRatio _buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: NetworkImages(
          fit: BoxFit.cover,
          image: _interestPoint.image,
        ),
      ),
    );
  }

  Widget buildLock() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
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
        ),
      ),
    );
  }

  Widget _blockWidget(bool isBlocked, Widget widget) {
    return isBlocked
        ? ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: widget)
        : widget;
  }
}
