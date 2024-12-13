import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/booking_repository.dart';

class AddBookingUseCase {
  final BookingRepository _bookingRepository;

  AddBookingUseCase(this._bookingRepository);

  Future<Result<Booking>> execute(String bookingReference) async {
    try {
      return _bookingRepository.addBooking(bookingReference);
    } catch (error) {
      return const Failure(message: "Unexpected error");
    }
  }
}
