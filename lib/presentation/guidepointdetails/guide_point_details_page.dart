import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:treveler/domain/entities/guide_point.dart';
import 'package:treveler/domain/entities/location.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/style/text_styles.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_audio_player.dart';
import 'package:treveler/ui/network_images.dart';
import 'package:treveler/ui/primary_button.dart';
import 'package:treveler/ui/screen_header.dart';

class GuidePointDetailsPage extends StatefulWidget {
  final GuidePoint _guidePoint;

  const GuidePointDetailsPage(this._guidePoint, {super.key});

  @override
  State<GuidePointDetailsPage> createState() => _GuidePointDetailsPageState();
}

class _GuidePointDetailsPageState extends State<GuidePointDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.marginRegular),
          child: Column(
            children: [
              ScreenHeader(title: widget._guidePoint.name),
              const SizedBox(height: AppSizes.marginRegular),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                child: NetworkImages(
                  fit: BoxFit.cover,
                  image: widget._guidePoint.image,
                  height: AppSizes.guideDetailsImageHeight,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: AppSizes.marginRegular),
              AppAudioPlayer(widget._guidePoint),
              const SizedBox(height: AppSizes.marginRegular),
              Text(widget._guidePoint.description, style: AppTextStyles.medium),
              const SizedBox(height: AppSizes.marginRegular),
              PrimaryButton(
                  width: double.infinity,
                  withLoading: true,
                  text: AppLocalizations.of(context)!.navigate_here,
                  onPressed: () async {
                    await openMap(widget._guidePoint.location);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openMap(Location location) async {
    MapsLauncher.launchCoordinates(location.latitude, location.longitude);
  }
}
