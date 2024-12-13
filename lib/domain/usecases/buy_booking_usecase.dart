import 'dart:io';

import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/booking_repository.dart';

class BuyBookingUseCase {
  final BookingRepository _bookingRepository;

  BuyBookingUseCase(this._bookingRepository);

  Future<Result<Booking>> execute(String purchaseId, int transactionDate, int numberOfDays, DiscountCode? discountCode) async {
    try {
      String platform = Platform.isAndroid
          ? "android"
          : Platform.isIOS
              ? "ios"
              : "unknown";

      return _bookingRepository.buyBooking(purchaseId, platform, transactionDate, numberOfDays, discountCode);
    } catch (error) {
      return const Failure(message: "Unexpected error");
    }
  }
}
