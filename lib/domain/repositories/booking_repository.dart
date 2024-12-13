import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/result.dart';

abstract class BookingRepository {
  Future<Result<List<Booking>>> getAllBooking();

  Future<Result<void>> activateBooking(Booking booking);

  Future<Result<Booking>> addBooking(String bookingReference);

  Future<Result<Booking>> buyBooking(String purchaseId, String platform, int transactionDate, int numberOfDays, DiscountCode? discountCode);
}
