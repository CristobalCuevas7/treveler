import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/usecases/activate_booking_usecase.dart';
import 'package:treveler/domain/usecases/fetch_premium_usecase.dart';
import 'package:treveler/domain/usecases/get_all_bookings_usecase.dart';
import 'package:treveler/presentation/booking/booking_item.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/ui/custom_app_bar.dart';
import 'package:treveler/ui/app_alert_dialog.dart';
import 'package:treveler/ui/screen_header.dart';
import 'package:treveler/ui/snack_bar_service.dart';

class BookingPage extends StatefulWidget {
  final GetAllBookingsUseCase _getAllBookingsUseCase;
  final ActivateBookingUseCase _activateBookingUseCase;
  final FetchPremiumUseCase _fetchPremiumUseCase;

  const BookingPage(this._getAllBookingsUseCase, this._activateBookingUseCase, this._fetchPremiumUseCase, {super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Booking> _bookingList = [];

  @override
  void initState() {
    super.initState();
    _fetchBooking();
  }

  Future<void> _fetchBooking() async {
    final result = await widget._getAllBookingsUseCase.execute();
    result.fold(
      onSuccess: (bookingList) {
        setState(() {
          _bookingList = bookingList;
        });
      },
      onFailure: (message, errorType) {
        snackBarService.showErrorSnackBar(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: Container(
          padding: const EdgeInsets.all(AppSizes.marginRegular),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: AppLocalizations.of(context)!.booking,
              ),
              const SizedBox(height: AppSizes.marginRegular),
              Expanded(
                child: ListView.separated(
                  itemCount: _bookingList.length,
                  itemBuilder: (context, index) {
                    return BookingItem(_bookingList[index], (booking) {
                      AppAlertDialog.show(
                          context: context,
                          description: AppLocalizations.of(context)!.activate_booking_confirmation,
                          primaryButtonText: AppLocalizations.of(context)!.yes,
                          primaryButtonAction: () async {
                            await _activateBooking(booking);
                          },
                          secondaryButtonText: AppLocalizations.of(context)!.no);
                    });
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: AppSizes.marginSmall, color: Colors.transparent),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _activateBooking(Booking booking) async {
    final result = await widget._activateBookingUseCase.execute(booking);
    await result.fold(onSuccess: (_) async {
      await _fetchBooking();
      await widget._fetchPremiumUseCase.execute();
      await Future.delayed(const Duration(seconds: 2));
    }, onFailure: (message, error) {
      snackBarService.showErrorSnackBar(message);
    });
  }
}
