import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/discount_code.dart';

abstract class BookingRemoteDataSource {
  Future<ApiResult<List<Booking>>> getAllBooking();

  Future<ApiResult<void>> activateBooking(Booking booking);

  Future<ApiResult<Booking>> addBooking(String bookingReference);

  Future<ApiResult<Booking>> buyBooking(String purchaseId, String platform, int transactionDate, int numberOfDays, DiscountCode? discountCode);
}
