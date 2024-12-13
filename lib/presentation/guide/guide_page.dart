import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/config/navigation.dart';
import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/get_all_guides_usecase.dart';
import 'package:treveler/presentation/guide/guide_item.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:treveler/util/log.dart';

class GuidePage extends StatefulWidget {
  final GetAllGuidesUseCase _getAllGuidesUseCase;

  const GuidePage(this._getAllGuidesUseCase, {super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  List<Guide> _guideList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGuideData();
  }

  void _fetchGuideData() async {
    final result = await widget._getAllGuidesUseCase.execute();
    result.fold(
      onSuccess: (guideList) {
        Log.show("Success in get guides");
        setState(() {
          _guideList = guideList;
          _isLoading = false;
        });
      },
      onFailure: (message, errorType) {
        _isLoading = false;
        Log.show("Error in get guides $message");
        // Handle the error, e.g., show a snackbar or a dialog with the error message
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _guideList.isEmpty
                ? Center(
                    child: Text(
                    AppLocalizations.of(context)!.no_guides_found,
                    style: const TextStyle(color: AppColors.subtitle),
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _guideList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.marginRegular),
                          child: ScreenHeader(
                            title: AppLocalizations.of(context)!.guides,
                          ),
                        );
                      }
                      index -= 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.marginSmall),
                        child: InkWell(
                            onTap: () {
                              context.navigateToGuideDetails(_guideList[index]);
                            },
                            child: GuideItem(_guideList[index])),
                      );
                    },
                  ),
      ),
    );
  }
}
