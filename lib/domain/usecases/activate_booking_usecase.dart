import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/booking_repository.dart';

class ActivateBookingUseCase {
  final BookingRepository _bookingRepository;

  ActivateBookingUseCase(this._bookingRepository);

  Future<Result<bool>> execute(Booking booking) async {
    try {
      Result<void> result = await _bookingRepository.activateBooking(booking);
      return result.fold(onSuccess: (_) {
        return const Success(true);
      }, onFailure: (message, errorType) {
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      return Failure(
        message: 'An error occurred while logging in.',
        errorType: error.runtimeType,
      );
    }
  }
}
