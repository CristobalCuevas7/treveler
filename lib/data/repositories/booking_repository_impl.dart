import 'package:treveler/domain/datasources/booking_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart' as ApiResult;
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _bookingRemoteDataSource;

  BookingRepositoryImpl(this._bookingRemoteDataSource);

  @override
  Future<Result<List<Booking>>> getAllBooking() async {
    return await _bookingRemoteDataSource.getAllBooking().toResult();
  }

  @override
  Future<Result<void>> activateBooking(Booking booking) async {
    return await _bookingRemoteDataSource.activateBooking(booking).toResult();
  }

  @override
  Future<Result<Booking>> addBooking(String bookingReference) async {
    return await _bookingRemoteDataSource.addBooking(bookingReference).toResult();
  }

  @override
  Future<Result<Booking>> buyBooking(String purchaseId, String platform, int transactionDate, int numberOfDays, DiscountCode? discountCode) async {
    return await _bookingRemoteDataSource.buyBooking(purchaseId, platform, transactionDate, numberOfDays, discountCode).toResult();
  }
}
