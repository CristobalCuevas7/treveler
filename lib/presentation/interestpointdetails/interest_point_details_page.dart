import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/domain/entities/location.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/network_images.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:url_launcher/url_launcher.dart';

class InterestPointDetailPage extends StatefulWidget {
  final InterestPoint _interestPoint;

  const InterestPointDetailPage(this._interestPoint, {super.key});

  @override
  State<InterestPointDetailPage> createState() => _InterestPointDetailPageState();
}

class _InterestPointDetailPageState extends State<InterestPointDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.marginRegular),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenHeader(title: widget._interestPoint.name),
                  Row(
                    children: [
                      Text("${widget._interestPoint.distance}km", style: AppTextStyles.mediumSubtitle),
                    ],
                  ),
                  const SizedBox(height: AppSizes.marginRegular),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                    child: NetworkImages(
                      fit: BoxFit.cover,
                      image: widget._interestPoint.image,
                      height: AppSizes.guideDetailsImageHeight,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: AppSizes.marginRegular),
                  Text(widget._interestPoint.description, style: AppTextStyles.medium),
                  const SizedBox(height: AppSizes.marginRegular),
                  if (widget._interestPoint.instagram != null) buildInstagram(),
                  if (widget._interestPoint.website != null) buildWebsite(),
                ],
              ),
            ),
            buildNavigateHere(context)
          ],
        ),
      ),
    );
  }

  Widget buildNavigateHere(BuildContext context) {
    return widget._interestPoint.price != null
        ? Container(
            padding: const EdgeInsets.all(AppSizes.marginRegular),
            color: AppColors.lightGrey,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget._interestPoint.price ?? "", style: AppTextStyles.mediumHighlight),
                      Text(AppLocalizations.of(context)!.per_person, style: AppTextStyles.small),
                    ],
                  ),
                ),
                Expanded(
                  child: PrimaryButton(
                      width: double.infinity,
                      withLoading: true,
                      text: AppLocalizations.of(context)!.navigate_here,
                      onPressed: () async {
                        await _openMap(widget._interestPoint.location);
                      }),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.marginRegular, bottom: AppSizes.marginRegular, right: AppSizes.marginRegular),
            child: PrimaryButton(
                width: double.infinity,
                withLoading: true,
                text: AppLocalizations.of(context)!.navigate_here,
                onPressed: () async {
                  await _openMap(widget._interestPoint.location);
                }),
          );
  }

  InkWell buildWebsite() {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(widget._interestPoint.website!));
      },
      child: Text(AppLocalizations.of(context)!.website_x(widget._interestPoint.website!),
          style: const TextStyle(color: AppColors.primary, fontSize: AppSizes.fontMedium)),
    );
  }

  Widget buildInstagram() {
    return Column(children: [
      InkWell(
        onTap: () async {
          await launchUrl(Uri.parse(widget._interestPoint.instagram!));
        },
        child: Text(AppLocalizations.of(context)!.instagram_x(widget._interestPoint.instagram!),
            style: const TextStyle(color: AppColors.primary, fontSize: AppSizes.fontMedium)),
      ),
      const SizedBox(height: AppSizes.marginSmall),
    ]);
  }

  Future<void> _openMap(Location location) async {
    MapsLauncher.launchCoordinates(location.latitude, location.longitude);
  }
}
